import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../core/audio/audio_engine.dart';

/// Horizontal tuning meter with animated indicator
class TuningMeter extends StatelessWidget {
  final double cents; // -50 to +50
  final AudioEngineState state;

  const TuningMeter({
    super.key,
    required this.cents,
    this.state = AudioEngineState.idle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomPaint(
        painter: _MeterPainter(cents: cents, state: state),
        child: Center(
          child: Text(
            '${cents.round()} cents',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _MeterPainter extends CustomPainter {
  final double cents;
  final AudioEngineState state;

  _MeterPainter({required this.cents, required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw tick marks
    final tickPaint = Paint()
      ..color = AppTheme.textMuted
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final majorTickPaint = Paint()
      ..color = AppTheme.textPrimary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var i = -50; i <= 50; i += 5) {
      final x = center.dx + (i / 50) * (size.width / 2 - 20);
      final isMajor = i % 10 == 0;
      final tickHeight = isMajor ? 12.0 : 6.0;

      canvas.drawLine(
        Offset(x, center.dy - tickHeight),
        Offset(x, center.dy + tickHeight),
        isMajor ? majorTickPaint : tickPaint,
      );
    }

    // Draw center line (in tune)
    final centerLinePaint = Paint()
      ..color = AppTheme.success
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(center.dx, center.dy - 15),
      Offset(center.dx, center.dy + 15),
      centerLinePaint,
    );

    // Draw indicator
    if (state == AudioEngineState.detected ||
        state == AudioEngineState.listening) {
      final clampedCents = cents.clamp(-50.0, 50.0);
      final indicatorX =
          center.dx + (clampedCents / 50) * (size.width / 2 - 20);

      final indicatorPaint = Paint()
        ..color = cents.abs() <= 5
            ? AppTheme.success
            : cents > 0
            ? AppTheme.danger
            : AppTheme.warning
        ..style = PaintingStyle.fill;

      // Draw triangle indicator
      final path = Path()
        ..moveTo(indicatorX, center.dy - 20)
        ..lineTo(indicatorX - 8, center.dy - 8)
        ..lineTo(indicatorX + 8, center.dy - 8)
        ..close();

      canvas.drawPath(path, indicatorPaint);
    }
  }

  @override
  bool shouldRepaint(_MeterPainter oldDelegate) {
    return oldDelegate.cents != cents || oldDelegate.state != state;
  }
}

/// Note display widget
class NoteDisplay extends StatelessWidget {
  final String note;
  final double frequency;
  final bool inTune;

  const NoteDisplay({
    super.key,
    required this.note,
    required this.frequency,
    this.inTune = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          note,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: inTune ? AppTheme.success : AppTheme.textPrimary,
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${frequency.toStringAsFixed(1)} Hz',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}

/// Status indicator widget
class StatusIndicator extends StatelessWidget {
  final bool inTune;
  final bool tooHigh;
  final bool tooLow;

  const StatusIndicator({
    super.key,
    required this.inTune,
    required this.tooHigh,
    required this.tooLow,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String text;

    if (inTune) {
      icon = Icons.check_circle;
      color = AppTheme.success;
      text = 'In Tune';
    } else if (tooHigh) {
      icon = Icons.arrow_upward;
      color = AppTheme.danger;
      text = 'Too High';
    } else if (tooLow) {
      icon = Icons.arrow_downward;
      color = AppTheme.warning;
      text = 'Too Low';
    } else {
      icon = Icons.circle_outlined;
      color = AppTheme.textMuted;
      text = 'Play a note';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
