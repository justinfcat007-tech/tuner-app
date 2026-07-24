import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

/// Ukulele headstock widget with 4 tuning pegs (2+2 layout)
class UkuleleHeadstock extends StatelessWidget {
  final int activePeg; // 1-4
  final List<String> stringNotes; // ['A4', 'E4', 'C4', 'G4']
  final ValueChanged<int> onPegSelected; // peg number 1-4
  final ValueChanged<int> onNoteChange; // peg number 1-4

  const UkuleleHeadstock({
    super.key,
    required this.activePeg,
    required this.stringNotes,
    required this.onPegSelected,
    required this.onNoteChange,
  });

  // Top row pegs (1, 2)
  static const List<double> _topPegX = [0.4, 0.6];
  // Bottom row pegs (3, 4)
  static const List<double> _bottomPegX = [0.4, 0.6];

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 200),
      painter: _HeadstockPainter(
        activePeg: activePeg,
        topPegX: _topPegX,
        bottomPegX: _bottomPegX,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) {
          final size = context.size ?? const Size(300, 200);
          final x = details.localPosition.dx / size.width;
          final y = details.localPosition.dy / size.height;

          // Check which peg was tapped
          for (var i = 0; i < 2; i++) {
            // Top row (pegs 1, 2)
            if ((x - _topPegX[i]).abs() < 0.12 && y < 0.5) {
              onPegSelected(i + 1);
              return;
            }
            // Bottom row (pegs 3, 4)
            if ((x - _bottomPegX[i]).abs() < 0.12 && y >= 0.5) {
              onPegSelected(i + 3);
              return;
            }
          }
        },
        onLongPress: () {
          // TODO: Show note picker for active peg
        },
        child: Stack(
          children: [
            // String labels
            for (var i = 0; i < 2; i++)
              Positioned(
                left: _topPegX[i] * 300 - 20,
                top: 10,
                child: _PegLabel(
                  text: '${i + 1}',
                  isActive: activePeg == i + 1,
                  note: stringNotes.length > i ? stringNotes[i] : '',
                ),
              ),
            for (var i = 0; i < 2; i++)
              Positioned(
                left: _bottomPegX[i] * 300 - 20,
                bottom: 10,
                child: _PegLabel(
                  text: '${i + 3}',
                  isActive: activePeg == i + 3,
                  note: stringNotes.length > i + 2 ? stringNotes[i + 2] : '',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PegLabel extends StatelessWidget {
  final String text;
  final bool isActive;
  final String note;

  const _PegLabel({
    required this.text,
    required this.isActive,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppTheme.accent : AppTheme.surfaceRaised,
            border: Border.all(
              color: isActive ? AppTheme.accent : AppTheme.border,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isActive ? AppTheme.ink : AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          note,
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}

class _HeadstockPainter extends CustomPainter {
  final int activePeg;
  final List<double> topPegX;
  final List<double> bottomPegX;

  _HeadstockPainter({
    required this.activePeg,
    required this.topPegX,
    required this.bottomPegX,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final headstockPaint = Paint()
      ..color = const Color(0xFF8B6914)
      ..style = PaintingStyle.fill;

    final neckPaint = Paint()
      ..color = const Color(0xFF3A2515)
      ..style = PaintingStyle.fill;

    final stringPaint = Paint()
      ..color = AppTheme.textSecondary
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw headstock body (smaller than guitar)
    final headstockRect = Rect.fromLTWH(
      size.width * 0.25,
      size.height * 0.15,
      size.width * 0.5,
      size.height * 0.7,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(headstockRect, const Radius.circular(16)),
      headstockPaint,
    );

    // Draw neck
    final neckRect = Rect.fromLTWH(
      size.width * 0.15,
      size.height * 0.35,
      size.width * 0.12,
      size.height * 0.3,
    );
    canvas.drawRect(neckRect, neckPaint);

    // Draw strings (4 strings)
    for (var i = 0; i < 2; i++) {
      // Top strings
      final startX = topPegX[i] * size.width;
      final startY = size.height * 0.5;
      final endX = size.width * 0.15;
      final endY = size.height * 0.5 - 8 + i * 6;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), stringPaint);

      // Bottom strings
      final startX2 = bottomPegX[i] * size.width;
      final startY2 = size.height * 0.5;
      final endX2 = size.width * 0.15;
      final endY2 = size.height * 0.5 + 8 - i * 6;
      canvas.drawLine(
        Offset(startX2, startY2),
        Offset(endX2, endY2),
        stringPaint,
      );
    }

    // Draw peg circles
    final pegPaint = Paint()
      ..color = AppTheme.surfaceRaised
      ..style = PaintingStyle.fill;

    final activePegPaint = Paint()
      ..color = AppTheme.accent
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 2; i++) {
      // Top pegs
      final isTopActive = activePeg == i + 1;
      canvas.drawCircle(
        Offset(topPegX[i] * size.width, size.height * 0.35),
        12,
        isTopActive ? activePegPaint : pegPaint,
      );

      // Bottom pegs
      final isBottomActive = activePeg == i + 3;
      canvas.drawCircle(
        Offset(bottomPegX[i] * size.width, size.height * 0.65),
        12,
        isBottomActive ? activePegPaint : pegPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_HeadstockPainter oldDelegate) {
    return oldDelegate.activePeg != activePeg;
  }
}
