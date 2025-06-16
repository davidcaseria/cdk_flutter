use std::str::FromStr;

use cdk_common::{util::hex, PublicKey, SecretKey};
use flutter_rust_bridge::frb;
use nostr::secp256k1::ecdh::SharedSecret;

use super::error::Error;

#[frb(sync)]
pub fn generate_seed() -> Vec<u8> {
    rand::random::<[u8; 32]>().to_vec()
}

#[frb(sync)]
pub fn generate_hex_seed() -> String {
    hex::encode(rand::random::<[u8; 32]>())
}

#[frb(sync)]
pub fn derive_shared_secret(secret: String, pub_key: String) -> Result<String, Error> {
    let secret = SecretKey::from_str(&secret)?;
    let pub_key = PublicKey::from_str(&pub_key)?;

    let shared_secret = SharedSecret::new(&pub_key, &secret);
    Ok(shared_secret.display_secret().to_string())
}

#[frb(sync)]
pub fn get_pub_key(secret: String) -> Result<String, Error> {
    let secret = SecretKey::from_str(&secret)?;
    let pub_key = secret.public_key();
    Ok(pub_key.to_string())
}
