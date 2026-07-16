import 'package:flutter/material.dart';

class SplitScreen extends StatelessWidget {
  const SplitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bill Splitter')),
      body: const Center(child: Text('Bill Splitter - Coming Soon')),
    );
  }
}
