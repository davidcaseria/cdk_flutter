import 'package:cdk_flutter_example/home.dart';
import 'package:cdk_flutter_example/melt.dart';
import 'package:cdk_flutter_example/mint.dart';
import 'package:cdk_flutter_example/receive.dart';
import 'package:cdk_flutter_example/request.dart';
import 'package:cdk_flutter_example/send.dart';
import 'package:flutter/material.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CdkFlutter.init();
  final path = await getApplicationDocumentsDirectory();

  final mnemonicFile = File('${path.path}/mnemonic.txt');
  String mnemonic;
  if (await mnemonicFile.exists()) {
    mnemonic = await mnemonicFile.readAsString();
  } else {
    mnemonic = generateMnemonic();
    await mnemonicFile.writeAsString(mnemonic);
  }

  final db = await WalletDatabase.newInstance(path: '${path.path}/wallet.sqlite');
  final wallet = Wallet(mintUrl: 'https://fake.thesimplekid.dev', unit: 'sat', mnemonic: mnemonic, db: db);
  runApp(WalletProvider(wallet: wallet, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        '/melt': (context) => const MeltScreen(),
        '/mint': (context) => const MintScreen(),
        '/receive': (context) => const ReceiveScreen(),
        '/send': (context) => const SendScreen(),
        '/request': (context) => const RequestScreen(),
      },
    );
  }
}
