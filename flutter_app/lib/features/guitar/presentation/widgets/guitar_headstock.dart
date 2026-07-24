import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

/// Guitar headstock widget with 6 tuning pegs (3+3 layout)
class GuitarHeadstock extends StatelessWidget {
  final int activePeg; // 1-6
  final List<String> stringNotes; // ['E4', 'B3', 'G3', 'D3', 'A2', 'E2']
  final ValueChanged<int> onPegSelected; // peg number 1-6
  final ValueChanged<int> onNoteChange; // peg number 1-6

  const GuitarHeadstock({
    super.key,
    required this.activePeg,
    required this.stringNotes,
    required this.onPegSelected,
    required this.onNoteChange,
  });

  // Top row pegs (1, 2, 3)
  static const List<double> _topPegX = [0.35, 0.5, 0.65];
  // Bottom row pegs (4, 5, 6)
  static const List<double> _bottomPegX = [0.35, 0.5, 0.65];

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
          for (var i = 0; i < 3; i++) {
            // Top row (pegs 1, 2, 3)
            if ((x - _topPegX[i]).abs() < 0.1 && y < 0.5) {
              onPegSelected(i + 1);
              return;
            }
            // Bottom row (pegs 4, 5, 6)
            if ((x - _bottomPegX[i]).abs() < 0.1 && y >= 0.5) {
              onPegSelected(i + 4);
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
            for (var i = 0; i < 3; i++)
              Positioned(
                left: _topPegX[i] * 300 - 20,
                top: 10,
                child: _PegLabel(
                  text: '${i + 1}',
                  isActive: activePeg == i + 1,
                  note: stringNotes.length > i ? stringNotes[i] : '',
                ),
              ),
            for (var i = 0; i < 3; i++)
              Positioned(
                left: _bottomPegX[i] * 300 - 20,
                bottom: 10,
                child: _PegLabel(
                  text: '${i + 4}',
                  isActive: activePeg == i + 4,
                  note: stringNotes.length > i + 3 ? stringNotes[i + 3] : '',
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

    // Draw headstock body
    final headstockRect = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.1,
      size.width * 0.6,
      size.height * 0.8,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(headstockRect, const Radius.circular(20)),
      headstockPaint,
    );

    // Draw neck
    final neckRect = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.35,
      size.width * 0.15,
      size.height * 0.3,
    );
    canvas.drawRect(neckRect, neckPaint);

    // Draw strings
    for (var i = 0; i < 3; i++) {
      // Top strings
      final startX = topPegX[i] * size.width;
      final startY = size.height * 0.5;
      final endX = size.width * 0.1;
      final endY = size.height * 0.5 - 10 + i * 7;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), stringPaint);

      // Bottom strings
      final startX2 = bottomPegX[i] * size.width;
      final startY2 = size.height * 0.5;
      final endX2 = size.width * 0.1;
      final endY2 = size.height * 0.5 + 10 - i * 7;
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

    for (var i = 0; i < 3; i++) {
      // Top pegs
      final isTopActive = activePeg == i + 1;
      canvas.drawCircle(
        Offset(topPegX[i] * size.width, size.height * 0.3),
        15,
        isTopActive ? activePegPaint : pegPaint,
      );

      // Bottom pegs
      final isBottomActive = activePeg == i + 4;
      canvas.drawCircle(
        Offset(bottomPegX[i] * size.width, size.height * 0.7),
        15,
        isBottomActive ? activePegPaint : pegPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_HeadstockPainter oldDelegate) {
    return oldDelegate.activePeg != activePeg;
  }
}
