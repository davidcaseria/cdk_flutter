use std::str::FromStr;

use bip39::Mnemonic;
use cdk_common::{util::hex, PublicKey, SecretKey};
use flutter_rust_bridge::frb;
use nostr::secp256k1::ecdh::SharedSecret;
use rand::RngCore;

use super::error::Error;

/// Generate a new 12-word BIP39 mnemonic
#[frb(sync)]
pub fn generate_mnemonic() -> String {
    let mut entropy = [0u8; 16]; // 128 bits for 12 words
    rand::rng().fill_bytes(&mut entropy);
    Mnemonic::from_entropy(&entropy).unwrap().to_string()
}

/// Convert a mnemonic to a 64-byte seed
#[frb(sync)]
pub fn mnemonic_to_seed(mnemonic: String) -> Result<Vec<u8>, Error> {
    let mnemonic = Mnemonic::parse(&mnemonic).map_err(|_| Error::InvalidInput)?;
    Ok(mnemonic.to_seed("").to_vec())
}

/// Generate a random 64-byte seed (from a generated mnemonic)
#[frb(sync)]
pub fn generate_seed() -> Vec<u8> {
    let mut entropy = [0u8; 16];
    rand::rng().fill_bytes(&mut entropy);
    Mnemonic::from_entropy(&entropy).unwrap().to_seed("").to_vec()
}

/// Generate a hex-encoded 64-byte seed (from a generated mnemonic)
#[frb(sync)]
pub fn generate_hex_seed() -> String {
    let mut entropy = [0u8; 16];
    rand::rng().fill_bytes(&mut entropy);
    hex::encode(Mnemonic::from_entropy(&entropy).unwrap().to_seed(""))
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

#[frb(sync)]
pub fn key_hex_to_bytes(key: String) -> Result<Vec<u8>, Error> {
    hex::decode(&key).map_err(|e| Error::Hex(e.to_string()))
}

#[frb(sync)]
pub fn key_bytes_to_hex(key: &[u8]) -> String {
    hex::encode(key)
}
