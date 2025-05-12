import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String message;

  const PlaceholderScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заглушка')),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),
    );
  }
}
