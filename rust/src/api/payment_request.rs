use std::{
    fmt::{self, Display},
    str::FromStr,
};

use cdk_common::{
    mint_url::MintUrl, nut18::TransportType as CdkTransportType, CurrencyUnit,
    PaymentRequest as CdkPaymentRequest, Transport as CdkTransport,
};
use flutter_rust_bridge::frb;

use super::error::Error;

#[derive(Clone)]
pub struct PaymentRequest {
    pub payment_id: Option<String>,
    pub amount: Option<u64>,
    pub unit: Option<String>,
    pub single_use: Option<bool>,
    pub mints: Option<Vec<String>>,
    pub description: Option<String>,
    pub transports: Option<Vec<Transport>>,
}

impl PaymentRequest {
    #[frb(sync)]
    pub fn encode(&self) -> String {
        self.to_string()
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
        let cdk_payment_request = CdkPaymentRequest::from_str(s)?;
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
            transports: cdk_payment_request
                .transports
                .map(|transports| transports.into_iter().map(|t| t.into()).collect()),
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
                .map(|transports| transports.into_iter().map(|t| t.into()).collect()),
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
                .map(|transports| transports.iter().map(|t| t.into()).collect()),
            nut10: None,
        })
    }
}

#[derive(Clone)]
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
