import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:flutter/material.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({super.key});

  @override
  ReceiveScreenState createState() => ReceiveScreenState();
}

class ReceiveScreenState extends State<ReceiveScreen> {
  final TextEditingController _tokenController = TextEditingController();
  bool _isSubmitted = false;

  void _submitToken() {
    setState(() {
      _isSubmitted = true;
    });
  }

  Widget _buildInputScreen() {
    return Column(
      children: [
        TextField(
          controller: _tokenController,
          decoration: const InputDecoration(labelText: 'Enter encoded token'),
        ),
        ElevatedButton(
          onPressed: _submitToken,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildReceiveScreen() {
    return ReceiveBuilder(
      token: _tokenController.text,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text('Received ${snapshot.data!.receivedAmount}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receive')),
      body: Center(
        child: _isSubmitted ? _buildReceiveScreen() : _buildInputScreen(),
      ),
    );
  }
}
