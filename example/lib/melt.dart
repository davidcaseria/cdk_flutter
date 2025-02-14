import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:flutter/material.dart';

class MeltScreen extends StatefulWidget {
  const MeltScreen({super.key});

  @override
  MeltScreenState createState() => MeltScreenState();
}

class MeltScreenState extends State<MeltScreen> {
  final TextEditingController _requestController = TextEditingController();
  bool _isSubmitted = false;
  BigInt? _meltedAmount;

  void _submitRequest() {
    setState(() {
      _isSubmitted = true;
    });
  }

  Widget _buildInputScreen() {
    return Column(
      children: [
        TextField(
          controller: _requestController,
          decoration: const InputDecoration(labelText: 'Enter request'),
        ),
        ElevatedButton(
          onPressed: _submitRequest,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildConfirmationScreen() {
    return MeltQuoteBuilder(
      request: _requestController.text,
      onSuccess: (amount) {
        setState(() {
          _meltedAmount = amount;
        });
      },
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text('Amount: ${snapshot.data!.quote.amount}'),
              Text('Fee Reserve: ${snapshot.data!.quote.feeReserve}'),
              ElevatedButton(
                onPressed: () {
                  snapshot.data!.melt();
                },
                child: const Text('Melt'),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildSuccessScreen() {
    return Column(
      children: [
        Text('Total Amount Melted: $_meltedAmount'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Melt')),
      body: Center(
        child: _isSubmitted
            ? _meltedAmount == null
                ? _buildConfirmationScreen()
                : _buildSuccessScreen()
            : _buildInputScreen(),
      ),
    );
  }
}
