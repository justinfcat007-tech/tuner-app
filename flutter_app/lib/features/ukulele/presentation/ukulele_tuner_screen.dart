import 'package:flutter/material.dart';

/// Ukulele tuner screen - placeholder
class UkuleleTunerScreen extends StatelessWidget {
  const UkuleleTunerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(child: Text('Ukulele Tuner - Coming soon')),
    );
  }
}
