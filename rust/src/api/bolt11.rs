use std::str::FromStr;

use cdk_common::{lightning_invoice, Bolt11Invoice as CdkBolt11Invoice};

use super::error::Error;

pub struct Bolt11Invoice {
    pub encoded: String,
    pub amount: Option<u64>,
    pub description: String,
    pub payment_hash: String,
    pub expires_at: u64,
    pub payee: String,
}

impl FromStr for Bolt11Invoice {
    type Err = Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let s = s.strip_prefix("lightning:").unwrap_or(s);
        let invoice =
            lightning_invoice::Bolt11Invoice::from_str(s).map_err(|_| Error::InvalidInput)?;

        Ok(Bolt11Invoice {
            encoded: s.to_string(),
            amount: invoice.amount_milli_satoshis().map(|a| a / 1000),
            description: match invoice.description() {
                lightning_invoice::Bolt11InvoiceDescriptionRef::Direct(description) => {
                    description.to_string()
                }
                lightning_invoice::Bolt11InvoiceDescriptionRef::Hash(sha256) => {
                    sha256.0.to_string()
                }
            },
            payment_hash: invoice.payment_hash().to_string(),
            expires_at: invoice.expiry_time().as_secs(),
            payee: invoice
                .payee_pub_key()
                .cloned()
                .unwrap_or_else(|| invoice.recover_payee_pub_key())
                .to_string(),
        })
    }
}

impl From<CdkBolt11Invoice> for Bolt11Invoice {
    fn from(invoice: CdkBolt11Invoice) -> Self {
        Bolt11Invoice {
            encoded: invoice.to_string(),
            amount: invoice.amount_milli_satoshis().map(|a| a / 1000),
            description: invoice.description().to_string(),
            payment_hash: invoice.payment_hash().to_string(),
            expires_at: invoice.expiry_time().as_secs(),
            payee: invoice
                .payee_pub_key()
                .cloned()
                .unwrap_or_else(|| invoice.recover_payee_pub_key())
                .to_string(),
        }
    }
}
