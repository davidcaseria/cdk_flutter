use std::str::FromStr;

use cdk::nuts::Token as CdkToken;
use cdk_common::Proofs;
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
