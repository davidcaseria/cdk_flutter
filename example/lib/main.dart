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

  final seedFile = File('${path.path}/seed.txt');
  String seed;
  if (await seedFile.exists()) {
    seed = await seedFile.readAsString();
  } else {
    seed = generateHexSeed();
    await seedFile.writeAsString(seed);
  }

  final db = WalletDatabase(path: '${path.path}/wallet.db');
  final wallet = Wallet.newFromHexSeed(mintUrl: 'http://testnut.cashu.space/', unit: 'sat', seed: seed, localstore: db);
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
