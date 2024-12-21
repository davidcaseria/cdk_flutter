import 'package:flutter/material.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  await CdkFlutter.init();
  final path = await getApplicationDocumentsDirectory();
  final db = WalletDatabase(path: '${path.path}/wallet.db');
  final wallet = Wallet(mintUrl: 'http://192.168.1.188:8085', unit: 'sat', seed: [0], localstore: db);
  runApp(WalletProvider(wallet: wallet, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        '/mintQuote': (context) => const MintQuoteScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CDK Flutter Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WalletBalanceBuilder(builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('Balance: ${snapshot.data}');
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const CircularProgressIndicator();
              }
            }),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/mintQuote');
              },
              child: const Text('Mint'),
            ),
          ],
        ),
      ),
    );
  }
}

class MintQuoteScreen extends StatelessWidget {
  const MintQuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mint Quote')),
      body: MintQuoteBuilder(
        amount: BigInt.from(1000),
        listener: (quote) {
          if (quote.state == MintQuoteState.issued) {
            Future.delayed(const Duration(milliseconds: 500), () {
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            });
          }
        },
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text('Quote: ${snapshot.data!.request} (${snapshot.data!.state})');
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
