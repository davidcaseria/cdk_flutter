use std::{
    str::FromStr,
    sync::{Arc, RwLock},
};

use cdk::nuts::Token as CdkToken;
use cdk_common::{KeySetInfo, Proofs};
use flutter_rust_bridge::frb;
use ur::{Decoder, Encoder};

use super::error::Error;

pub struct Token {
    pub encoded: String,
    pub raw: Option<Vec<u8>>,
    pub amount: u64,
    pub mint_url: String,
}

impl Token {
    #[frb(sync)]
    pub fn parse(encoded: &str) -> Result<Self, Error> {
        let encoded = encoded.strip_prefix("cashu:").unwrap_or(encoded);
        let token = CdkToken::from_str(encoded)?;
        Token::try_from(token)
    }

    #[frb(sync)]
    pub fn from_raw_bytes(raw: Vec<u8>) -> Result<Self, Error> {
        let token = CdkToken::try_from(&raw)?;
        Token::try_from(token)
    }

    pub(crate) fn proofs(&self, mint_keysets: &[KeySetInfo]) -> Result<Proofs, Error> {
        let token: CdkToken = self.try_into()?;
        Ok(token.proofs(mint_keysets)?)
    }
}

impl FromStr for Token {
    type Err = Error;

    fn from_str(s: &str) -> Result<Self, Error> {
        Token::parse(s)
    }
}

impl TryFrom<CdkToken> for Token {
    type Error = Error;

    fn try_from(token: CdkToken) -> Result<Self, Error> {
        match token {
            CdkToken::TokenV3(token_v3) => Ok(Token {
                encoded: token_v3.to_string(),
                raw: None,
                amount: token_v3.value()?.into(),
                mint_url: token_v3.mint_urls().first().unwrap().to_string(),
            }),
            CdkToken::TokenV4(token_v4) => Ok(Token {
                encoded: token_v4.to_string(),
                raw: Some(token_v4.to_raw_bytes()?),
                amount: token_v4.value()?.into(),
                mint_url: token_v4.mint_url.to_string(),
            }),
        }
    }
}

impl TryInto<CdkToken> for Token {
    type Error = Error;

    fn try_into(self) -> Result<CdkToken, Error> {
        Ok(CdkToken::from_str(&self.encoded)?)
    }
}

impl TryInto<CdkToken> for &Token {
    type Error = Error;

    fn try_into(self) -> Result<CdkToken, Error> {
        Ok(CdkToken::from_str(&self.encoded)?)
    }
}

pub struct TokenDecoder {
    decoder: Arc<RwLock<Decoder>>,
}

impl TokenDecoder {
    #[frb(sync)]
    pub fn new() -> Self {
        Self {
            decoder: Arc::new(RwLock::new(Decoder::default())),
        }
    }

    #[frb(sync)]
    pub fn is_complete(&self) -> bool {
        let decoder = self.decoder.read().expect("Lock poisoned");
        decoder.complete()
    }

    #[frb(sync)]
    pub fn receive(&self, input: String) -> Result<(), Error> {
        let mut decoder = self.decoder.write().expect("Lock poisoned");
        decoder.receive(&input)?;
        Ok(())
    }

    #[frb(sync)]
    pub fn value(&self) -> Result<Option<Token>, Error> {
        let decoder = self.decoder.read().expect("Lock poisened");
        let ur = decoder.message()?;
        match ur {
            Some(ur) => match CdkToken::try_from(&ur) {
                Ok(token) => Ok(Some(token.try_into()?)),
                Err(e) => {
                    log::warn!("Failed to parse token bytes: {}", e);
                    Ok(Some(
                        CdkToken::from_str(&String::from_utf8_lossy(&ur))?.try_into()?,
                    ))
                }
            },
            None => Ok(None),
        }
    }
}

#[frb(sync)]
pub fn encode_qr_token(
    token: &Token,
    max_fragment_length: Option<usize>,
) -> Result<Vec<String>, Error> {
    let mut encoder = Encoder::bytes(token.encoded.as_bytes(), max_fragment_length.unwrap_or(150))?;
    let mut parts = Vec::new();
    for _ in 0..encoder.fragment_count() {
        if let Ok(part) = encoder.next_part() {
            parts.push(part);
        }
    }
    Ok(parts)
}
