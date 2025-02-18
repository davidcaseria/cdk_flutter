use std::str::FromStr;

use cdk_common::bitcoin::Address;

use super::{error::Error, payment_request::PaymentRequest};

pub struct BitcoinAddress {
    pub address: String,
    pub amount: Option<u64>,
    pub lightning: Option<String>,
    pub cashu: Option<PaymentRequest>,
}

impl FromStr for BitcoinAddress {
    type Err = Error;

    fn from_str(s: &str) -> Result<Self, Error> {
        if let Ok(uri) = bip21::Uri::<'_, _, bip21::NoExtras>::from_str(s) {
            return Ok(BitcoinAddress {
                address: uri.address.assume_checked().to_string(),
                amount: uri.amount.map(|a| a.to_sat()),
                lightning: None,
                cashu: None,
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
