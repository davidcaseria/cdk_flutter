use std::{
    fmt::{self, Display},
    str::FromStr,
};

use cdk_common::{
    mint_url::MintUrl,
    nut18::{Nut10SecretRequest as CdkNut10SecretRequest, TransportType as CdkTransportType},
    CurrencyUnit, PaymentRequest as CdkPaymentRequest, SpendingConditions,
    Transport as CdkTransport,
};
use flutter_rust_bridge::frb;

use super::error::Error;

#[derive(Clone, Debug)]
pub struct PaymentRequest {
    pub payment_id: Option<String>,
    pub amount: Option<u64>,
    pub unit: Option<String>,
    pub single_use: Option<bool>,
    pub mints: Option<Vec<String>>,
    pub description: Option<String>,
    pub transports: Option<Vec<Transport>>,
    pub nut10: Option<Nut10SecretRequest>,
}

impl PaymentRequest {
    #[frb(sync)]
    pub fn encode(&self) -> String {
        self.to_string()
    }

    #[frb(sync)]
    pub fn parse(encoded: &str) -> Result<Self, Error> {
        let encoded = encoded.strip_prefix("cashu:").unwrap_or(encoded);
        encoded.parse()
    }

    pub(crate) fn validate(&self, mint_url: MintUrl, unit: CurrencyUnit) -> bool {
        if let Some(pr_unit) = &self.unit {
            if pr_unit != &unit.to_string() {
                return false;
            }
        }

        if let Some(mints) = &self.mints {
            if mints.iter().all(|m| m != &mint_url.to_string()) {
                return false;
            }
        }

        false
    }
}

impl Display for PaymentRequest {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let cdk_payment_request: CdkPaymentRequest = self.try_into().map_err(|_| fmt::Error)?;
        write!(f, "{}", cdk_payment_request)
    }
}

impl FromStr for PaymentRequest {
    type Err = Error;

    fn from_str(s: &str) -> Result<Self, Error> {
        let encoded = s.strip_prefix("cashu:").unwrap_or(s);
        let cdk_payment_request = CdkPaymentRequest::from_str(encoded)?;
        Ok(cdk_payment_request.into())
    }
}

impl From<CdkPaymentRequest> for PaymentRequest {
    fn from(cdk_payment_request: CdkPaymentRequest) -> Self {
        PaymentRequest {
            payment_id: cdk_payment_request.payment_id,
            amount: cdk_payment_request.amount.map(|a| a.into()),
            unit: cdk_payment_request.unit.map(|u| u.to_string()),
            single_use: cdk_payment_request.single_use.map(|su| su.into()),
            mints: cdk_payment_request
                .mints
                .map(|m| m.iter().map(|m| m.to_string()).collect()),
            description: cdk_payment_request.description,
            transports: if cdk_payment_request.transports.is_empty() {
                None
            } else {
                Some(cdk_payment_request.transports.into_iter().map(|t| t.into()).collect())
            },
            nut10: cdk_payment_request.nut10.map(|n| n.into()),
        }
    }
}

impl TryInto<CdkPaymentRequest> for PaymentRequest {
    type Error = Error;

    fn try_into(self) -> Result<CdkPaymentRequest, Self::Error> {
        Ok(CdkPaymentRequest {
            payment_id: self.payment_id,
            amount: self.amount.map(|a| a.into()),
            unit: self
                .unit
                .map(|u| u.parse().map_err(|_| Error::InvalidInput))
                .transpose()?,
            single_use: self.single_use.map(|su| su.into()),
            mints: self
                .mints
                .map(|m| {
                    m.into_iter()
                        .map(|m| m.parse().map_err(|_| Error::InvalidInput))
                        .collect()
                })
                .transpose()?,
            description: self.description,
            transports: self
                .transports
                .map(|transports| transports.into_iter().map(|t| t.into()).collect())
                .unwrap_or_default(),
            nut10: None,
        })
    }
}

impl TryInto<CdkPaymentRequest> for &PaymentRequest {
    type Error = Error;

    fn try_into(self) -> Result<CdkPaymentRequest, Self::Error> {
        Ok(CdkPaymentRequest {
            payment_id: self.payment_id.clone(),
            amount: self.amount.map(|a| a.into()),
            unit: self
                .unit
                .as_ref()
                .map(|u| u.parse().map_err(|_| Error::InvalidInput))
                .transpose()?,
            single_use: self.single_use,
            mints: self
                .mints
                .as_ref()
                .map(|m| {
                    m.iter()
                        .map(|m| m.parse().map_err(|_| Error::InvalidInput))
                        .collect()
                })
                .transpose()?,
            description: self.description.clone(),
            transports: self
                .transports
                .as_ref()
                .map(|transports| transports.iter().map(|t| t.into()).collect())
                .unwrap_or_default(),
            nut10: None,
        })
    }
}

#[derive(Clone, Debug)]
pub struct Transport {
    pub _type: TransportType,
    pub target: String,
    pub tags: Option<Vec<Vec<String>>>,
}

impl From<CdkTransport> for Transport {
    fn from(cdk_transport: CdkTransport) -> Self {
        Transport {
            _type: cdk_transport._type.into(),
            target: cdk_transport.target,
            tags: cdk_transport.tags,
        }
    }
}

impl Into<CdkTransport> for Transport {
    fn into(self) -> CdkTransport {
        CdkTransport {
            _type: self._type.clone().into(),
            target: self.target,
            tags: self.tags,
        }
    }
}

impl Into<CdkTransport> for &Transport {
    fn into(self) -> CdkTransport {
        CdkTransport {
            _type: self._type.into(),
            target: self.target.clone(),
            tags: self.tags.clone(),
        }
    }
}

#[derive(Debug, Copy, Clone, PartialEq, Eq)]
pub enum TransportType {
    Nostr,
    HttpPost,
}

impl From<CdkTransportType> for TransportType {
    fn from(cdk_transport_type: CdkTransportType) -> Self {
        match cdk_transport_type {
            CdkTransportType::Nostr => TransportType::Nostr,
            CdkTransportType::HttpPost => TransportType::HttpPost,
        }
    }
}

impl Into<CdkTransportType> for TransportType {
    fn into(self) -> CdkTransportType {
        match self {
            TransportType::Nostr => CdkTransportType::Nostr,
            TransportType::HttpPost => CdkTransportType::HttpPost,
        }
    }
}

#[derive(Clone, Debug)]
pub struct Nut10SecretRequest {
    pub kind: Nut10Kind,
    pub secret_data: SecretDataRequest,
}

impl Nut10SecretRequest {
    #[frb(sync)]
    pub fn p2pk(public_key: String) -> Result<Self, Error> {
        Ok(SpendingConditions::new_p2pk(public_key.parse()?, None).into())
    }

    #[frb(sync)]
    pub fn htlc(preimage: String) -> Result<Self, Error> {
        Ok(SpendingConditions::new_htlc(preimage, None)?.into())
    }
}

impl From<CdkNut10SecretRequest> for Nut10SecretRequest {
    fn from(cdk_nut10_secret_request: CdkNut10SecretRequest) -> Self {
        Nut10SecretRequest {
            kind: cdk_nut10_secret_request.kind.into(),
            secret_data: SecretDataRequest {
                data: cdk_nut10_secret_request.data,
                tags: cdk_nut10_secret_request.tags,
            },
        }
    }
}

impl From<SpendingConditions> for Nut10SecretRequest {
    fn from(conditions: SpendingConditions) -> Self {
        let cdk: CdkNut10SecretRequest = conditions.into();
        cdk.into()
    }
}

#[derive(Clone, Copy, Debug)]
pub enum Nut10Kind {
    P2PK,
    HTLC,
}

impl From<cdk_common::nut10::Kind> for Nut10Kind {
    fn from(kind: cdk_common::nut10::Kind) -> Self {
        match kind {
            cdk_common::nut10::Kind::P2PK => Nut10Kind::P2PK,
            cdk_common::nut10::Kind::HTLC => Nut10Kind::HTLC,
        }
    }
}

#[derive(Clone, Debug)]
pub struct SecretDataRequest {
    pub data: String,
    pub tags: Option<Vec<Vec<String>>>,
}
