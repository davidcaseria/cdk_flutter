import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => await CdkFlutter.init());
  test('Create a wallet', () async {
    final path = await getTemporaryDirectory();
    final db = await WalletDatabase.newInstance(path: '${path.path}/wallet.db');
    final wallet = Wallet(mintUrl: 'http://localhost:8085', unit: 'sat', mnemonic: 'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about', db: db);
    expect(wallet, isNotNull);
  });
}
