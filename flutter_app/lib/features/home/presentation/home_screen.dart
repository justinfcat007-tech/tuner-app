import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';

/// Home screen - Instrument selector
/// Matches Vue TunerView.vue
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TUNER',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/pro'),
                    style: TextButton.styleFrom(
                      side: BorderSide(color: AppTheme.accent, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(
                      'PRO',
                      style: TextStyle(
                        color: AppTheme.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Tune with confidence, anywhere.',
                style: TextStyle(fontSize: 15, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 24),

              // Instrument cards
              _InstrumentCard(
                name: 'Guitar',
                tuning: 'Standard tuning',
                onTap: () => context.go('/guitar'),
              ),
              const SizedBox(height: 12),
              _InstrumentCard(
                name: 'Ukulele',
                tuning: 'G – C – E – A',
                onTap: () => context.go('/ukulele'),
              ),
              const SizedBox(height: 12),
              _InstrumentCard(
                name: 'Yangqin',
                tuning: 'Explore',
                onTap: () => context.go('/yangqin'),
              ),
              const SizedBox(height: 24),

              // Pro entry card
              GestureDetector(
                onTap: () => context.go('/pro'),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWarm,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'More instruments & custom tunings are available in Pro.',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.ink,
                            height: 1.45,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Explore Pro',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accentStrong,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => context.go('/privacy'),
                    child: Text(
                      'Privacy',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                    ),
                  ),
                  Text('·', style: TextStyle(color: AppTheme.textMuted)),
                  TextButton(
                    onPressed: () => context.go('/support'),
                    child: Text(
                      'Support',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InstrumentCard extends StatelessWidget {
  final String name;
  final String tuning;
  final VoidCallback onTap;

  const _InstrumentCard({
    required this.name,
    required this.tuning,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(color: AppTheme.border, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tuning,
                  style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              ],
            ),
            Icon(Icons.chevron_right, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }
}
