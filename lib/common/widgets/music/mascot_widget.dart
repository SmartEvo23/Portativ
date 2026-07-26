import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

/// Tipuri de mascotă folosite pe hărțile de lecții:
/// - [explorer]: personajul principal, care se plimbă pe hartă și duce steagul.
/// - [musician]: mascotă-companion care ține un instrument și "cântă" în buclă.
/// - [dancer]: mascotă-companion care se leagănă/dansează în buclă (ex. vals).
enum MascotVariant { explorer, musician, dancer }

/// Mascota aplicației: o notă muzicală prietenoasă, cu ochi și zâmbet,
/// care clipește, salută din mână și se leagănă ușor - folosită ca ghid
/// vizual (și, în variantele companion, ca "locuitor" al fiecărui tărâm)
/// în hărțile de lecții.
class MascotWidget extends StatefulWidget {
  const MascotWidget({
    super.key,
    this.size = 64,
    this.color = TColors.secondary,
    this.variant = MascotVariant.explorer,
    this.celebrate = false,
    this.carryingFlag = false,
  });

  final double size;
  final Color color;
  final MascotVariant variant;

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
    duration: Duration(milliseconds: widget.variant == MascotVariant.dancer ? 750 : 1400),
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
        final bob = isDancer ? math.sin(t * math.pi) * 5 : -t * 6;
        final sway = isDancer ? math.sin(t * 2 * math.pi) * 0.14 : 0.0;
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
    required this.blink,
    required this.armPhase,
    required this.carryingFlag,
  }) : super(repaint: Listenable.merge([blink, armPhase]));

  final Color color;
  final MascotVariant variant;
  final Animation<double> blink;
  final Animation<double> armPhase;
  final bool carryingFlag;

  @override
  void paint(Canvas canvas, Size size) {
    final bodyRadius = size.width / 2;
    final center = Offset(size.width / 2, size.height - bodyRadius);
    final swing = math.sin(armPhase.value * 2 * math.pi);

    // Codiță de notă (ca o antenă), cu steguleț decorativ (parte din "corp").
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

    // Umbră + corp (cap rotund).
    final shadowPaint = Paint()..color = Colors.black.withOpacity(0.15);
    canvas.drawCircle(center + const Offset(0, 4), bodyRadius, shadowPaint);
    final bodyPaint = Paint()..color = color;
    canvas.drawCircle(center, bodyRadius, bodyPaint);

    // --- Brațe ---
    final armPaint = Paint()
      ..color = TColors.textPrimary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final leftShoulder = center + Offset(-bodyRadius * 0.82, bodyRadius * 0.15);
    final rightShoulder = center + Offset(bodyRadius * 0.82, bodyRadius * 0.15);

    if (variant == MascotVariant.dancer) {
      // Brațe ridicate, poziție de dans - se leagănă opus una față de alta.
      final leftHand = leftShoulder + Offset(-bodyRadius * 0.55, -bodyRadius * (0.55 + 0.1 * swing));
      final rightHand = rightShoulder + Offset(bodyRadius * 0.55, -bodyRadius * (0.55 - 0.1 * swing));
      canvas.drawLine(leftShoulder, leftHand, armPaint);
      canvas.drawLine(rightShoulder, rightHand, armPaint);
    } else if (variant == MascotVariant.musician) {
      // Brațul stâng ține o mică tamburină, dreptul o "bate" ritmic.
      final tambourineCenter = center + Offset(-bodyRadius * 1.05, bodyRadius * 0.05);
      canvas.drawLine(leftShoulder, tambourineCenter, armPaint);
      final tambPaint = Paint()
        ..color = TColors.secondary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(tambourineCenter, bodyRadius * 0.32, tambPaint);
      canvas.drawCircle(tambourineCenter, bodyRadius * 0.32, Paint()..color = TColors.secondary.withOpacity(0.25));
      final rightHand = rightShoulder + Offset(bodyRadius * 0.15, -bodyRadius * (0.25 + 0.3 * swing.abs()));
      canvas.drawLine(rightShoulder, rightHand, armPaint);
    } else {
      // Explorer: brațul stâng flutură a salut, dreptul duce eventual un steguleț.
      final leftHand = leftShoulder + Offset(-bodyRadius * 0.5, -bodyRadius * (0.35 + 0.3 * swing.abs()));
      canvas.drawLine(leftShoulder, leftHand, armPaint);

      if (carryingFlag) {
        final rightHand = rightShoulder + Offset(bodyRadius * 0.35, -bodyRadius * 0.15);
        canvas.drawLine(rightShoulder, rightHand, armPaint);
        final poleTop = rightHand - Offset(0, bodyRadius * 0.9);
        canvas.drawLine(rightHand, poleTop, stemPaint);
        final miniFlag = Path()
          ..moveTo(poleTop.dx, poleTop.dy)
          ..lineTo(poleTop.dx + bodyRadius * 0.55, poleTop.dy + bodyRadius * 0.18)
          ..lineTo(poleTop.dx, poleTop.dy + bodyRadius * 0.36)
          ..close();
        canvas.drawPath(miniFlag, Paint()..color = Colors.redAccent);
      } else {
        final rightHand = rightShoulder + Offset(bodyRadius * 0.5, -bodyRadius * (0.35 - 0.3 * swing.abs()));
        canvas.drawLine(rightShoulder, rightHand, armPaint);
      }
    }

    // Obrăjori.
    final blushPaint = Paint()..color = Colors.pink.withOpacity(0.35);
    canvas.drawCircle(center + Offset(-bodyRadius * 0.55, bodyRadius * 0.18), bodyRadius * 0.14, blushPaint);
    canvas.drawCircle(center + Offset(bodyRadius * 0.55, bodyRadius * 0.18), bodyRadius * 0.14, blushPaint);

    // Ochi (clipesc periodic).
    final eyeOpen = 1 - blink.value;
    final eyePaint = Paint()..color = TColors.textPrimary;
    for (final dx in [-bodyRadius * 0.35, bodyRadius * 0.35]) {
      final eyeCenter = center + Offset(dx, -bodyRadius * 0.1);
      if (eyeOpen > 0.15) {
        canvas.drawCircle(eyeCenter, bodyRadius * 0.12 * eyeOpen.clamp(0.4, 1.0), eyePaint);
      } else {
        // pleoapă închisă - o linie curbă
        final lidPaint = Paint()
          ..color = TColors.textPrimary
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
          eyeCenter + Offset(-bodyRadius * 0.1, 0),
          eyeCenter + Offset(bodyRadius * 0.1, 0),
          lidPaint,
        );
      }
    }

    // Zâmbet larg, vesel (mai generos decât un zâmbet simplu).
    final smilePaint = Paint()
      ..color = TColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;
    final smileRect = Rect.fromCenter(
      center: center + Offset(0, bodyRadius * 0.16),
      width: bodyRadius * 0.9,
      height: bodyRadius * 0.75,
    );
    canvas.drawArc(smileRect, 0.15, math.pi - 0.3, false, smilePaint);
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.variant != variant || oldDelegate.carryingFlag != carryingFlag;
}
