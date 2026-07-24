import 'package:flutter/material.dart';

/// Yangqin tuner screen - placeholder
class YangqinTunerScreen extends StatelessWidget {
  const YangqinTunerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(child: Text('Yangqin Tuner - Coming soon')),
    );
  }
}
