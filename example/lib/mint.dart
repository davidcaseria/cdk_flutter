import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:flutter/material.dart';

class MintScreen extends StatefulWidget {
  const MintScreen({super.key});

  @override
  MintScreenState createState() => MintScreenState();
}

class MintScreenState extends State<MintScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isSubmitted = false;

  void _submitAmount() {
    setState(() {
      _isSubmitted = true;
    });
  }

  Widget _buildInputScreen() {
    return Column(
      children: [
        TextField(
          controller: _amountController,
          decoration: const InputDecoration(labelText: 'Enter mint amount'),
          keyboardType: TextInputType.number,
        ),
        ElevatedButton(
          onPressed: _submitAmount,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildMintQuoteScreen() {
    return MintQuoteBuilder(
      amount: BigInt.parse(_amountController.text),
      listener: (quote) {
        if (quote.state == MintQuoteState.issued) {
          Future.delayed(const Duration(milliseconds: 500), () {
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          });
        }
      },
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.error == null) {
          return Text('${snapshot.data!.request} (${snapshot.data!.state})');
        } else if (snapshot.hasError || snapshot.data?.error != null) {
          return Text('Error: ${snapshot.error ?? snapshot.data!.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mint Quote')),
      body: Center(child: _isSubmitted ? _buildMintQuoteScreen() : _buildInputScreen()),
    );
  }
}
