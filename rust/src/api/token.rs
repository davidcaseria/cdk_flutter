use std::{
    str::FromStr,
    sync::{Arc, Mutex},
};

use cdk::nuts::{
    nut16::{MultipartEncoder, UREncodable},
    Token as CdkToken,
};
use cdk_common::{
    nut16::{MultipartDecoder, URDecodable},
    Proofs,
};
use flutter_rust_bridge::frb;

use super::error::Error;

pub struct Token {
    pub encoded: String,
    pub amount: u64,
    pub mint_url: String,
}

impl Token {
    #[frb(sync)]
    pub fn parse(encoded: &str) -> Result<Self, Error> {
        let token = CdkToken::from_str(encoded)?;
        Token::try_from(token)
    }

    pub(crate) fn proofs(&self) -> Result<Proofs, Error> {
        let token: CdkToken = self.try_into()?;
        Ok(token.proofs())
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
                amount: token_v3.value()?.into(),
                mint_url: token_v3.mint_urls().first().unwrap().to_string(),
            }),
            CdkToken::TokenV4(token_v4) => Ok(Token {
                encoded: token_v4.to_string(),
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
    decoder: Arc<Mutex<MultipartDecoder>>,
}

impl TokenDecoder {
    pub fn new() -> Self {
        Self {
            decoder: Arc::new(Mutex::new(MultipartDecoder::new())),
        }
    }

    #[frb(sync)]
    pub fn is_complete(&self) -> bool {
        let decoder = self.decoder.lock().expect("Lock poisoned");
        decoder.is_complete()
    }

    #[frb(sync)]
    pub fn receive(&self, part: String) -> Result<(), Error> {
        let mut decoder = self.decoder.lock().expect("Lock poisoned");
        decoder.receive(&part)?;
        Ok(())
    }

    #[frb(sync)]
    pub fn value(&self) -> Result<Option<Token>, Error> {
        let decoder = self.decoder.lock().expect("Lock poisened");
        let ur = decoder.message()?;
        match ur {
            Some(ur) => Ok(Some(CdkToken::from_ur(ur)?.try_into()?)),
            None => Ok(None),
        }
    }
}

#[frb(sync)]
pub fn encode_qr_token(
    token: &Token,
    max_fragment_len: Option<usize>,
) -> Result<Vec<String>, Error> {
    let cdk_token: CdkToken = token.try_into()?;
    let ur = cdk_token.ur();
    let mut encoder = MultipartEncoder::new(&ur, max_fragment_len.unwrap_or(300))?;
    let mut parts = Vec::new();
    loop {
        let part = encoder.next_part()?;
        if part.is_empty() {
            break;
        }
        parts.push(part);
    }
    Ok(parts)
}
