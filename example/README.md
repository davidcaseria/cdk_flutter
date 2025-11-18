# cdk_flutter Example

A complete example app demonstrating the cdk_flutter plugin for building Cashu wallets.

## Overview

This example app showcases core Cashu wallet functionality:
- Wallet initialization and seed management
- Real-time balance display
- Minting tokens from Lightning payments
- Sending and receiving Cashu tokens
- Melting tokens to pay Lightning invoices
- Creating payment requests
- Transaction history

## Running the Example

### Prerequisites

- Flutter 3.3.0+
- Rust (latest stable)
- A device/emulator to run the app

### Setup

1. Navigate to the example directory:
   ```bash
   cd example
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## App Structure

### Screens

| Screen | File | Description |
|--------|------|-------------|
| Home | `home.dart` | Main screen with balance, transaction history, and navigation |
| Mint | `mint.dart` | Create mint quotes and receive tokens from Lightning |
| Send | `send.dart` | Prepare and send Cashu tokens |
| Receive | `receive.dart` | Redeem received Cashu tokens |
| Melt | `melt.dart` | Pay Lightning invoices with tokens |
| Request | `request.dart` | Create and share payment requests |

### Configuration

#### Default Mint

The example uses the testnut Cashu mint by default:
```dart
const mintUrl = 'https://testnut.cashu.space';
```

To use a different mint, modify the `mintUrl` constant in `main.dart`.

#### Data Storage

- **Mnemonic**: Stored in `mnemonic.txt` in the app's documents directory
- **Database**: SQLite database at `wallet.sqlite` in the documents directory

On first launch, a new random BIP39 mnemonic is generated and persisted. The wallet will restore from this mnemonic on subsequent launches.

## Features Demonstrated

### Initialization (`main.dart`)

```dart
// Initialize the Rust library
await CdkFlutter.init();

// Load or generate mnemonic
final mnemonicFile = File('${dir.path}/mnemonic.txt');
String mnemonic;
if (await mnemonicFile.exists()) {
  mnemonic = await mnemonicFile.readAsString();
} else {
  mnemonic = generateMnemonic();
  await mnemonicFile.writeAsString(mnemonic);
}

// Create wallet
final db = await WalletDatabase.newInstance(path: '${dir.path}/wallet.sqlite');
final wallet = Wallet(
  mintUrl: mintUrl,
  unit: 'sat',
  mnemonic: mnemonic,
  db: db,
);
```

### Balance Display (`home.dart`)

Uses `WalletBalanceBuilder` to stream real-time balance updates:

```dart
WalletBalanceBuilder(
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text('${snapshot.data} sats');
    }
    return CircularProgressIndicator();
  },
)
```

### Transaction History (`home.dart`)

Uses `TransactionListBuilder` to display transaction history:

```dart
TransactionListBuilder(
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final tx = snapshot.data![index];
          return ListTile(
            title: Text('${tx.amount} sats'),
            subtitle: Text(tx.memo ?? 'No memo'),
          );
        },
      );
    }
    return CircularProgressIndicator();
  },
)
```

### Minting Tokens (`mint.dart`)

```dart
MintQuoteBuilder(
  amount: amount,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final quote = snapshot.data!;
      switch (quote.state) {
        case MintQuoteState.unpaid:
          // Display Lightning invoice QR code
          return Text(quote.request);
        case MintQuoteState.issued:
          // Tokens minted successfully
          Navigator.pop(context);
      }
    }
    return CircularProgressIndicator();
  },
)
```

### Sending Tokens (`send.dart`)

Three-stage flow:
1. Input amount
2. Review prepared send (amount, fees)
3. Display generated token

```dart
// Prepare send
SendBuilder(
  amount: amount,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final prepared = snapshot.data!;
      return Column(
        children: [
          Text('Amount: ${prepared.amount}'),
          Text('Fee: ${prepared.fee}'),
          ElevatedButton(
            onPressed: () => _confirmSend(prepared),
            child: Text('Confirm'),
          ),
        ],
      );
    }
  },
)
```

### Receiving Tokens (`receive.dart`)

```dart
// Parse and receive token
ReceiveBuilder(
  encoded: tokenString,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text('Received ${snapshot.data} sats');
    }
    return CircularProgressIndicator();
  },
)
```

### Melting Tokens (`melt.dart`)

```dart
// Get melt quote
MeltQuoteBuilder(
  request: bolt11Invoice,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final quote = snapshot.data!;
      return Column(
        children: [
          Text('Amount: ${quote.amount}'),
          Text('Fee: ${quote.feeReserve}'),
          ElevatedButton(
            onPressed: () => _executeMelt(quote),
            child: Text('Pay'),
          ),
        ],
      );
    }
  },
)
```

### Payment Requests (`request.dart`)

```dart
// Create payment request
final request = PaymentRequest(
  amount: amount,
  unit: 'sat',
  mints: [mintUrl],
  description: 'Payment for services',
);

// Encode for sharing
final encoded = request.encode();
```

## Troubleshooting

### Build Errors

If you encounter Rust build errors:
```bash
cd ../rust
cargo build
cd ../example
flutter clean
flutter pub get
flutter run
```

### Database Issues

To reset the wallet, delete the app data:
- **Android**: Clear app data in settings
- **iOS**: Delete and reinstall the app
- **Desktop**: Delete `mnemonic.txt` and `wallet.sqlite` from documents directory

### Mint Connection

If the mint is unreachable:
1. Check your internet connection
2. Verify the mint URL is correct
3. Try a different mint (e.g., `https://mint.minibits.cash/Bitcoin`)

## License

This example is part of cdk_flutter and is licensed under the MIT License.
