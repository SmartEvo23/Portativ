import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

/// Mascota aplicației: o notă muzicală prietenoasă, cu ochi și zâmbet,
/// care se leagănă ușor - folosită ca ghid vizual în hărțile de lecții.
class MascotWidget extends StatefulWidget {
  const MascotWidget({super.key, this.size = 64, this.color = TColors.secondary});

  final double size;
  final Color color;

  @override
  State<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -_controller.value * 6),
        child: child,
      ),
      child: CustomPaint(
        size: Size(widget.size, widget.size * 1.35),
        painter: _MascotPainter(color: widget.color),
      ),
    );
  }
}

class _MascotPainter extends CustomPainter {
  _MascotPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final bodyRadius = size.width / 2;
    final center = Offset(size.width / 2, size.height - bodyRadius);

    // Codiță de notă (ca o antenă), cu steguleț.
    final stemPaint = Paint()
      ..color = TColors.textPrimary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final stemTop = Offset(center.dx + bodyRadius * 0.5, center.dy - bodyRadius * 1.6);
    final stemBottom = Offset(center.dx + bodyRadius * 0.5, center.dy - bodyRadius * 0.55);
    canvas.drawLine(stemBottom, stemTop, stemPaint);

    final flagPath = Path()
      ..moveTo(stemTop.dx, stemTop.dy)
      ..quadraticBezierTo(
        stemTop.dx + bodyRadius * 0.9,
        stemTop.dy + bodyRadius * 0.15,
        stemTop.dx + bodyRadius * 0.1,
        stemTop.dy + bodyRadius * 0.85,
      );
    canvas.drawPath(flagPath, stemPaint);

    // Corp (cap rotund).
    final shadowPaint = Paint()..color = Colors.black.withOpacity(0.15);
    canvas.drawCircle(center + const Offset(0, 4), bodyRadius, shadowPaint);
    final bodyPaint = Paint()..color = color;
    canvas.drawCircle(center, bodyRadius, bodyPaint);

    // Obrăjori.
    final blushPaint = Paint()..color = Colors.pink.withOpacity(0.35);
    canvas.drawCircle(center + Offset(-bodyRadius * 0.55, bodyRadius * 0.18), bodyRadius * 0.14, blushPaint);
    canvas.drawCircle(center + Offset(bodyRadius * 0.55, bodyRadius * 0.18), bodyRadius * 0.14, blushPaint);

    // Ochi.
    final eyePaint = Paint()..color = TColors.textPrimary;
    canvas.drawCircle(center + Offset(-bodyRadius * 0.35, -bodyRadius * 0.1), bodyRadius * 0.12, eyePaint);
    canvas.drawCircle(center + Offset(bodyRadius * 0.35, -bodyRadius * 0.1), bodyRadius * 0.12, eyePaint);

    // Zâmbet.
    final smilePaint = Paint()
      ..color = TColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final smileRect = Rect.fromCenter(
      center: center + Offset(0, bodyRadius * 0.18),
      width: bodyRadius * 0.8,
      height: bodyRadius * 0.6,
    );
    canvas.drawArc(smileRect, 0.25, math.pi - 0.5, false, smilePaint);
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) => oldDelegate.color != color;
}
