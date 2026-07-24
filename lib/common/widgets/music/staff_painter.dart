import 'package:flutter/material.dart';

/// Desenează un portativ muzical (5 linii) cu o cheie sol stilizată și una sau mai
/// multe note, poziționate după sistemul de coordonate din `TrebleClefNotes`
/// (poziția 0 = a doua linie de jos / Mi4, crescând cu 1 pentru fiecare linie sau spațiu).
class StaffPainter extends CustomPainter {
  StaffPainter({
    required this.notePositions,
    this.highlightIndex,
    this.showClef = true,
    this.lineColor = const Color(0xFF333333),
    this.noteColor = const Color(0xFF209292),
    this.highlightColor = const Color(0xFFFFA000),
  });

  final List<int> notePositions;
  final int? highlightIndex;
  final bool showClef;
  final Color lineColor;
  final Color noteColor;
  final Color highlightColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double lineGap = size.height / 5;
    final double posUnit = lineGap / 2;
    final double staffBottomY = size.height * 0.80;
    final double staffTopY = staffBottomY - 4 * lineGap;
    final double staffLeft = size.width * 0.03;
    final double clefReserved = showClef ? size.width * 0.20 : size.width * 0.05;
    final double notesLeft = clefReserved;
    final double notesRight = size.width * 0.96;

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.4;

    for (int i = 0; i < 5; i++) {
      final double y = staffBottomY - i * lineGap;
      canvas.drawLine(Offset(staffLeft, y), Offset(notesRight, y), linePaint);
    }

    if (showClef) {
      _drawClef(canvas, staffLeft + lineGap * 0.35, staffTopY, staffBottomY, lineGap);
    }

    double yFor(int position) => staffBottomY - position * posUnit;

    if (notePositions.isEmpty) return;

    final double step = notePositions.length > 1 ? (notesRight - notesLeft) / notePositions.length : 0;

    for (int i = 0; i < notePositions.length; i++) {
      final int position = notePositions[i];
      final double x =
          notePositions.length == 1 ? (notesLeft + notesRight) / 2 : notesLeft + step * i + step / 2;
      final double y = yFor(position);
      final bool isHighlighted = highlightIndex == i;
      final Color activeColor = isHighlighted ? highlightColor : noteColor;

      // Linii suplimentare (ledger lines) dacă nota iese din portativ.
      final Paint ledgerPaint = Paint()
        ..color = lineColor
        ..strokeWidth = 1.4;
      final double ledgerHalfWidth = lineGap * 0.55;
      if (position < 0) {
        int e = -2;
        while (e >= position) {
          final double ly = yFor(e);
          canvas.drawLine(Offset(x - ledgerHalfWidth, ly), Offset(x + ledgerHalfWidth, ly), ledgerPaint);
          e -= 2;
        }
      } else if (position > 8) {
        int e = 10;
        while (e <= position) {
          final double ly = yFor(e);
          canvas.drawLine(Offset(x - ledgerHalfWidth, ly), Offset(x + ledgerHalfWidth, ly), ledgerPaint);
          e += 2;
        }
      }

      // Codiță (stem), desenată înainte de cap ca să iasă de sub el.
      final Paint stemPaint = Paint()
        ..color = activeColor
        ..strokeWidth = 1.6;
      final bool stemUp = position < 4;
      final double stemX = x + (stemUp ? lineGap * 0.44 : -lineGap * 0.44);
      final double stemLength = lineGap * 1.7;
      canvas.drawLine(
        Offset(stemX, y),
        Offset(stemX, stemUp ? y - stemLength : y + stemLength),
        stemPaint,
      );

      // Capul notei (oval ușor înclinat).
      final Paint notePaint = Paint()..color = activeColor;
      final Rect noteRect = Rect.fromCenter(center: Offset(x, y), width: lineGap * 0.95, height: lineGap * 0.72);
      canvas.save();
      canvas.translate(noteRect.center.dx, noteRect.center.dy);
      canvas.rotate(-0.35);
      canvas.translate(-noteRect.center.dx, -noteRect.center.dy);
      canvas.drawOval(noteRect, notePaint);
      canvas.restore();
    }
  }

  /// O cheie sol stilizată (nu caligrafică), suficient de recognoscibilă,
  /// desenată vectorial ca să se potrivească perfect cu orice temă sau dimensiune.
  void _drawClef(Canvas canvas, double x, double staffTopY, double staffBottomY, double lineGap) {
    final Paint paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineGap * 0.16
      ..strokeCap = StrokeCap.round;

    final double top = staffTopY - lineGap * 0.7;

    final Path path = Path()
      ..moveTo(x, top)
      ..cubicTo(
        x + lineGap * 0.95, top + lineGap * 0.3,
        x + lineGap * 0.95, top + lineGap * 1.3,
        x, top + lineGap * 1.7,
      )
      ..cubicTo(
        x - lineGap * 0.95, top + lineGap * 2.1,
        x - lineGap * 0.95, top + lineGap * 3.15,
        x + lineGap * 0.15, top + lineGap * 3.6,
      )
      ..cubicTo(
        x + lineGap * 1.1, top + lineGap * 4.05,
        x + lineGap * 1.15, top + lineGap * 5.0,
        x, top + lineGap * 5.45,
      );

    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(x - lineGap * 0.05, top + lineGap * 5.7), lineGap * 0.26, paint);
  }

  @override
  bool shouldRepaint(covariant StaffPainter oldDelegate) {
    return oldDelegate.notePositions != notePositions ||
        oldDelegate.highlightIndex != highlightIndex ||
        oldDelegate.showClef != showClef;
  }
}
