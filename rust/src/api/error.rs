pub enum Error {
    Cdk(String),
    Database(String),
    Hex(String),
    InvalidInput,
    Json(String),
    Nostr(String),
    Protocol(String),
    Reqwest(String),
    Ur(String),
    Url(String),
    Utf8(String),
    WalletNotEmpty,
}

impl From<bc_ur::Error> for Error {
    fn from(e: bc_ur::Error) -> Self {
        Self::Ur(e.to_string())
    }
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

impl From<cdk::nuts::nut11::Error> for Error {
    fn from(e: cdk::nuts::nut11::Error) -> Self {
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

impl From<nostr::key::Error> for Error {
    fn from(e: nostr::key::Error) -> Self {
        Self::Nostr(e.to_string())
    }
}

impl From<nostr_sdk::client::Error> for Error {
    fn from(e: nostr_sdk::client::Error) -> Self {
        Self::Nostr(e.to_string())
    }
}

impl From<reqwest::Error> for Error {
    fn from(e: reqwest::Error) -> Self {
        Self::Reqwest(e.to_string())
    }
}

impl From<serde_json::Error> for Error {
    fn from(e: serde_json::Error) -> Self {
        Self::Json(e.to_string())
    }
}

impl From<std::string::FromUtf8Error> for Error {
    fn from(e: std::string::FromUtf8Error) -> Self {
        Self::Utf8(e.to_string())
    }
}
