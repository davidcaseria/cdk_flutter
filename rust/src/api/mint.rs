use std::str::FromStr;

use cdk::{
    nuts::{
        nut04, nut05, nut06,
        nut21::{
            self, Method as CdkHttpMethod, ProtectedEndpoint as CdkProtectedEndpoint,
            RoutePath as CdkHttpRoutePath,
        },
        nut22,
    },
    wallet::{HttpClient, MintConnector},
};
use cdk_common::{
    mint_url::MintUrl, ContactInfo as CdkContactInfo, MintInfo as CdkMintInfo,
    MintVersion as CdkMintVersion, Nuts as CdkNuts,
};

use super::error::Error;

pub struct Mint {
    pub url: String,
    pub info: Option<MintInfo>,
    pub balance: Option<u64>,
}

impl Eq for Mint {}

impl Ord for Mint {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.balance.cmp(&other.balance).reverse()
    }
}

impl PartialEq for Mint {
    fn eq(&self, other: &Self) -> bool {
        self.url == other.url
    }
}

impl PartialOrd for Mint {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.balance.cmp(&other.balance).reverse())
    }
}

pub struct MintInfo {
    pub name: Option<String>,
    pub pubkey: Option<String>,
    pub version: Option<MintVersion>,
    pub description: Option<String>,
    pub description_long: Option<String>,
    pub contact: Option<Vec<ContactInfo>>,
    pub nuts: Nuts,
    pub icon_url: Option<String>,
    pub urls: Option<Vec<String>>,
    pub motd: Option<String>,
    pub time: Option<u64>,
    pub tos_url: Option<String>,
}

impl From<CdkMintInfo> for MintInfo {
    fn from(value: CdkMintInfo) -> Self {
        Self {
            name: value.name,
            pubkey: value.pubkey.map(|p| p.to_string()),
            version: value.version.map(|v| v.into()),
            description: value.description,
            description_long: value.description_long,
            contact: value
                .contact
                .map(|c| c.into_iter().map(|c| c.into()).collect()),
            nuts: value.nuts.into(),
            icon_url: value.icon_url,
            urls: value.urls,
            motd: value.motd,
            time: value.time,
            tos_url: value.tos_url,
        }
    }
}

pub struct MintVersion {
    pub name: String,
    pub version: String,
}

impl From<CdkMintVersion> for MintVersion {
    fn from(value: CdkMintVersion) -> Self {
        Self {
            name: value.name,
            version: value.version,
        }
    }
}

pub struct ContactInfo {
    pub method: String,
    pub info: String,
}

impl From<CdkContactInfo> for ContactInfo {
    fn from(c: CdkContactInfo) -> Self {
        Self {
            method: c.method,
            info: c.info,
        }
    }
}

pub struct Nuts {
    pub nut04: Nut04Settings,
    pub nut05: Nut05Settings,
    pub nut07: SupportedSettings,
    pub nut08: SupportedSettings,
    pub nut09: SupportedSettings,
    pub nut10: SupportedSettings,
    pub nut11: SupportedSettings,
    pub nut12: SupportedSettings,
    pub nut14: SupportedSettings,
    pub nut20: SupportedSettings,
    pub nut21: Option<ClearAuthSettings>,
    pub nut22: Option<BlindAuthSettings>,
}

impl From<CdkNuts> for Nuts {
    fn from(value: CdkNuts) -> Self {
        Self {
            nut04: value.nut04.into(),
            nut05: value.nut05.into(),
            nut07: value.nut07.into(),
            nut08: value.nut08.into(),
            nut09: value.nut09.into(),
            nut10: value.nut10.into(),
            nut11: value.nut11.into(),
            nut12: value.nut12.into(),
            nut14: value.nut14.into(),
            nut20: value.nut20.into(),
            nut21: value.nut21.map(|n| n.into()),
            nut22: value.nut22.map(|n| n.into()),
        }
    }
}

pub struct SupportedSettings {
    pub supported: bool,
}

impl From<nut06::SupportedSettings> for SupportedSettings {
    fn from(value: nut06::SupportedSettings) -> Self {
        Self {
            supported: value.supported,
        }
    }
}

pub struct Nut04Settings {
    pub methods: Vec<MintMethodSettings>,
    pub disabled: bool,
}

impl From<nut04::Settings> for Nut04Settings {
    fn from(value: nut04::Settings) -> Self {
        Self {
            methods: value.methods.into_iter().map(|m| m.into()).collect(),
            disabled: value.disabled,
        }
    }
}

pub struct MintMethodSettings {
    pub method: String,
    pub unit: String,
    pub min_amount: Option<u64>,
    pub max_amount: Option<u64>,
}

impl From<nut04::MintMethodSettings> for MintMethodSettings {
    fn from(value: nut04::MintMethodSettings) -> Self {
        Self {
            method: value.method.to_string(),
            unit: value.unit.to_string(),
            min_amount: value.min_amount.map(|v| v.into()),
            max_amount: value.max_amount.map(|v| v.into()),
        }
    }
}

pub struct Nut05Settings {
    pub methods: Vec<MeltMethodSettings>,
    pub disabled: bool,
}

impl From<nut05::Settings> for Nut05Settings {
    fn from(value: nut05::Settings) -> Self {
        Self {
            methods: value.methods.into_iter().map(|m| m.into()).collect(),
            disabled: value.disabled,
        }
    }
}

pub struct MeltMethodSettings {
    pub method: String,
    pub unit: String,
    pub min_amount: Option<u64>,
    pub max_amount: Option<u64>,
}

impl From<nut05::MeltMethodSettings> for MeltMethodSettings {
    fn from(value: nut05::MeltMethodSettings) -> Self {
        Self {
            method: value.method.to_string(),
            unit: value.unit.to_string(),
            min_amount: value.min_amount.map(|v| v.into()),
            max_amount: value.max_amount.map(|v| v.into()),
        }
    }
}

pub struct ClearAuthSettings {
    pub openid_discovery: String,
    pub client_id: String,
    pub protected_endpoints: Vec<ProtectedEndpoint>,
}

impl From<nut21::Settings> for ClearAuthSettings {
    fn from(value: nut21::Settings) -> Self {
        Self {
            openid_discovery: value.openid_discovery.to_string(),
            client_id: value.client_id.to_string(),
            protected_endpoints: value
                .protected_endpoints
                .into_iter()
                .map(|e| e.into())
                .collect(),
        }
    }
}

pub struct BlindAuthSettings {
    pub bat_max_mint: u64,
    pub protected_endpoints: Vec<ProtectedEndpoint>,
}

impl From<nut22::Settings> for BlindAuthSettings {
    fn from(value: nut22::Settings) -> Self {
        Self {
            bat_max_mint: value.bat_max_mint,
            protected_endpoints: value
                .protected_endpoints
                .into_iter()
                .map(|e| e.into())
                .collect(),
        }
    }
}

pub struct ProtectedEndpoint {
    pub method: HttpMethod,
    pub path: HttpRoutePath,
}

impl From<CdkProtectedEndpoint> for ProtectedEndpoint {
    fn from(value: CdkProtectedEndpoint) -> Self {
        Self {
            method: value.method.into(),
            path: value.path.into(),
        }
    }
}

pub enum HttpMethod {
    Get,
    Post,
}

impl From<CdkHttpMethod> for HttpMethod {
    fn from(value: CdkHttpMethod) -> Self {
        match value {
            CdkHttpMethod::Get => Self::Get,
            CdkHttpMethod::Post => Self::Post,
        }
    }
}

pub enum HttpRoutePath {
    MintQuoteBolt11,
    MintBolt11,
    MeltQuoteBolt11,
    MeltBolt11,
    MintQuoteBolt12,
    MintBolt12,
    MeltQuoteBolt12,
    MeltBolt12,
    Swap,
    Checkstate,
    Restore,
    MintBlindAuth,
}

impl From<CdkHttpRoutePath> for HttpRoutePath {
    fn from(value: CdkHttpRoutePath) -> Self {
        match value {
            CdkHttpRoutePath::MintQuoteBolt11 => Self::MintQuoteBolt11,
            CdkHttpRoutePath::MintBolt11 => Self::MintBolt11,
            CdkHttpRoutePath::MeltQuoteBolt11 => Self::MeltQuoteBolt11,
            CdkHttpRoutePath::MeltBolt11 => Self::MeltBolt11,
            CdkHttpRoutePath::MintQuoteBolt12 => Self::MintQuoteBolt12,
            CdkHttpRoutePath::MintBolt12 => Self::MintBolt12,
            CdkHttpRoutePath::MeltQuoteBolt12 => Self::MeltQuoteBolt12,
            CdkHttpRoutePath::MeltBolt12 => Self::MeltBolt12,
            CdkHttpRoutePath::Swap => Self::Swap,
            CdkHttpRoutePath::Checkstate => Self::Checkstate,
            CdkHttpRoutePath::Restore => Self::Restore,
            CdkHttpRoutePath::MintBlindAuth => Self::MintBlindAuth,
        }
    }
}

pub async fn get_mint_info(mint_url: &str) -> Result<MintInfo, Error> {
    let client = HttpClient::new(MintUrl::from_str(mint_url)?);
    Ok(client.get_mint_info().await?.into())
}
