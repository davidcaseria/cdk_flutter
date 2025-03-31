import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CDK Flutter Example')),
      body: Column(
        children: [
          Expanded(
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
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: [
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
              ],
            ),
          ),
          Expanded(
            child: TransactionListBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final transactions = snapshot.data!;
                  if (transactions.isEmpty) {
                    return const Center(child: Text('No transactions'));
                  }

                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final isOutgoing = transaction.direction == TransactionDirection.outgoing;
                      return ListTile(
                        leading: Icon(
                          isOutgoing ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isOutgoing ? Colors.red : Colors.green,
                        ),
                        title: Text(
                          '${isOutgoing ? '-' : ''}${transaction.amount}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${(transaction.direction == TransactionDirection.incoming) ? 'Incoming' : 'Outgoing'} Transaction'),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
