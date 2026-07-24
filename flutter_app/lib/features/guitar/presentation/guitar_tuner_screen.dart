import 'package:flutter/material.dart';

import '../../../app/theme.dart';

/// Guitar tuner screen - placeholder
class GuitarTunerScreen extends StatelessWidget {
  const GuitarTunerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Help')),
          TextButton(onPressed: () {}, child: const Text('Settings')),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 64, color: AppTheme.accent),
            const SizedBox(height: 16),
            Text(
              'Guitar Tuner',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
