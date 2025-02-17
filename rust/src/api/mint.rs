use cdk_common::{
    ContactInfo as CdkContactInfo, MintInfo as CdkMintInfo, MintVersion as CdkMintVersion,
};

pub struct MintInfo {
    pub name: Option<String>,
    pub pubkey: Option<String>,
    pub version: Option<MintVersion>,
    pub description: Option<String>,
    pub description_long: Option<String>,
    pub contact: Option<Vec<ContactInfo>>,
    pub icon_url: Option<String>,
    pub urls: Option<Vec<String>>,
    pub motd: Option<String>,
    pub time: Option<u64>,
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
            icon_url: value.icon_url,
            urls: value.urls,
            motd: value.motd,
            time: value.time,
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
