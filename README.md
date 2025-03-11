# cdk_flutter

`cdk_flutter` is a Flutter library that provides a bridge to the Rust [CDK](https://github.com/cashubtc/cdk) [cashu](https://cashu.space) library using the `flutter_rust_bridge` package.

## Features

- Generate cryptographic seeds
- Manage wallets and mints
- Handle transactions and balances
- Flutter builder widgets

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  cdk_flutter:
    git:
      url: https://github.com/davidcaseria/cdk_flutter.git
```

Then, run `flutter pub get` to install the package.

## Usage

### Generating a Seed

To generate a cryptographic seed, use the `generateSeed` or `generateHexSeed` functions:

```dart
import 'package:cdk_flutter/cdk_flutter.dart';

Uint8List seed = generateSeed();
String hexSeed = generateHexSeed();
```

### Managing Wallets

You can create and manage wallets using the `Wallet` class:

```dart
import 'package:cdk_flutter/cdk_flutter.dart';

final db = WalletDatabase(path: 'path_to_db');
final wallet = Wallet.newFromHexSeed(
  mintUrl: 'http://testnut.cashu.space/',
  unit: 'sat',
  seed: 'your_hex_seed',
  localstore: db,
);
```

### Handling Transactions

To handle transactions, you can use methods like `prepareSend`, `receive`, and `send`:

```dart
PreparedSend send = await wallet.prepareSend(amount: BigInt.from(100));
await wallet.send(send: send);
```

### Display Balance

To display balance updates, use the `WalletBalanceBuilder` widget:

```dart
WalletBalanceBuilder(builder: (context, snapshot) {
  if (snapshot.hasData) {
    return Text('Balance: ${snapshot.data}');
  } else if (snapshot.hasError) {
    return Text('Error: ${snapshot.error}');
  } else {
    return const CircularProgressIndicator();
  }
});
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on GitHub.

## Acknowledgements

This library uses the `flutter_rust_bridge` package to facilitate communication between Flutter and Rust.


