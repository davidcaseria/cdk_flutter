use std::{collections::HashMap, path::Path, str::FromStr, sync::Arc, time::Duration};

use cdk::{
    amount::{Amount, SplitTarget},
    cdk_database::WalletDatabase as _,
    mint_url::MintUrl,
    nuts::{
        CurrencyUnit, MintQuoteState as CdkMintQuoteState, PublicKey, SecretKey, SpendingConditions,
    },
    util::hex,
    wallet::{MintQuote as CdkMintQuote, SendKind, Wallet as CdkWallet},
};
use cdk_redb::WalletRedbDatabase;
use flutter_rust_bridge::frb;
use tokio::{
    sync::{broadcast, Mutex},
    time::sleep,
};

use crate::frb_generated::StreamSink;

use super::error::Error;

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
        currency_unit: String,
        seed: String,
        target_proof_count: Option<usize>,
        localstore: WalletDatabase,
    ) -> Result<Self, Error> {
        let seed = hex::decode(seed)?;
        Self::new(
            mint_url,
            currency_unit,
            seed,
            target_proof_count,
            localstore,
        )
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

    pub async fn mint(
        &self,
        amount: u64,
        description: Option<String>,
        sink: StreamSink<MintQuote>,
    ) -> Result<(), Error> {
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
                        });
                        if state_res.state == CdkMintQuoteState::Paid {
                            if let Ok(mint_amount) =
                                _self.inner.mint(&quote.id, SplitTarget::None, None).await
                            {
                                let _ = sink.add(MintQuote {
                                    id: quote.id,
                                    request: quote.request,
                                    amount: mint_amount.into(),
                                    expiry: Some(quote.expiry),
                                    state: CdkMintQuoteState::Issued.into(),
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
        token: String,
        p2pk_signing_key: Option<String>,
        preimage: Option<String>,
    ) -> Result<u64, Error> {
        let p2pk_signing_key = p2pk_signing_key
            .map(|s| SecretKey::from_str(&s))
            .transpose()?;
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
            .receive(&token, SplitTarget::None, &p2pk_signing_keys, &preimages)
            .await?
            .into();
        self.update_balance_streams().await;
        Ok(amount)
    }

    pub async fn send(
        &self,
        amount: u64,
        memo: Option<String>,
        pubkey: Option<String>,
    ) -> Result<String, Error> {
        let pubkey = pubkey.map(|s| PublicKey::from_str(&s)).transpose()?;
        let conditions = pubkey.map(|pubkey| SpendingConditions::new_p2pk(pubkey, None));
        let token = self
            .inner
            .send(
                amount.into(),
                memo,
                conditions,
                &SplitTarget::None,
                &SendKind::OnlineExact,
                false,
            )
            .await?
            .to_string();
        self.update_balance_streams().await;
        Ok(token)
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

pub struct MintQuote {
    pub id: String,
    pub request: String,
    pub amount: u64,
    pub expiry: Option<u64>,
    pub state: MintQuoteState,
}

impl From<CdkMintQuote> for MintQuote {
    fn from(quote: CdkMintQuote) -> Self {
        Self {
            id: quote.id,
            request: quote.request,
            amount: quote.amount.into(),
            expiry: Some(quote.expiry),
            state: quote.state.into(),
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

#[derive(Clone)]
pub struct MultiMintWallet {
    pub unit: String,
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

// pub enum WellKnownCurrencyUnit {
//     Sat,
//     Msat,
//     Usd,
//     Eur,
// }

// impl Display for WellKnownCurrencyUnit {
//     fn fmt(&self, f: &mut Formatter<'_>) -> fmt::Result {
//         match self {
//             Self::Sat => write!(f, "{}", CurrencyUnit::Sat),
//             Self::Msat => write!(f, "{}", CurrencyUnit::Msat),
//             Self::Usd => write!(f, "{}", CurrencyUnit::Usd),
//             Self::Eur => write!(f, "{}", CurrencyUnit::Eur),
//         }
//     }
// }

#[frb(sync)]
pub fn generate_seed() -> Vec<u8> {
    rand::random::<[u8; 32]>().to_vec()
}

#[frb(sync)]
pub fn generate_hex_seed() -> String {
    hex::encode(rand::random::<[u8; 32]>())
}
