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
        SendOptions, Wallet as CdkWallet,
    },
};
use cdk_redb::WalletRedbDatabase;
use flutter_rust_bridge::frb;
use tokio::{
    sync::{broadcast, Mutex},
    time::sleep,
};

use crate::frb_generated::StreamSink;

use super::{error::Error, token::Token};

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

    pub async fn is_token_spent(&self, token: Token) -> Result<bool, Error> {
        let token: CdkToken = token.try_into()?;
        let proof_states = self.inner.check_proofs_spent(token.proofs()).await?;
        Ok(proof_states
            .iter()
            .any(|state| state.state == ProofState::Spent))
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
                        });
                        if state_res.state == CdkMintQuoteState::Paid {
                            if let Ok(mint_proofs) =
                                _self.inner.mint(&quote.id, SplitTarget::None, None).await
                            {
                                let mint_amount = mint_proofs.total_amount().unwrap_or_default();
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
                                });
                            }
                        }
                        _self.update_balance_streams().await;
                        break;
                    }
                }
                sleep(Duration::from_secs(3)).await;
            }
        });
        Ok(())
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
                SplitTarget::None,
                &p2pk_signing_keys,
                &preimages,
            )
            .await?
            .into();
        self.update_balance_streams().await;
        Ok(amount)
    }

    pub async fn prepare_send(
        &self,
        amount: u64,
        memo: Option<String>,
        pubkey: Option<String>,
    ) -> Result<PreparedSend, Error> {
        let pubkey = pubkey.map(|s| PublicKey::from_str(&s)).transpose()?;
        let opts = SendOptions {
            memo,
            conditions: pubkey.map(|pubkey| SpendingConditions::new_p2pk(pubkey, None)),
            ..Default::default()
        };
        let prepared_send = self.inner.prepare_send(amount.into(), opts).await?;
        Ok(prepared_send.into())
    }

    pub async fn send(&self, send: PreparedSend) -> Result<String, Error> {
        let token = self.inner.send(send.inner).await?.to_string();
        self.update_balance_streams().await;
        Ok(token)
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
        }
    }
}

pub enum MintQuoteState {
    Unpaid,
    Paid,
    Issued,
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

#[derive(Clone)]
pub struct MultiMintWallet {
    pub unit: String,

    seed: Vec<u8>,
    target_proof_count: Option<usize>,
    localstore: WalletDatabase,

    wallets: Arc<Mutex<HashMap<MintUrl, Wallet>>>,
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
        let wallet = Wallet::new(
            mint_url.to_string(),
            self.unit.clone(),
            self.seed.clone(),
            self.target_proof_count,
            self.localstore.clone(),
        )?;
        self.wallets.lock().await.insert(mint_url, wallet);
        Ok(())
    }

    pub async fn add_wallet(&self, wallet: Wallet) -> Result<(), Error> {
        self.wallets
            .lock()
            .await
            .insert(MintUrl::from_str(&wallet.mint_url)?, wallet);
        Ok(())
    }

    pub async fn get_wallet(&self, mint_url: &str) -> Result<Option<Wallet>, Error> {
        let mint_url = MintUrl::from_str(mint_url)?;
        let wallets = self.wallets.lock().await;
        if let Some(wallet) = wallets.get(&mint_url) {
            return Ok(Some(wallet.clone()));
        }
        Ok(None)
    }

    pub async fn list_mints(&self) -> Vec<String> {
        self.wallets
            .lock()
            .await
            .keys()
            .map(|k| k.to_string())
            .collect()
    }

    pub async fn list_wallets(&self) -> Vec<Wallet> {
        self.wallets.lock().await.values().cloned().collect()
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
        Ok(())
    }
}

#[derive(Clone)]
pub struct WalletDatabase {
    inner: WalletRedbDatabase,
}

impl WalletDatabase {
    #[frb(sync)]
    pub fn new(path: &str) -> Result<Self, Error> {
        let path = Path::new(path);
        let inner = WalletRedbDatabase::new(path)?;
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
