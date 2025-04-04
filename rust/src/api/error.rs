pub enum Error {
    Cdk(String),
    Database(String),
    Hex(String),
    InvalidInput,
    Protocol(String),
    Reqwest(String),
    Url(String),
    WalletNotEmpty,
}

impl From<cdk::amount::Error> for Error {
    fn from(e: cdk::amount::Error) -> Self {
        Self::Cdk(e.to_string())
    }
}

impl From<cdk::cdk_database::Error> for Error {
    fn from(e: cdk::cdk_database::Error) -> Self {
        Self::Database(e.to_string())
    }
}

impl From<cdk::error::Error> for Error {
    fn from(e: cdk::error::Error) -> Self {
        Self::Cdk(e.to_string())
    }
}

impl From<cdk::mint_url::Error> for Error {
    fn from(e: cdk::mint_url::Error) -> Self {
        Self::Url(e.to_string())
    }
}

impl From<cdk::nuts::nut00::Error> for Error {
    fn from(e: cdk::nuts::nut00::Error) -> Self {
        Self::Protocol(e.to_string())
    }
}

impl From<cdk::nuts::nut01::Error> for Error {
    fn from(e: cdk::nuts::nut01::Error) -> Self {
        Self::Protocol(e.to_string())
    }
}

impl From<cdk::nuts::nut18::Error> for Error {
    fn from(e: cdk::nuts::nut18::Error) -> Self {
        Self::Protocol(e.to_string())
    }
}

impl From<cdk::util::hex::Error> for Error {
    fn from(e: cdk::util::hex::Error) -> Self {
        Self::Hex(e.to_string())
    }
}

impl From<cdk_sqlite::wallet::error::Error> for Error {
    fn from(e: cdk_sqlite::wallet::error::Error) -> Self {
        Self::Database(e.to_string())
    }
}

impl From<reqwest::Error> for Error {
    fn from(e: reqwest::Error) -> Self {
        Self::Reqwest(e.to_string())
    }
}
