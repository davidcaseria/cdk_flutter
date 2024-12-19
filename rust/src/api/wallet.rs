use std::{path::Path, str::FromStr, sync::Arc};

use cdk::{
    amount::SplitTarget,
    cdk_database::WalletDatabase as _,
    mint_url::MintUrl,
    nuts::{CurrencyUnit, PublicKey, SecretKey, SpendingConditions},
    util::hex,
    wallet::{
        multi_mint_wallet::WalletKey, MultiMintWallet as CdkMultiMintWallet, SendKind,
        Wallet as CdkWallet,
    },
};
use cdk_redb::WalletRedbDatabase;
use flutter_rust_bridge::frb;

use super::error::Error;

pub struct Wallet {
    pub mint_url: String,
    pub unit: String,

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
        Ok(self
            .inner
            .receive(&token, SplitTarget::None, &p2pk_signing_keys, &preimages)
            .await?
            .into())
    }

    pub async fn send(
        &self,
        amount: u64,
        memo: Option<String>,
        pubkey: Option<String>,
    ) -> Result<String, Error> {
        let pubkey = pubkey.map(|s| PublicKey::from_str(&s)).transpose()?;
        let conditions = pubkey.map(|pubkey| SpendingConditions::new_p2pk(pubkey, None));
        Ok(self
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
            .to_string())
    }
}

pub struct MultiMintWallet {
    inner: CdkMultiMintWallet,
}

impl MultiMintWallet {
    pub async fn new(
        unit: String,
        seed: Vec<u8>,
        target_proof_count: Option<usize>,
        localstore: WalletDatabase,
    ) -> Result<Self, Error> {
        let unit = CurrencyUnit::from_str(&unit).unwrap_or(CurrencyUnit::Custom(unit));
        let mints = localstore.inner.get_mints().await?;
        let mut wallets = vec![];
        for (mint_url, _) in &mints {
            wallets.push(CdkWallet::new(
                &mint_url.to_string(),
                unit.clone(),
                Arc::new(localstore.inner.clone()),
                &seed,
                target_proof_count,
            )?);
        }
        Ok(Self {
            inner: CdkMultiMintWallet::new(wallets),
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
        self.inner.add_wallet(wallet.inner).await;
        Ok(())
    }

    pub async fn get_wallet(&self, mint_url: &str, unit: &str) -> Result<Option<Wallet>, Error> {
        let mint_url = MintUrl::from_str(mint_url)?;
        let unit = CurrencyUnit::from_str(unit).unwrap_or(CurrencyUnit::Custom(unit.to_string()));
        if let Some(wallet) = self
            .inner
            .get_wallet(&WalletKey::new(mint_url.clone(), unit.clone()))
            .await
        {
            return Ok(Some(Wallet {
                mint_url: mint_url.to_string(),
                unit: unit.to_string(),
                inner: wallet,
            }));
        }
        Ok(None)
    }

    pub async fn list_wallets(&self) -> Vec<Wallet> {
        self.inner
            .get_wallets()
            .await
            .into_iter()
            .map(|wallet| Wallet {
                mint_url: wallet.mint_url.to_string(),
                unit: wallet.unit.to_string(),
                inner: wallet,
            })
            .collect()
    }
}

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
