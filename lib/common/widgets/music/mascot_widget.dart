import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

/// Tipuri de mascotă folosite pe hărțile de lecții:
/// - [explorer]: personajul principal, care se plimbă pe hartă și duce steagul.
/// - [musician]: mascotă-companion care ține un instrument și "cântă" în buclă, cu chef.
/// - [dancer]: mascotă-companion mascată, care dansează (de obicei în pereche).
enum MascotVariant { explorer, musician, dancer }

/// Instrumentul ținut de o mascotă-muzician.
enum MascotInstrument { tambourine, guitar, bell, microphone }

/// Un mic personaj-omuleț, prietenos și animat: cap, tors, brațe, picioare,
/// ochi care clipesc, zâmbet larg. Poate purta o mască de bal mascat și poate
/// ține/cânta la un instrument - folosit ca ghid (exploratorul) sau ca
/// "locuitor" companion al fiecărui tărâm din hărțile de lecții.
class MascotWidget extends StatefulWidget {
  const MascotWidget({
    super.key,
    this.size = 64,
    this.color = TColors.secondary,
    this.variant = MascotVariant.explorer,
    this.instrument = MascotInstrument.tambourine,
    this.masked = false,
    this.celebrate = false,
    this.carryingFlag = false,
  });

  final double size;

  /// Culoarea costumului/hainelor personajului.
  final Color color;
  final MascotVariant variant;
  final MascotInstrument instrument;

  /// Poartă o mască de bal mascat (folosit pentru companionii tărâmurilor).
  final bool masked;

  /// Când comută pe `true`, mascota face un salt/rotire scurtă de sărbătoare
  /// (folosit când se termină o lecție sau un tărâm întreg).
  final bool celebrate;

  /// Exploratorul duce un steguleț în mână (cât timp merge spre nodul următor).
  final bool carryingFlag;

  @override
  State<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget> with TickerProviderStateMixin {
  late final AnimationController _bobController = AnimationController(
    vsync: this,
    duration: Duration(
      milliseconds: widget.variant == MascotVariant.dancer
          ? 700
          : widget.variant == MascotVariant.musician
              ? 480
              : 1400,
    ),
  )..repeat(reverse: true);

  late final AnimationController _blinkController =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 130));

  late final AnimationController _celebrateController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed) _celebrateController.value = 0;
    });

  Timer? _blinkTimer;

  @override
  void initState() {
    super.initState();
    _scheduleBlink();
    if (widget.celebrate) _celebrateController.forward(from: 0);
  }

  @override
  void didUpdateWidget(covariant MascotWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.celebrate && !oldWidget.celebrate) {
      _celebrateController.forward(from: 0);
    }
  }

  void _scheduleBlink() {
    final waitMs = 1800 + math.Random().nextInt(2600);
    _blinkTimer = Timer(Duration(milliseconds: waitMs), () async {
      if (!mounted) return;
      await _blinkController.forward(from: 0);
      if (!mounted) return;
      await _blinkController.reverse();
      if (!mounted) return;
      _scheduleBlink();
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _bobController.dispose();
    _blinkController.dispose();
    _celebrateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDancer = widget.variant == MascotVariant.dancer;
    return AnimatedBuilder(
      animation: Listenable.merge([_bobController, _celebrateController]),
      builder: (context, child) {
        final t = _bobController.value;
        final bob = isDancer ? math.sin(t * math.pi) * 6 : -t * 5;
        final sway = isDancer ? math.sin(t * 2 * math.pi) * 0.16 : 0.0;
        final spin = widget.celebrate ? _celebrateController.value * 2 * math.pi : 0.0;
        final bump = math.sin(_celebrateController.value * math.pi) * 0.22;
        return Transform.translate(
          offset: Offset(0, bob),
          child: Transform.rotate(
            angle: sway + spin,
            child: Transform.scale(scale: 1 + bump, child: child),
          ),
        );
      },
      child: CustomPaint(
        size: Size(widget.size, widget.size * 1.35),
        painter: _MascotPainter(
          color: widget.color,
          variant: widget.variant,
          instrument: widget.instrument,
          masked: widget.masked,
          blink: _blinkController,
          armPhase: _bobController,
          carryingFlag: widget.carryingFlag,
        ),
      ),
    );
  }
}

class _MascotPainter extends CustomPainter {
  _MascotPainter({
    required this.color,
    required this.variant,
    required this.instrument,
    required this.masked,
    required this.blink,
    required this.armPhase,
    required this.carryingFlag,
  }) : super(repaint: Listenable.merge([blink, armPhase]));

  final Color color;
  final MascotVariant variant;
  final MascotInstrument instrument;
  final bool masked;
  final Animation<double> blink;
  final Animation<double> armPhase;
  final bool carryingFlag;

  static const _skin = Color(0xFFFFD8B0);

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width;
    final swing = math.sin(armPhase.value * 2 * math.pi);

    final headR = unit * 0.30;
    final headCenter = Offset(unit / 2, headR + unit * 0.06);
    final legLength = unit * 0.34;
    final torsoTop = headCenter.dy + headR - unit * 0.05;
    final torsoBottom = size.height - legLength;

    // --- umbră ---
    canvas.drawOval(
      Rect.fromCenter(center: Offset(unit / 2, size.height - 2), width: unit * 0.6, height: unit * 0.12),
      Paint()..color = Colors.black.withOpacity(0.12),
    );

    // --- picioare ---
    final legPaint = Paint()..color = TColors.textPrimary.withOpacity(0.75);
    for (final side in [-1, 1]) {
      final legRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(unit / 2 + side * unit * 0.14, torsoBottom + legLength / 2),
          width: unit * 0.14,
          height: legLength,
        ),
        Radius.circular(unit * 0.06),
      );
      canvas.drawRRect(legRect, legPaint);
    }

    // --- tors (tunică) ---
    final torsoPath = Path()
      ..moveTo(unit / 2 - unit * 0.30, torsoTop)
      ..lineTo(unit / 2 + unit * 0.30, torsoTop)
      ..lineTo(unit / 2 + unit * 0.38, torsoBottom)
      ..lineTo(unit / 2 - unit * 0.38, torsoBottom)
      ..close();
    canvas.drawPath(torsoPath, Paint()..color = color);
    canvas.drawPath(
      torsoPath,
      Paint()
        ..color = Colors.black.withOpacity(0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    // --- brațe + recuzită (desenate înainte de cap, ca să iasă capul deasupra) ---
    final armPaint = Paint()
      ..color = TColors.textPrimary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final leftShoulder = Offset(unit / 2 - unit * 0.30, torsoTop + unit * 0.04);
    final rightShoulder = Offset(unit / 2 + unit * 0.30, torsoTop + unit * 0.04);
    _paintArmsAndProps(canvas, unit, leftShoulder, rightShoulder, armPaint, swing);

    // --- cap ---
    canvas.drawCircle(headCenter + const Offset(0, 3), headR, Paint()..color = Colors.black.withOpacity(0.12));
    canvas.drawCircle(headCenter, headR, Paint()..color = _skin);

    // păr/beretă simplă, în culoarea costumului, pentru coerență vizuală.
    final hairPath = Path()
      ..moveTo(headCenter.dx - headR, headCenter.dy - headR * 0.05)
      ..quadraticBezierTo(headCenter.dx, headCenter.dy - headR * 1.5, headCenter.dx + headR, headCenter.dy - headR * 0.05)
      ..quadraticBezierTo(headCenter.dx, headCenter.dy - headR * 0.72, headCenter.dx - headR, headCenter.dy - headR * 0.05)
      ..close();
    canvas.drawPath(hairPath, Paint()..color = color.withOpacity(0.9));

    // obrăjori
    final blushPaint = Paint()..color = Colors.pink.withOpacity(0.35);
    canvas.drawCircle(headCenter + Offset(-headR * 0.5, headR * 0.22), headR * 0.15, blushPaint);
    canvas.drawCircle(headCenter + Offset(headR * 0.5, headR * 0.22), headR * 0.15, blushPaint);

    // ochi (clipesc periodic)
    final eyeOpen = 1 - blink.value;
    final eyePaint = Paint()..color = TColors.textPrimary;
    for (final dx in [-headR * 0.4, headR * 0.4]) {
      final eyeCenter = headCenter + Offset(dx, 0);
      if (eyeOpen > 0.15) {
        canvas.drawCircle(eyeCenter, headR * 0.13 * eyeOpen.clamp(0.4, 1.0), eyePaint);
      } else {
        canvas.drawLine(
          eyeCenter + Offset(-headR * 0.12, 0),
          eyeCenter + Offset(headR * 0.12, 0),
          Paint()
            ..color = TColors.textPrimary
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    // mască de bal mascat (companionii tărâmurilor).
    if (masked) {
      final maskPath = Path()
        ..moveTo(headCenter.dx - headR * 0.85, headCenter.dy - headR * 0.08)
        ..quadraticBezierTo(headCenter.dx, headCenter.dy - headR * 0.55, headCenter.dx + headR * 0.85, headCenter.dy - headR * 0.08)
        ..quadraticBezierTo(headCenter.dx, headCenter.dy + headR * 0.28, headCenter.dx - headR * 0.85, headCenter.dy - headR * 0.08)
        ..close();
      canvas.drawPath(maskPath, Paint()..color = TColors.textPrimary.withOpacity(0.88));
      for (final dx in [-headR * 0.4, headR * 0.4]) {
        canvas.drawCircle(headCenter + Offset(dx, 0), headR * 0.16, Paint()..color = _skin);
        canvas.drawCircle(headCenter + Offset(dx, 0), headR * 0.1, eyePaint);
      }
    }

    // zâmbet
    final smilePaint = Paint()
      ..color = TColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    final smileRect = Rect.fromCenter(center: headCenter + Offset(0, headR * 0.35), width: headR * 0.9, height: headR * 0.7);
    canvas.drawArc(smileRect, 0.15, math.pi - 0.3, false, smilePaint);
  }

  void _paintArmsAndProps(
    Canvas canvas,
    double unit,
    Offset leftShoulder,
    Offset rightShoulder,
    Paint armPaint,
    double swing,
  ) {
    if (variant == MascotVariant.dancer) {
      final leftHand = leftShoulder + Offset(-unit * 0.28, -unit * (0.30 + 0.09 * swing));
      final rightHand = rightShoulder + Offset(unit * 0.28, -unit * (0.30 - 0.09 * swing));
      canvas.drawLine(leftShoulder, leftHand, armPaint);
      canvas.drawLine(rightShoulder, rightHand, armPaint);
      return;
    }

    if (variant == MascotVariant.musician) {
      switch (instrument) {
        case MascotInstrument.guitar:
          final bodyCenter = Offset(unit / 2, leftShoulder.dy + unit * 0.30);
          canvas.drawLine(leftShoulder, bodyCenter + Offset(-unit * 0.05, -unit * 0.05), armPaint);
          canvas.drawOval(
            Rect.fromCenter(center: bodyCenter, width: unit * 0.30, height: unit * 0.40),
            Paint()..color = const Color(0xFF8D5A2B),
          );
          canvas.drawCircle(bodyCenter, unit * 0.055, Paint()..color = const Color(0xFF5C3A1B));
          final neckTop = bodyCenter + Offset(unit * 0.22, -unit * 0.42);
          canvas.drawLine(
            bodyCenter + Offset(unit * 0.10, -unit * 0.14),
            neckTop,
            Paint()
              ..color = const Color(0xFF5C3A1B)
              ..strokeWidth = unit * 0.045
              ..strokeCap = StrokeCap.round,
          );
          final rightHand = bodyCenter + Offset(-unit * 0.02, -unit * (0.02 + 0.10 * swing.abs()));
          canvas.drawLine(rightShoulder, rightHand, armPaint);
          break;

        case MascotInstrument.bell:
          final triCenter = leftShoulder + Offset(-unit * 0.24, unit * 0.10);
          canvas.drawLine(leftShoulder, triCenter, armPaint);
          final s = unit * 0.16;
          final tri = Path()
            ..moveTo(triCenter.dx, triCenter.dy - s)
            ..lineTo(triCenter.dx + s, triCenter.dy + s * 0.6)
            ..lineTo(triCenter.dx - s, triCenter.dy + s * 0.6)
            ..close();
          canvas.drawPath(
            tri,
            Paint()
              ..color = const Color(0xFFB0BEC5)
              ..style = PaintingStyle.stroke
              ..strokeWidth = unit * 0.035
              ..strokeCap = StrokeCap.round,
          );
          final stickEnd = triCenter + Offset(unit * 0.12 * swing, -unit * 0.02);
          canvas.drawLine(rightShoulder, stickEnd, armPaint);
          break;

        case MascotInstrument.microphone:
          final micHand = rightShoulder + Offset(unit * 0.06, -unit * 0.30);
          canvas.drawLine(rightShoulder, micHand, armPaint);
          canvas.drawLine(
            micHand,
            micHand + Offset(0, -unit * 0.14),
            Paint()
              ..color = TColors.darkGrey
              ..strokeWidth = unit * 0.03
              ..strokeCap = StrokeCap.round,
          );
          canvas.drawCircle(micHand + Offset(0, -unit * 0.19), unit * 0.07, Paint()..color = TColors.darkerGrey);
          final leftHand = leftShoulder + Offset(-unit * 0.20, -unit * (0.20 + 0.14 * swing.abs()));
          canvas.drawLine(leftShoulder, leftHand, armPaint);
          break;

        case MascotInstrument.tambourine:
          final tambourineCenter = leftShoulder + Offset(-unit * 0.30, unit * 0.02);
          canvas.drawLine(leftShoulder, tambourineCenter, armPaint);
          canvas.drawCircle(
            tambourineCenter,
            unit * 0.16,
            Paint()
              ..color = TColors.secondary
              ..style = PaintingStyle.stroke
              ..strokeWidth = unit * 0.045,
          );
          canvas.drawCircle(tambourineCenter, unit * 0.16, Paint()..color = TColors.secondary.withOpacity(0.25));
          final rightHand = rightShoulder + Offset(unit * 0.10, -unit * (0.14 + 0.16 * swing.abs()));
          canvas.drawLine(rightShoulder, rightHand, armPaint);
          break;
      }
      return;
    }

    // explorer
    final leftHand = leftShoulder + Offset(-unit * 0.26, -unit * (0.18 + 0.16 * swing.abs()));
    canvas.drawLine(leftShoulder, leftHand, armPaint);

    if (carryingFlag) {
      final rightHand = rightShoulder + Offset(unit * 0.20, -unit * 0.08);
      canvas.drawLine(rightShoulder, rightHand, armPaint);
      final poleTop = rightHand - Offset(0, unit * 0.46);
      canvas.drawLine(
        rightHand,
        poleTop,
        Paint()
          ..color = TColors.textPrimary
          ..strokeWidth = unit * 0.035
          ..strokeCap = StrokeCap.round,
      );
      final miniFlag = Path()
        ..moveTo(poleTop.dx, poleTop.dy)
        ..lineTo(poleTop.dx + unit * 0.26, poleTop.dy + unit * 0.09)
        ..lineTo(poleTop.dx, poleTop.dy + unit * 0.18)
        ..close();
      canvas.drawPath(miniFlag, Paint()..color = Colors.redAccent);
    } else {
      final rightHand = rightShoulder + Offset(unit * 0.26, -unit * (0.18 - 0.16 * swing.abs()));
      canvas.drawLine(rightShoulder, rightHand, armPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.variant != variant ||
      oldDelegate.instrument != instrument ||
      oldDelegate.masked != masked ||
      oldDelegate.carryingFlag != carryingFlag;
}
