import 'package:flutter/material.dart';
import '../../app/theme.dart';

class ProScreen extends StatelessWidget {
  const ProScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TUNER PRO',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: AppTheme.accent,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tune more. Practice longer.',
              style: TextStyle(fontSize: 17, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            const Text(
              'Coming soon',
              style: TextStyle(fontSize: 16, color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
