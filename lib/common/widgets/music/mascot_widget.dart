import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

/// Tipuri de mascotă folosite pe hărțile de lecții:
/// - [explorer]: personajul principal, care se plimbă pe hartă și duce steagul.
/// - [musician]: mascotă-companion cu proporții și accesorii de copil, care
///   ține un instrument și "cântă" în buclă, cu chef.
/// - [dancer]: mascotă-companion mascată, care dansează (de obicei în pereche).
enum MascotVariant { explorer, musician, dancer }

/// Instrumentul ținut de o mascotă-muzician.
enum MascotInstrument {
  tambourine,
  guitar,
  bell,
  microphone,
  violin,
  drum,
  trumpet,
  piano,
  flute,
}

/// Un mic personaj, prietenos și animat: cap, tors, brațe, picioare, ochi
/// care clipesc, zâmbet larg. Poate purta o mască de bal mascat și poate
/// ține/cânta la un instrument - folosit ca ghid (exploratorul) sau ca
/// "locuitor" companion al fiecărui tărâm din hărțile de lecții.
///
/// Mascotele-muzicieni ([MascotVariant.musician]) au proporții de copil (cap
/// mai mare, picioare mai scurte, salopetă cu bretele) și tot desenul e umbrit
/// cu gradient (cap, tors, picioare, instrumente) ca să dea senzația de volum
/// 3D, deși rămâne un desen vectorial (fără modele 3D reale).
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

    // Mascotele-muzicieni au proporții și accesorii de copil: cap mai mare,
    // picioare mai scurte, salopetă cu bretele și ghetuțe albe.
    final isChild = variant == MascotVariant.musician;

    final headR = unit * (isChild ? 0.34 : 0.30);
    final headCenter = Offset(unit / 2, headR + unit * 0.06);
    final legLength = unit * (isChild ? 0.28 : 0.34);
    final torsoTop = headCenter.dy + headR - unit * 0.05;
    final torsoBottom = size.height - legLength;

    // --- umbră ---
    canvas.drawOval(
      Rect.fromCenter(center: Offset(unit / 2, size.height - 2), width: unit * 0.6, height: unit * 0.12),
      Paint()..color = Colors.black.withOpacity(0.12),
    );

    // --- picioare (gradient vertical, pentru senzație de volum) ---
    for (final side in [-1, 1]) {
      final legRect = Rect.fromCenter(
        center: Offset(unit / 2 + side * unit * 0.14, torsoBottom + legLength / 2),
        width: unit * 0.14,
        height: legLength,
      );
      final legPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            TColors.textPrimary.withOpacity(0.62),
            TColors.textPrimary.withOpacity(0.86),
          ],
        ).createShader(legRect);
      canvas.drawRRect(RRect.fromRectAndRadius(legRect, Radius.circular(unit * 0.06)), legPaint);

      if (isChild) {
        // ghetuță albă, rotunjită - accent jucăuș de copil.
        final shoeRect = Rect.fromCenter(
          center: Offset(legRect.center.dx, torsoBottom + legLength - unit * 0.03),
          width: unit * 0.17,
          height: unit * 0.11,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(shoeRect, Radius.circular(unit * 0.05)),
          Paint()..color = Colors.white.withOpacity(0.92),
        );
      }
    }

    // --- tors (tunică/salopetă, cu gradient diagonal pentru volum) ---
    final torsoPath = Path()
      ..moveTo(unit / 2 - unit * 0.30, torsoTop)
      ..lineTo(unit / 2 + unit * 0.30, torsoTop)
      ..lineTo(unit / 2 + unit * 0.38, torsoBottom)
      ..lineTo(unit / 2 - unit * 0.38, torsoBottom)
      ..close();
    final torsoRect = torsoPath.getBounds();
    canvas.drawPath(
      torsoPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, 0.5, 1],
          colors: [
            Color.lerp(color, Colors.white, 0.35)!,
            color,
            Color.lerp(color, Colors.black, 0.18)!,
          ],
        ).createShader(torsoRect),
    );
    canvas.drawPath(
      torsoPath,
      Paint()
        ..color = Colors.black.withOpacity(0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    if (isChild) {
      // bretele de salopetă, peste tunică - semnătura vizuală de "copil".
      final strapColor = Color.lerp(color, Colors.black, 0.30)!;
      final strapPaint = Paint()
        ..color = strapColor
        ..strokeWidth = unit * 0.045
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(unit / 2 - unit * 0.16, torsoTop + unit * 0.015),
        Offset(unit / 2 - unit * 0.09, torsoTop + unit * 0.20),
        strapPaint,
      );
      canvas.drawLine(
        Offset(unit / 2 + unit * 0.16, torsoTop + unit * 0.015),
        Offset(unit / 2 + unit * 0.09, torsoTop + unit * 0.20),
        strapPaint,
      );
      for (final dx in [-0.16, 0.16]) {
        canvas.drawCircle(
          Offset(unit / 2 + unit * dx, torsoTop + unit * 0.015),
          unit * 0.02,
          Paint()..color = Colors.white.withOpacity(0.85),
        );
      }
    }

    // --- brațe + recuzită (desenate înainte de cap, ca să iasă capul deasupra) ---
    final armPaint = Paint()
      ..color = TColors.textPrimary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final leftShoulder = Offset(unit / 2 - unit * 0.30, torsoTop + unit * 0.04);
    final rightShoulder = Offset(unit / 2 + unit * 0.30, torsoTop + unit * 0.04);
    _paintArmsAndProps(canvas, unit, leftShoulder, rightShoulder, headCenter, torsoBottom, armPaint, swing);

    // --- cap (gradient radial, ca o sferă cu luciu - efect 3D) ---
    canvas.drawCircle(headCenter + const Offset(0, 3), headR, Paint()..color = Colors.black.withOpacity(0.12));
    canvas.drawCircle(
      headCenter,
      headR,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.45),
          radius: 1.15,
          stops: const [0, 0.55, 1],
          colors: [
            Color.lerp(_skin, Colors.white, 0.55)!,
            _skin,
            Color.lerp(_skin, Colors.black, 0.12)!,
          ],
        ).createShader(Rect.fromCircle(center: headCenter, radius: headR)),
    );

    // păr/beretă simplă, în culoarea costumului, pentru coerență vizuală.
    final hairPath = Path()
      ..moveTo(headCenter.dx - headR, headCenter.dy - headR * 0.05)
      ..quadraticBezierTo(headCenter.dx, headCenter.dy - headR * 1.5, headCenter.dx + headR, headCenter.dy - headR * 0.05)
      ..quadraticBezierTo(headCenter.dx, headCenter.dy - headR * 0.72, headCenter.dx - headR, headCenter.dy - headR * 0.05)
      ..close();
    canvas.drawPath(
      hairPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.95), Color.lerp(color, Colors.black, 0.2)!.withOpacity(0.95)],
        ).createShader(hairPath.getBounds()),
    );

    // obrăjori
    final blushPaint = Paint()..color = Colors.pink.withOpacity(0.35);
    canvas.drawCircle(headCenter + Offset(-headR * 0.5, headR * 0.22), headR * 0.15, blushPaint);
    canvas.drawCircle(headCenter + Offset(headR * 0.5, headR * 0.22), headR * 0.15, blushPaint);

    // ochi (clipesc periodic) - puțin mai mari la personajele-copil.
    final eyeScale = isChild ? 1.15 : 1.0;
    final eyeOpen = 1 - blink.value;
    final eyePaint = Paint()..color = TColors.textPrimary;
    for (final dx in [-headR * 0.4, headR * 0.4]) {
      final eyeCenter = headCenter + Offset(dx, 0);
      if (eyeOpen > 0.15) {
        canvas.drawCircle(eyeCenter, headR * 0.13 * eyeScale * eyeOpen.clamp(0.4, 1.0), eyePaint);
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
    Offset headCenter,
    double torsoBottom,
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
          final bodyRect = Rect.fromCenter(center: bodyCenter, width: unit * 0.30, height: unit * 0.40);
          canvas.drawLine(leftShoulder, bodyCenter + Offset(-unit * 0.05, -unit * 0.05), armPaint);
          canvas.drawOval(
            bodyRect,
            Paint()
              ..shader = LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFFA9713D), const Color(0xFF6E4020)],
              ).createShader(bodyRect),
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
              ..shader = LinearGradient(
                colors: [const Color(0xFFECEFF1), const Color(0xFF90A4AE)],
              ).createShader(tri.getBounds())
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
          final micCenter = micHand + Offset(0, -unit * 0.19);
          canvas.drawCircle(
            micCenter,
            unit * 0.07,
            Paint()
              ..shader = RadialGradient(
                center: const Alignment(-0.4, -0.4),
                colors: [const Color(0xFF616161), TColors.darkerGrey],
              ).createShader(Rect.fromCircle(center: micCenter, radius: unit * 0.07)),
          );
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
              ..shader = SweepGradient(
                colors: [TColors.secondary, Color.lerp(TColors.secondary, Colors.white, 0.5)!, TColors.secondary],
              ).createShader(Rect.fromCircle(center: tambourineCenter, radius: unit * 0.16))
              ..style = PaintingStyle.stroke
              ..strokeWidth = unit * 0.045,
          );
          canvas.drawCircle(tambourineCenter, unit * 0.16, Paint()..color = TColors.secondary.withOpacity(0.25));
          final rightHand = rightShoulder + Offset(unit * 0.10, -unit * (0.14 + 0.16 * swing.abs()));
          canvas.drawLine(rightShoulder, rightHand, armPaint);
          break;

        case MascotInstrument.violin:
          final bodyCenter = leftShoulder + Offset(-unit * 0.08, unit * 0.16);
          final bodyRect = Rect.fromCenter(center: bodyCenter, width: unit * 0.19, height: unit * 0.30);
          canvas.drawLine(leftShoulder, bodyCenter + Offset(0, -unit * 0.10), armPaint);
          canvas.drawOval(
            bodyRect,
            Paint()
              ..shader = LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFFC17A3E), const Color(0xFF6E4020)],
              ).createShader(bodyRect),
          );
          final neckTop = bodyCenter + Offset(unit * 0.02, -unit * 0.34);
          canvas.drawLine(
            bodyCenter + Offset(0, -unit * 0.14),
            neckTop,
            Paint()
              ..color = const Color(0xFF4A2A12)
              ..strokeWidth = unit * 0.032
              ..strokeCap = StrokeCap.round,
          );
          // arcuș, ținut în mâna dreaptă și mișcat ușor peste corzi.
          final bowPivot = rightShoulder + Offset(unit * 0.02, -unit * 0.06);
          final bowEnd = bodyCenter + Offset(unit * 0.14 * swing, unit * 0.02);
          canvas.drawLine(rightShoulder, bowPivot, armPaint);
          canvas.drawLine(
            bowPivot,
            bowEnd,
            Paint()
              ..color = const Color(0xFFD7B98E)
              ..strokeWidth = unit * 0.026
              ..strokeCap = StrokeCap.round,
          );
          break;

        case MascotInstrument.drum:
          final drumCenter = leftShoulder + Offset(-unit * 0.22, unit * 0.18);
          final drumRect = Rect.fromCenter(center: drumCenter, width: unit * 0.30, height: unit * 0.22);
          canvas.drawLine(leftShoulder, drumCenter, armPaint);
          canvas.drawOval(
            drumRect,
            Paint()
              ..shader = LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [const Color(0xFFE85D5D), const Color(0xFFA82F2F)],
              ).createShader(drumRect),
          );
          canvas.drawOval(
            Rect.fromCenter(center: drumCenter, width: unit * 0.26, height: unit * 0.10),
            Paint()..color = const Color(0xFFF4E3C1),
          );
          final stickEnd = drumCenter + Offset(unit * 0.04, -unit * (0.12 + 0.12 * swing.abs()));
          canvas.drawLine(rightShoulder, stickEnd, armPaint);
          canvas.drawLine(
            stickEnd,
            stickEnd + Offset(unit * 0.03, -unit * 0.09),
            Paint()
              ..color = const Color(0xFF8D5A2B)
              ..strokeWidth = unit * 0.028
              ..strokeCap = StrokeCap.round,
          );
          break;

        case MascotInstrument.trumpet:
          final mouth = Offset(headCenter.dx + unit * 0.02, headCenter.dy + unit * 0.30);
          final bellCenter = mouth + Offset(unit * 0.26, unit * 0.02);
          final hornPath = Path()
            ..moveTo(mouth.dx, mouth.dy - unit * 0.035)
            ..lineTo(bellCenter.dx - unit * 0.02, bellCenter.dy - unit * 0.11)
            ..lineTo(bellCenter.dx + unit * 0.07, bellCenter.dy)
            ..lineTo(bellCenter.dx - unit * 0.02, bellCenter.dy + unit * 0.11)
            ..lineTo(mouth.dx, mouth.dy + unit * 0.035)
            ..close();
          canvas.drawPath(
            hornPath,
            Paint()
              ..shader = LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFFFFE07A), const Color(0xFFC79A2E)],
              ).createShader(hornPath.getBounds()),
          );
          canvas.drawLine(leftShoulder, mouth + Offset(-unit * 0.05, unit * 0.02), armPaint);
          canvas.drawLine(rightShoulder, mouth + Offset(unit * 0.09, -unit * 0.02), armPaint);
          for (final dx in [0.05, 0.10, 0.15]) {
            canvas.drawCircle(
              Offset(mouth.dx + unit * dx, mouth.dy - unit * 0.05),
              unit * 0.014,
              Paint()..color = const Color(0xFF8A6A1E),
            );
          }
          break;

        case MascotInstrument.piano:
          final kbRect = Rect.fromCenter(center: Offset(unit / 2, torsoBottom - unit * 0.01), width: unit * 0.62, height: unit * 0.16);
          canvas.drawRRect(
            RRect.fromRectAndRadius(kbRect, Radius.circular(unit * 0.03)),
            Paint()
              ..shader = LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [const Color(0xFF3A3A3A), const Color(0xFF1B1B1B)],
              ).createShader(kbRect),
          );
          final whiteKeyW = kbRect.width / 7;
          for (var i = 0; i < 7; i++) {
            final kx = kbRect.left + i * whiteKeyW;
            canvas.drawRect(Rect.fromLTWH(kx + 1, kbRect.top + 1, whiteKeyW - 2, kbRect.height - 2), Paint()..color = Colors.white);
          }
          for (var i = 0; i < 6; i++) {
            if (i == 2) continue; // fără clapă neagră între mi și fa.
            final kx = kbRect.left + (i + 1) * whiteKeyW;
            canvas.drawRect(
              Rect.fromCenter(center: Offset(kx, kbRect.top + kbRect.height * 0.32), width: whiteKeyW * 0.5, height: kbRect.height * 0.6),
              Paint()..color = Colors.black,
            );
          }
          final leftHand = Offset(unit / 2 - unit * 0.14, kbRect.top - unit * 0.015 + unit * 0.02 * swing.abs());
          final rightHand = Offset(unit / 2 + unit * 0.14, kbRect.top - unit * 0.015 + unit * 0.02 * (1 - swing.abs()));
          canvas.drawLine(leftShoulder, leftHand, armPaint);
          canvas.drawLine(rightShoulder, rightHand, armPaint);
          break;

        case MascotInstrument.flute:
          final mouth = Offset(headCenter.dx, headCenter.dy + unit * 0.32);
          final fluteEnd = mouth + Offset(unit * 0.34, -unit * 0.02);
          canvas.drawLine(
            mouth,
            fluteEnd,
            Paint()
              ..color = const Color(0xFFCFD8DC)
              ..strokeWidth = unit * 0.045
              ..strokeCap = StrokeCap.round,
          );
          for (final t in [0.35, 0.55, 0.75]) {
            canvas.drawCircle(Offset.lerp(mouth, fluteEnd, t)!, unit * 0.015, Paint()..color = const Color(0xFF78909C));
          }
          canvas.drawLine(leftShoulder, mouth + Offset(-unit * 0.05, unit * 0.02), armPaint);
          canvas.drawLine(rightShoulder, Offset.lerp(mouth, fluteEnd, 0.6)!, armPaint);
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
