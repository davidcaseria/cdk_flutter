import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  RequestScreenState createState() => RequestScreenState();
}

class RequestScreenState extends State<RequestScreen> {
  final _amountController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    final amount = BigInt.tryParse(_amountController.text);
    if (amount != null) {
      setState(() {
        // Set the submitting state to true
        _isSubmitting = true;
      });
    } else {
      // Show an error message if the amount is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid amount')),
      );
    }
  }

  Widget _buildFormScreen() {
    return Column(
      children: [
        TextField(
          controller: _amountController,
          decoration: const InputDecoration(labelText: 'Enter amount'),
          keyboardType: TextInputType.number,
        ),
        ElevatedButton(
          onPressed: _submitRequest,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildRequestScreen() {
    final request = PaymentRequest(
      amount: BigInt.tryParse(_amountController.text),
      transports: [Transport(type: TransportType.httpPost, target: 'http://example.com')],
    );
    return Column(
      children: [
        Text(request.encode()),
        ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: request.encode()));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Request copied to clipboard')),
            );
          },
          child: const Text('Copy Request'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: (_isSubmitting) ? _buildRequestScreen() : _buildFormScreen(),
      ),
    );
  }
}
