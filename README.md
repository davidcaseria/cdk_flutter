# cdk_flutter

Flutter bindings for the [Cashu Development Kit (CDK)](https://github.com/cashubtc/cdk) - build cross-platform Cashu wallets with native performance.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  cdk_flutter:
    git:
      url: https://github.com/cashubtc/cdk_flutter.git
```

## Quick Start

```dart
import 'package:cdk_flutter/cdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CdkFlutter.init();

  // Generate or load mnemonic
  final mnemonic = generateMnemonic();

  // Create database and wallet
  final db = await WalletDatabase.newInstance(path: 'wallet.sqlite');
  final wallet = Wallet(
    mintUrl: 'https://mint.example.com',
    unit: 'sat',
    mnemonic: mnemonic,
    db: db,
  );

  runApp(MyApp());
}
```

## Usage

### Mint Tokens

```dart
await wallet.mint(amount: 1000, sink: StreamSink((quote) {
  if (quote.state == MintQuoteState.unpaid) {
    print('Pay: ${quote.request}');
  } else if (quote.state == MintQuoteState.issued) {
    print('Minted ${quote.amount} sats');
  }
}));
```

### Send Tokens

```dart
final prepared = await wallet.prepareSend(amount: 100);
final token = await wallet.send(send: prepared);
print('Token: ${token.encoded}');
```

### Receive Tokens

```dart
final token = Token.parse(encoded: 'cashuA...');
final amount = await wallet.receive(token: token);
```

### Melt (Pay Lightning)

```dart
final quote = await wallet.meltQuote(request: 'lnbc...');
await wallet.melt(quote: quote);
```

### Multi-Mint Wallet

```dart
final multiWallet = await MultiMintWallet.newInstance(
  unit: 'sat',
  mnemonic: mnemonic,
  db: db,
);

await multiWallet.addMint(mintUrl: 'https://mint1.example.com');
final total = await multiWallet.totalBalance();
```

### Balance Widget

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

## Development

```bash
git clone https://github.com/cashubtc/cdk_flutter.git
cd cdk_flutter
flutter pub get
cd rust && cargo build && cd ..
flutter_rust_bridge_codegen generate
cd example && flutter run
```

## License

MIT License - see [LICENSE](LICENSE).

Part of the [Cashu Development Kit](https://github.com/cashubtc/cdk) ecosystem.
