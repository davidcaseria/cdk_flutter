## 0.1.0

### Breaking Changes
- Upgraded to CDK v0.13.4
- Seed derivation now uses SHA-512 to produce 64-byte seeds internally
- `PreparedSend.confirm()` replaces `Wallet.send()` for executing sends
- `PreparedSend.cancel()` no longer requires wallet parameter

### New Features
- BOLT12 melt quote support via `meltBolt12Quote()`
- Check pending melt quotes with `checkPendingMeltQuotes()`
- Database path now publicly accessible via `WalletDatabase.path`
- `MeltOptions` for configuring MPP and amountless payments

### Improvements
- Better error handling with updated CDK error types
- Database now uses Arc for thread-safe sharing
- Updated documentation to match CDK standards

### Dependencies
- CDK 0.13.4
- flutter_rust_bridge 2.11.1

## 0.0.1

### Initial Release
- Single-mint and multi-mint wallet support
- Token minting, sending, receiving, and melting
- Real-time balance streaming with `streamBalance()`
- Transaction history management
- Payment request support (NUT-18)
- P2PK and HTLC spending conditions (NUT-10, NUT-11)
- Flutter widgets: `WalletBalanceBuilder`, `SendBuilder`, `ReceiveBuilder`, etc.
- Provider-based state management with `WalletProvider` and `MultiMintWalletProvider`
- SQLite-based wallet persistence
- Cross-platform support: Android, iOS, Linux, macOS, Windows
