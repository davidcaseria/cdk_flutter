import 'package:cdk_flutter/widgets.dart';
import 'package:flutter/material.dart';

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
                Navigator.pushNamed(context, '/melt');
              },
              child: const Text('Melt'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/mint');
              },
              child: const Text('Mint'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/receive');
              },
              child: const Text('Receive'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/send');
              },
              child: const Text('Send'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/request');
              },
              child: const Text('Request'),
            ),
          ],
        ),
      ),
    );
  }
}
