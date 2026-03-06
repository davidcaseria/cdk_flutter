## 0.2.0

### Breaking Changes
- Upgraded to CDK v0.15.0
- Melt operations now use two-phase prepare/confirm pattern (wallet saga)
- `Wallet.send()` now takes amount, options, memo, and include_memo parameters directly (no PreparedSend)
- `Wallet.payRequest()` now takes request, memo, and include_memo parameters directly (no PreparedSend)
- Removed `prepare_send()` and `cancel_send()` from public API
- `melt_quote()` now requires `PaymentMethod` parameter (default: Bolt11)
- `mint_quote()` signature changed to support payment methods and extra parameters
- `check_pending_melt_quotes()` renamed to reflect new `finalize_pending_melts()` behavior
- `check_all_mint_quotes()` now returns list of quotes instead of amount
- HttpRoutePath enum variants changed to support generic payment methods (e.g., `MintQuote(String)` instead of `MintQuoteBolt11`)

### New Features
- Wallet saga pattern for all operations (mint, melt, send, receive, swap) with automatic recovery
- Async melt support (NUT-05) for non-blocking payment operations
- `recover_incomplete_sagas()` for recovering from interrupted operations
- `finalize_pending_melts()` to complete pending async melt operations
- NUT-26 Payment Request Bech32m Encoding support (CREQ-B format)
- Generic payment method support (not limited to Bolt11/Bolt12)
- Improved error recovery with saga compensation actions
- **Added `include_fee` option to `SendOptions`** - when true, the token amount will include fees needed to redeem it, fixing P2PK sends on mints with input_fee_ppk > 0

### Improvements
- Authentication (NUT-21/NUT-22) now always enabled
- Keyset V2 is now default for new keysets
- Better crash resilience through saga pattern
- Improved fee handling in melt operations
- Enhanced state management for quotes and proofs

### Dependencies
- CDK 0.15.0
- flutter_rust_bridge 2.11.1

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
