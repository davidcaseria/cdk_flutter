use std::{borrow::Cow, str::FromStr};

use bip21::{de::ParamKind, DeserializationError, DeserializationState, DeserializeParams, Param};
use cdk_common::{
    bitcoin::Address, lightning_invoice::ParseOrSemanticError, nut18,
    Bolt11Invoice as CdkBolt11Invoice, PaymentRequest as CdkPaymentRequest,
};
use flutter_rust_bridge::frb;

use super::{bolt11::Bolt11Invoice, error::Error, payment_request::PaymentRequest};

pub struct BitcoinAddress {
    pub address: String,
    pub amount: Option<u64>,
    pub lightning: Option<Bolt11Invoice>,
    pub cashu: Option<PaymentRequest>,
}

impl FromStr for BitcoinAddress {
    type Err = Error;

    fn from_str(s: &str) -> Result<Self, Error> {
        if let Ok(uri) = bip21::Uri::<'_, _, CashuExtras>::from_str(s) {
            return Ok(BitcoinAddress {
                address: uri.address.assume_checked().to_string(),
                amount: uri.amount.map(|a| a.to_sat()),
                lightning: uri.extras.lightning.map(|l| l.into()),
                cashu: uri.extras.cashu.map(|c| c.into()),
            });
        }
        if let Ok(address) = Address::from_str(s) {
            return Ok(BitcoinAddress {
                address: address.assume_checked().to_string(),
                amount: None,
                lightning: None,
                cashu: None,
            });
        }
        Err(Error::InvalidInput)
    }
}

#[derive(Debug, Default, Clone)]
#[frb(ignore)]
struct CashuExtras {
    pub lightning: Option<CdkBolt11Invoice>,
    // pub b12: Option<Offer>,
    pub cashu: Option<CdkPaymentRequest>,
}

#[derive(Debug, Eq, PartialEq, Clone)]
enum ExtraParamsParseError {
    InvoiceParsingError,
    MultipleParams(String),
    PaymentRequestParsingError,
    // Bolt12ParsingError,
}

impl From<ParseOrSemanticError> for ExtraParamsParseError {
    fn from(_e: ParseOrSemanticError) -> Self {
        ExtraParamsParseError::InvoiceParsingError
    }
}

// impl From<Bolt12ParseError> for ExtraParamsParseError {
//     fn from(_e: Bolt12ParseError) -> Self {
//         ExtraParamsParseError::Bolt12ParsingError
//     }
// }

impl From<nut18::Error> for ExtraParamsParseError {
    fn from(_e: nut18::Error) -> Self {
        ExtraParamsParseError::PaymentRequestParsingError
    }
}

impl DeserializationError for CashuExtras {
    type Error = ExtraParamsParseError;
}

impl<'a> DeserializeParams<'a> for CashuExtras {
    type DeserializationState = CashuExtras;
}

impl<'a> DeserializationState<'a> for CashuExtras {
    type Value = CashuExtras;

    fn is_param_known(&self, param: &str) -> bool {
        matches!(param, "lightning" | "cashu")
    }

    fn deserialize_temp(
        &mut self,
        key: &str,
        value: Param<'_>,
    ) -> Result<ParamKind, <Self::Value as DeserializationError>::Error> {
        match key {
            "lightning" if self.lightning.is_none() => {
                let str =
                    Cow::try_from(value).map_err(|_| ExtraParamsParseError::InvoiceParsingError)?;
                let invoice = CdkBolt11Invoice::from_str(&str)?;
                self.lightning = Some(invoice);

                Ok(ParamKind::Known)
            }
            "lightning" => Err(ExtraParamsParseError::MultipleParams(key.to_string())),
            "cashu" if self.cashu.is_none() => {
                let str = Cow::try_from(value)
                    .map_err(|_| ExtraParamsParseError::PaymentRequestParsingError)?;
                let payment_request = CdkPaymentRequest::from_str(&str)?;
                self.cashu = Some(payment_request);

                Ok(ParamKind::Known)
            }
            "cashu" => Err(ExtraParamsParseError::MultipleParams(key.to_string())),
            _ => Ok(ParamKind::Unknown),
        }
    }

    fn finalize(self) -> Result<Self::Value, <Self::Value as DeserializationError>::Error> {
        Ok(self)
    }
}
