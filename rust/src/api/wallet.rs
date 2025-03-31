use std::{collections::HashMap, path::Path, str::FromStr, sync::Arc, time::Duration};

use cdk::{
    amount::{Amount, SplitTarget},
    cdk_database::WalletDatabase as _,
    mint_url::MintUrl,
    nuts::{
        nut00::ProofsMethods, CurrencyUnit, MintQuoteState as CdkMintQuoteState, PublicKey,
        SecretKey, SpendingConditions, State as ProofState, Token as CdkToken,
    },
    util::hex,
    wallet::{
        MeltQuote as CdkMeltQuote, MintQuote as CdkMintQuote, PreparedSend as CdkPreparedSend,
        ReceiveOptions, SendMemo, SendOptions, Wallet as CdkWallet,
    },
};
use cdk_common::{
    wallet::{Transaction as CdkTransaction, TransactionDirection as CdkTransactionDirection},
    PaymentRequestPayload,
};
use cdk_sqlite::WalletSqliteDatabase;
use flutter_rust_bridge::frb;
use tokio::{
    sync::{broadcast, mpsc, Mutex},
    time::sleep,
};

use crate::frb_generated::StreamSink;

use super::{
    bitcoin::BitcoinAddress,
    error::Error,
    mint::Mint,
    payment_request::{PaymentRequest, TransportType},
    token::Token,
};

#[derive(Clone)]
pub struct Wallet {
    pub mint_url: String,
    pub unit: String,

    balance_broadcast: broadcast::Sender<u64>,
    inner: CdkWallet,
}

impl Wallet {
    #[frb(sync)]
    pub fn new(
        mint_url: String,
        unit: String,
        seed: Vec<u8>,
        target_proof_count: Option<usize>,
        localstore: WalletDatabase,
    ) -> Result<Self, Error> {
        let unit = CurrencyUnit::from_str(&unit).unwrap_or(CurrencyUnit::Custom(unit.to_string()));
        Ok(Self {
            mint_url: mint_url.clone(),
            unit: unit.to_string(),
            balance_broadcast: broadcast::channel(1).0,
            inner: CdkWallet::new(
                &mint_url,
                unit,
                Arc::new(localstore.inner),
                &seed,
                target_proof_count,
            )?,
        })
    }

    #[frb(sync)]
    pub fn new_from_hex_seed(
        mint_url: String,
        unit: String,
        seed: String,
        target_proof_count: Option<usize>,
        localstore: WalletDatabase,
    ) -> Result<Self, Error> {
        let seed = hex::decode(seed)?;
        Self::new(mint_url, unit, seed, target_proof_count, localstore)
    }

    pub async fn balance(&self) -> Result<u64, Error> {
        Ok(self.inner.total_balance().await?.into())
    }

    pub async fn stream_balance(&self, sink: StreamSink<u64>) -> Result<(), Error> {
        let mut receiver = self.balance_broadcast.subscribe();
        let _ = sink.add(self.balance().await?);
        flutter_rust_bridge::spawn(async move {
            loop {
                match receiver.recv().await {
                    Ok(balance) => {
                        if sink.add(balance).is_err() {
                            break;
                        }
                    }
                    Err(_) => break,
                }
            }
        });
        Ok(())
    }

    pub async fn get_mint(&self) -> Result<Mint, Error> {
        let info = self.inner.get_mint_info().await?;
        Ok(Mint {
            url: self.mint_url.clone(),
            balance: self.balance().await?,
            info: info.map(|info| info.into()),
        })
    }

    pub async fn is_token_spent(&self, token: Token) -> Result<bool, Error> {
        let token: CdkToken = token.try_into()?;
        let proof_states = self.inner.check_proofs_spent(token.proofs()).await?;
        Ok(proof_states
            .iter()
            .any(|state| state.state == ProofState::Spent))
    }

    pub async fn list_transactions(
        &self,
        direction: Option<TransactionDirection>,
    ) -> Result<Vec<Transaction>, Error> {
        Ok(self
            .inner
            .list_transactions(direction.map(|d| d.into()))
            .await?
            .into_iter()
            .map(|tx| tx.into())
            .collect())
    }

    pub async fn melt_quote(&self, request: String) -> Result<MeltQuote, Error> {
        Ok(self.inner.melt_quote(request, None).await?.into())
    }

    pub async fn melt(&self, quote: MeltQuote) -> Result<u64, Error> {
        let melted = self.inner.melt(&quote.id).await?;
        self.update_balance_streams().await;
        Ok(melted.total_amount().into())
    }

    pub async fn mint(
        &self,
        amount: u64,
        description: Option<String>,
        sink: StreamSink<MintQuote>,
    ) -> Result<(), Error> {
        let mint_url = self.mint_url()?;
        let unit = self.unit();
        let quote = self.inner.mint_quote(amount.into(), description).await?;
        let _ = sink.add(MintQuote::from(quote.clone()));
        let _self = self.clone();
        flutter_rust_bridge::spawn(async move {
            loop {
                if let Ok(state_res) = _self.inner.mint_quote_state(&quote.id).await {
                    if state_res.state == CdkMintQuoteState::Issued
                        || state_res.state == CdkMintQuoteState::Paid
                    {
                        let _ = sink.add(MintQuote {
                            id: state_res.quote,
                            request: state_res.request,
                            amount: quote.amount.into(),
                            expiry: state_res.expiry,
                            state: state_res.state.into(),
                            token: None,
                            error: None,
                        });
                        if state_res.state == CdkMintQuoteState::Paid {
                            match _self.inner.mint(&quote.id, SplitTarget::None, None).await {
                                Ok(mint_proofs) => {
                                    let mint_amount =
                                        mint_proofs.total_amount().unwrap_or_default();
                                    let _ = sink.add(MintQuote {
                                        id: quote.id,
                                        request: quote.request,
                                        amount: mint_amount.into(),
                                        expiry: Some(quote.expiry),
                                        state: CdkMintQuoteState::Issued.into(),
                                        token: Token::try_from(CdkToken::new(
                                            mint_url,
                                            mint_proofs,
                                            None,
                                            unit,
                                        ))
                                        .ok(),
                                        error: None,
                                    });
                                }
                                Err(e) => {
                                    let _ = sink.add(MintQuote {
                                        id: quote.id,
                                        request: quote.request,
                                        amount: quote.amount.into(),
                                        expiry: Some(quote.expiry),
                                        state: MintQuoteState::Error,
                                        token: None,
                                        error: Some(e.to_string()),
                                    });
                                }
                            }
                            _self.update_balance_streams().await;
                            break;
                        }
                    }
                }
                sleep(Duration::from_secs(3)).await;
            }
        });
        Ok(())
    }

    pub async fn prepare_pay_request(
        &self,
        request: PaymentRequest,
    ) -> Result<PreparedSend, Error> {
        if !request.validate(self.mint_url()?, self.unit()) {
            return Err(Error::InvalidInput);
        }
        self.prepare_send(
            request.amount.ok_or(Error::InvalidInput)?,
            None,
            None,
            Some(false),
        )
        .await
    }

    pub async fn pay_request(
        &self,
        request: PaymentRequest,
        send: PreparedSend,
        memo: Option<String>,
        include_memo: Option<bool>,
    ) -> Result<(), Error> {
        if !request.validate(self.mint_url()?, self.unit()) {
            return Err(Error::InvalidInput);
        }
        let token = self.send(send, memo.clone(), include_memo).await?;

        let transport = request
            .transports
            .iter()
            .find(|t| t._type == TransportType::HttpPost)
            .ok_or(Error::InvalidInput)?;

        let payload = PaymentRequestPayload {
            id: request.payment_id,
            memo,
            mint: self.mint_url()?,
            unit: self.unit(),
            proofs: token.proofs()?,
        };

        let client = reqwest::Client::new();
        let res = client.post(&transport.target).json(&payload).send().await?;

        let status = res.status();
        if status.is_success() {
            Ok(())
        } else {
            Err(Error::Reqwest(format!("HTTP error: {}", status)))
        }
    }

    pub async fn receive(
        &self,
        token: Token,
        signing_key: Option<String>,
        preimage: Option<String>,
    ) -> Result<u64, Error> {
        let p2pk_signing_key = signing_key.map(|s| SecretKey::from_str(&s)).transpose()?;
        let p2pk_signing_keys = match p2pk_signing_key {
            Some(p2pk_signing_key) => vec![p2pk_signing_key],
            None => vec![],
        };
        let preimages = match preimage {
            Some(preimage) => vec![preimage],
            None => vec![],
        };
        let amount = self
            .inner
            .receive(
                &token.encoded,
                ReceiveOptions {
                    p2pk_signing_keys,
                    preimages,
                    ..Default::default()
                },
            )
            .await?
            .into();
        self.update_balance_streams().await;
        Ok(amount)
    }

    pub async fn restore(&self) -> Result<(), Error> {
        self.inner.restore().await?;
        self.update_balance_streams().await;
        Ok(())
    }

    pub async fn prepare_send(
        &self,
        amount: u64,
        pubkey: Option<String>,
        memo: Option<String>,
        include_memo: Option<bool>,
    ) -> Result<PreparedSend, Error> {
        let pubkey = pubkey.map(|s| PublicKey::from_str(&s)).transpose()?;
        let send_memo = memo.map(|m| SendMemo {
            memo: m,
            include_memo: include_memo.unwrap_or_default(),
        });
        let opts = SendOptions {
            memo: send_memo,
            conditions: pubkey.map(|pubkey| SpendingConditions::new_p2pk(pubkey, None)),
            ..Default::default()
        };
        let prepared_send = self.inner.prepare_send(amount.into(), opts).await?;
        Ok(prepared_send.into())
    }

    pub async fn send(
        &self,
        send: PreparedSend,
        memo: Option<String>,
        include_memo: Option<bool>,
    ) -> Result<Token, Error> {
        let send_memo = memo.map(|m| SendMemo {
            memo: m,
            include_memo: include_memo.unwrap_or_default(),
        });
        let token = self.inner.send(send.inner, send_memo).await?.to_string();
        self.update_balance_streams().await;
        Ok(Token::from_str(&token)?)
    }

    pub async fn cancel_send(&self, send: PreparedSend) -> Result<(), Error> {
        self.inner.cancel_send(send.inner).await?;
        Ok(())
    }

    pub async fn reclaim_send(&self, token: Token) -> Result<(), Error> {
        self.inner.reclaim_unspent(token.proofs()?).await?;
        self.inner.check_all_pending_proofs().await?;
        self.update_balance_streams().await;
        Ok(())
    }

    fn mint_url(&self) -> Result<MintUrl, Error> {
        Ok(MintUrl::from_str(&self.mint_url)?)
    }

    fn unit(&self) -> CurrencyUnit {
        CurrencyUnit::from_str(&self.unit).unwrap_or(CurrencyUnit::Custom(self.unit.clone()))
    }

    async fn update_balance_streams(&self) {
        let balance = self
            .inner
            .total_balance()
            .await
            .unwrap_or(Amount::ZERO)
            .into();
        let _ = self.balance_broadcast.send(balance);
    }
}

pub struct MeltQuote {
    pub id: String,
    pub request: String,
    pub amount: u64,
    pub fee_reserve: u64,
    pub expiry: u64,
}

impl From<CdkMeltQuote> for MeltQuote {
    fn from(quote: CdkMeltQuote) -> Self {
        Self {
            id: quote.id,
            request: quote.request,
            amount: quote.amount.into(),
            fee_reserve: quote.fee_reserve.into(),
            expiry: quote.expiry,
        }
    }
}

pub struct MintQuote {
    pub id: String,
    pub request: String,
    pub amount: u64,
    pub expiry: Option<u64>,
    pub state: MintQuoteState,
    pub token: Option<Token>,
    pub error: Option<String>,
}

impl From<CdkMintQuote> for MintQuote {
    fn from(quote: CdkMintQuote) -> Self {
        Self {
            id: quote.id,
            request: quote.request,
            amount: quote.amount.into(),
            expiry: Some(quote.expiry),
            state: quote.state.into(),
            token: None,
            error: None,
        }
    }
}

pub enum MintQuoteState {
    Unpaid,
    Paid,
    Issued,
    Error,
}

impl From<CdkMintQuoteState> for MintQuoteState {
    fn from(state: CdkMintQuoteState) -> Self {
        match state {
            CdkMintQuoteState::Unpaid => Self::Unpaid,
            CdkMintQuoteState::Paid => Self::Paid,
            CdkMintQuoteState::Issued => Self::Issued,
            CdkMintQuoteState::Pending => Self::Unpaid,
        }
    }
}

pub struct PreparedSend {
    pub amount: u64,
    pub swap_fee: u64,
    pub send_fee: u64,
    pub fee: u64,

    inner: CdkPreparedSend,
}

impl From<CdkPreparedSend> for PreparedSend {
    fn from(prepared_send: CdkPreparedSend) -> Self {
        Self {
            amount: prepared_send.amount().into(),
            swap_fee: prepared_send.swap_fee().into(),
            send_fee: prepared_send.send_fee().into(),
            fee: prepared_send.fee().into(),
            inner: prepared_send,
        }
    }
}

#[derive(PartialEq, Eq)]
pub struct Transaction {
    pub mint_url: String,
    pub direction: TransactionDirection,
    pub amount: u64,
    pub fee: u64,
    pub unit: String,
    pub ys: Vec<String>,
    pub timestamp: u64,
    pub memo: Option<String>,
    pub metadata: HashMap<String, String>,
}

impl From<CdkTransaction> for Transaction {
    fn from(tx: CdkTransaction) -> Self {
        Self {
            mint_url: tx.mint_url.to_string(),
            direction: tx.direction.into(),
            amount: tx.amount.into(),
            fee: tx.fee.into(),
            unit: tx.unit.to_string(),
            ys: tx.ys.iter().map(|y| y.to_string()).collect(),
            timestamp: tx.timestamp,
            memo: tx.memo,
            metadata: tx.metadata,
        }
    }
}

impl PartialOrd for Transaction {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Transaction {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.timestamp.cmp(&other.timestamp)
    }
}

#[derive(Clone, Copy, PartialEq, Eq)]
pub enum TransactionDirection {
    Incoming,
    Outgoing,
}

impl From<CdkTransactionDirection> for TransactionDirection {
    fn from(direction: CdkTransactionDirection) -> Self {
        match direction {
            CdkTransactionDirection::Incoming => Self::Incoming,
            CdkTransactionDirection::Outgoing => Self::Outgoing,
        }
    }
}

impl Into<CdkTransactionDirection> for TransactionDirection {
    fn into(self) -> CdkTransactionDirection {
        match self {
            Self::Incoming => CdkTransactionDirection::Incoming,
            Self::Outgoing => CdkTransactionDirection::Outgoing,
        }
    }
}

#[derive(Clone)]
pub struct MultiMintWallet {
    pub unit: String,

    seed: Vec<u8>,
    target_proof_count: Option<usize>,
    localstore: WalletDatabase,

    wallets: Arc<Mutex<HashMap<MintUrl, Wallet>>>,
    added_wallets: Arc<Mutex<Vec<mpsc::Sender<MintUrl>>>>,
}

impl MultiMintWallet {
    pub async fn new(
        unit: String,
        seed: Vec<u8>,
        target_proof_count: Option<usize>,
        localstore: WalletDatabase,
    ) -> Result<Self, Error> {
        let mints = localstore.inner.get_mints().await?;
        let mut wallets = HashMap::new();
        for (mint_url, _) in &mints {
            wallets.insert(
                mint_url.clone(),
                Wallet::new(
                    mint_url.to_string(),
                    unit.clone(),
                    seed.clone(),
                    target_proof_count,
                    localstore.clone(),
                )?,
            );
        }
        Ok(Self {
            unit: unit.to_string(),
            seed,
            target_proof_count,
            localstore,
            wallets: Arc::new(Mutex::new(wallets)),
            added_wallets: Arc::new(Mutex::new(Vec::new())),
        })
    }

    pub async fn new_from_hex_seed(
        unit: String,
        seed: String,
        target_proof_count: Option<usize>,
        localstore: WalletDatabase,
    ) -> Result<Self, Error> {
        let seed = hex::decode(seed)?;
        Ok(Self::new(unit, seed, target_proof_count, localstore).await?)
    }

    pub async fn add_mint(&self, mint_url: String) -> Result<(), Error> {
        let mint_url = MintUrl::from_str(&mint_url)?;
        let mut wallets = self.wallets.lock().await;
        if wallets.contains_key(&mint_url) {
            return Ok(());
        }

        let wallet = Wallet::new(
            mint_url.to_string(),
            self.unit.clone(),
            self.seed.clone(),
            self.target_proof_count,
            self.localstore.clone(),
        )?;
        wallets.insert(mint_url.clone(), wallet);
        let mut added_wallets = self.added_wallets.lock().await;
        let mut failed_senders = Vec::new();
        for (idx, sender) in added_wallets.iter().enumerate() {
            if sender.send(mint_url.clone()).await.is_err() {
                failed_senders.push(idx);
            }
        }
        for sender in failed_senders {
            added_wallets.remove(sender);
        }
        Ok(())
    }

    pub async fn add_wallet(&self, wallet: Wallet) -> Result<(), Error> {
        self.wallets
            .lock()
            .await
            .insert(MintUrl::from_str(&wallet.mint_url)?, wallet);
        Ok(())
    }

    pub async fn available_mints(
        &self,
        amount: Option<u64>,
        mint_urls: Option<Vec<String>>,
    ) -> Result<Vec<Mint>, Error> {
        let all_mint_urls = self
            .list_mints()
            .await?
            .into_iter()
            .map(|m| m.url)
            .collect();
        let mint_urls = mint_urls.unwrap_or(all_mint_urls);
        let wallets = self.wallets.lock().await;
        let mut mints = Vec::new();
        for mint_url in mint_urls {
            let mint_url = MintUrl::from_str(&mint_url)?;
            if let Some(wallet) = wallets.get(&mint_url) {
                let mint = wallet.get_mint().await?;
                if mint.balance >= amount.unwrap_or_default() {
                    mints.push(mint);
                }
            }
        }
        mints.sort();
        Ok(mints)
    }

    pub async fn create_or_get_wallet(&self, mint_url: String) -> Result<Wallet, Error> {
        let mint_url = MintUrl::from_str(&mint_url)?;
        let mut wallets = self.wallets.lock().await;
        if let Some(wallet) = wallets.get(&mint_url) {
            return Ok(wallet.clone());
        }
        let wallet = Wallet::new(
            mint_url.to_string(),
            self.unit.clone(),
            self.seed.clone(),
            self.target_proof_count,
            self.localstore.clone(),
        )?;
        wallets.insert(mint_url, wallet.clone());
        Ok(wallet)
    }

    pub async fn get_wallet(&self, mint_url: &str) -> Result<Option<Wallet>, Error> {
        let mint_url = MintUrl::from_str(mint_url)?;
        let wallets = self.wallets.lock().await;
        if let Some(wallet) = wallets.get(&mint_url) {
            return Ok(Some(wallet.clone()));
        }
        Ok(None)
    }

    pub async fn list_mints(&self) -> Result<Vec<Mint>, Error> {
        let wallets_guard = self.wallets.lock().await;
        let wallets = wallets_guard.values();
        let mut mints = Vec::new();
        for wallet in wallets {
            let mint = wallet.get_mint().await?;
            mints.push(mint);
        }
        mints.sort();
        Ok(mints)
    }

    pub async fn list_transactions(
        &self,
        direction: Option<TransactionDirection>,
        mint_url: Option<String>,
    ) -> Result<Vec<Transaction>, Error> {
        let wallets = self.wallets.lock().await;
        let mut transactions = Vec::new();

        if let Some(mint_url) = mint_url {
            let mint_url = MintUrl::from_str(&mint_url)?;
            if let Some(wallet) = wallets.get(&mint_url) {
                let wallet_transactions = wallet.list_transactions(direction).await?;
                transactions.extend(wallet_transactions);
            }
            transactions.sort();
            return Ok(transactions);
        }

        for wallet in wallets.values() {
            let wallet_transactions = wallet.list_transactions(direction).await?;
            transactions.extend(wallet_transactions);
        }
        transactions.sort();
        Ok(transactions)
    }

    pub async fn list_wallets(&self) -> Vec<Wallet> {
        self.wallets.lock().await.values().cloned().collect()
    }

    pub async fn remove_mint(&self, mint_url: String) -> Result<(), Error> {
        let mint_url = MintUrl::from_str(&mint_url)?;
        let mut wallets = self.wallets.lock().await;
        if let Some(wallet) = wallets.get(&mint_url) {
            if wallet.balance().await? > 0 {
                return Err(Error::WalletNotEmpty);
            }
        }
        wallets.remove(&mint_url);
        Ok(())
    }

    pub async fn select_wallet(
        &self,
        amount: Option<u64>,
        mint_urls: Option<Vec<String>>,
    ) -> Result<Option<Wallet>, Error> {
        let mints = self.available_mints(amount, mint_urls).await?;
        if let Some(mint) = mints.first() {
            return self.get_wallet(&mint.url).await;
        }
        Ok(None)
    }

    pub async fn total_balance(&self) -> Result<u64, Error> {
        let wallets = self.wallets.lock().await;
        let mut total = 0;
        for wallet in wallets.values() {
            total += wallet.balance().await?;
        }
        Ok(total)
    }

    pub async fn stream_balance(&self, sink: StreamSink<u64>) -> Result<(), Error> {
        let _ = sink.add(self.total_balance().await?);
        let wallets = self.wallets.lock().await;
        for wallet in wallets.values() {
            let wallet = wallet.clone();
            let sink = sink.clone();
            let _self = self.clone();
            flutter_rust_bridge::spawn(async move {
                let mut rx = wallet.balance_broadcast.subscribe();
                loop {
                    match rx.recv().await {
                        Ok(_) => {
                            let total = _self.total_balance().await.unwrap_or_default();
                            if sink.add(total).is_err() {
                                break;
                            }
                        }
                        Err(_) => break,
                    }
                }
            });
        }
        let (tx, mut rx) = mpsc::channel(1);
        self.added_wallets.lock().await.push(tx);
        let _self = self.clone();
        flutter_rust_bridge::spawn(async move {
            loop {
                match rx.recv().await {
                    Some(mint_url) => {
                        let wallet = match _self.create_or_get_wallet(mint_url.to_string()).await {
                            Ok(wallet) => wallet,
                            Err(_) => continue,
                        };
                        let sink = sink.clone();
                        let _self = _self.clone();
                        flutter_rust_bridge::spawn(async move {
                            let mut rx = wallet.balance_broadcast.subscribe();
                            loop {
                                match rx.recv().await {
                                    Ok(_) => {
                                        let total = _self.total_balance().await.unwrap_or_default();
                                        if sink.add(total).is_err() {
                                            break;
                                        }
                                    }
                                    Err(_) => break,
                                }
                            }
                        });
                    }
                    None => break,
                }
            }
        });
        Ok(())
    }
}

#[derive(Clone)]
pub struct WalletDatabase {
    inner: WalletSqliteDatabase,
}

impl WalletDatabase {
    pub async fn new(path: &str) -> Result<Self, Error> {
        let path = Path::new(path);
        let inner = WalletSqliteDatabase::new(path).await?;
        inner.migrate().await;
        Ok(Self { inner })
    }
}

#[frb(sync)]
pub fn generate_seed() -> Vec<u8> {
    rand::random::<[u8; 32]>().to_vec()
}

#[frb(sync)]
pub fn generate_hex_seed() -> String {
    hex::encode(rand::random::<[u8; 32]>())
}

#[frb(sync)]
pub fn parse_input(input: String) -> Result<ParseInputResult, Error> {
    let input = input.trim();
    if let Ok(req) = PaymentRequest::from_str(input) {
        return Ok(ParseInputResult::PaymentRequest(req));
    }
    if let Ok(token) = Token::from_str(input) {
        return Ok(ParseInputResult::Token(token));
    }
    if let Ok(addr) = BitcoinAddress::from_str(input) {
        return Ok(ParseInputResult::BitcoinAddress(addr));
    }
    Err(Error::InvalidInput)
}

pub enum ParseInputResult {
    BitcoinAddress(BitcoinAddress),
    PaymentRequest(PaymentRequest),
    Token(Token),
}
