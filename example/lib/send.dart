import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  SendScreenState createState() => SendScreenState();
}

class SendScreenState extends State<SendScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isSubmitted = false;
  String? _token;

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
          decoration: const InputDecoration(labelText: 'Enter amount'),
          keyboardType: TextInputType.number,
        ),
        ElevatedButton(
          onPressed: _submitAmount,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildConfirmationScreen() {
    return SendBuilder(
        amount: BigInt.parse(_amountController.text),
        onSuccess: (token) {
          setState(() {
            _token = token;
          });
        },
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Text('Amount: ${snapshot.data!.preparedSend.amount}'),
                Text('Fee: ${snapshot.data!.preparedSend.sendFee}'),
                ElevatedButton(
                  onPressed: () {
                    snapshot.data!.send();
                  },
                  child: const Text('Send'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget _buildSuccessScreen() {
    return Column(
      children: [
        Text(_token!),
        ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: _token!));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Token copied to clipboard')),
            );
          },
          child: const Text('Copy Token'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send')),
      body: Center(
        child: _isSubmitted
            ? _token == null
                ? _buildConfirmationScreen()
                : _buildSuccessScreen()
            : _buildInputScreen(),
      ),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  final double amount;
  final double fee;

  const ConfirmationScreen({required this.amount, required this.fee, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmation')),
      body: Center(
        child: Text('Amount: \$${amount.toStringAsFixed(2)}\nFee: \$${fee.toStringAsFixed(2)}'),
      ),
    );
  }
}
