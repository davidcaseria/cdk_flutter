use std::str::FromStr;

use cdk_common::{
    nut18::TransportType as CdkTransportType, PaymentRequest as CdkPaymentRequest,
    Transport as CdkTransport,
};

use super::error::Error;

pub struct PaymentRequest {
    pub payment_id: Option<String>,
    pub amount: Option<u64>,
    pub unit: Option<String>,
    pub single_use: Option<bool>,
    pub mints: Option<Vec<String>>,
    pub description: Option<String>,
    pub transports: Vec<Transport>,
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
                .into_iter()
                .map(|t| t.into())
                .collect(),
        }
    }
}

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
