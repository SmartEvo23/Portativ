import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

/// Tipuri de mascotă folosite pe hărțile de lecții:
/// - [explorer]: personajul principal, care se plimbă pe hartă și duce steagul.
/// - [musician]: mascotă-companion care ține un instrument și "cântă" în buclă, cu chef.
/// - [dancer]: mascotă-companion care dansează (de obicei în pereche).
enum MascotVariant { explorer, musician, dancer }

/// Instrumentul ținut de o mascotă-muzician.
enum MascotInstrument { tambourine, guitar, bell, microphone, violin }

/// Pentru unele combinații variantă+instrument avem acum ilustrații reale
/// (generate cu Adobe Firefly, cu fundal transparent) - le folosim în locul
/// desenului CustomPainter, ori de câte ori sunt disponibile. Restul
/// combinațiilor rămân desenate ca înainte, până generăm și acele personaje.
///
/// Fiecare personaj poate avea mai multe "cadre" (ipostaze) - de exemplu mâna
/// sus / mâna jos la strună - pe care le alternăm ca un mic flipbook, ca să
/// pară că mișcă efectiv instrumentul, nu doar că îl ține nemișcat. Momentan
/// fiecare listă are un singur cadru (o singură imagine generată); quando
/// adăugăm și cadrele 2/3 pentru fiecare personaj, animația de "cântat" va
/// porni automat, fără alte modificări de cod.
List<String> _mascotImageFrames(MascotVariant variant, MascotInstrument instrument, bool carryingFlag) {
  if (variant == MascotVariant.explorer && !carryingFlag) {
    return const ['assets/images/mascots/mascot_explorer.png'];
  }
  if (variant == MascotVariant.musician && instrument == MascotInstrument.guitar) {
    return const ['assets/images/mascots/mascot_guitar_boy.png'];
  }
  if (variant == MascotVariant.musician && instrument == MascotInstrument.violin) {
    return const ['assets/images/mascots/mascot_violin_girl.png'];
  }
  return const [];
}

/// Un mic personaj de copil, cu proporții tip "chibi" (cap mare, corp mic),
/// ochi mari care clipesc, zâmbet larg și mișcări diferite în funcție de ce
/// face - cântă la un instrument, dansează, sau merge pe hartă cu un steag.
class MascotWidget extends StatefulWidget {
  const MascotWidget({
    super.key,
    this.size = 64,
    this.color = TColors.secondary,
    this.variant = MascotVariant.explorer,
    this.instrument = MascotInstrument.tambourine,
    this.celebrate = false,
    this.carryingFlag = false,
  });

  final double size;

  /// Culoarea hainelor personajului.
  final Color color;
  final MascotVariant variant;
  final MascotInstrument instrument;

  /// Când comută pe `true`, personajul face un salt/rotire scurtă de
  /// sărbătoare (folosit când se termină o lecție sau un tărâm întreg).
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

  /// Cadrele disponibile pentru personajul-imagine curent (poate fi o listă
  /// goală, dacă acest variant+instrument nu are încă o ilustrație reală).
  late final List<String> _frames =
      _mascotImageFrames(widget.variant, widget.instrument, widget.carryingFlag);

  /// Avansează prin cadre în buclă, ca un mic flipbook - vizibil doar când
  /// există mai mult de un cadru pentru personajul curent.
  late final AnimationController _frameController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 260 * math.max(_frames.length, 1)),
  )..repeat();

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
    _frameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDancer = widget.variant == MascotVariant.dancer;
    final isMusician = widget.variant == MascotVariant.musician;
    final hasImage = _frames.isNotEmpty;
    return AnimatedBuilder(
      animation: Listenable.merge([_bobController, _celebrateController, _frameController]),
      builder: (context, child) {
        final t = _bobController.value;
        final bob = isDancer ? math.sin(t * math.pi) * 6 : -t * 5;
        // Un leagăn de "dans" - mai amplu la dansatori și la personajele-
        // imagine care cântă (ca să se observe clar mișcarea, nu doar un
        // tremur discret), moderat la muzicienii desenați, inexistent la
        // explorator.
        final sway = isDancer
            ? math.sin(t * 2 * math.pi) * 0.16
            : isMusician
                ? math.sin(t * 2 * math.pi) * (hasImage ? 0.14 : 0.07)
                : 0.0;
        final spin = widget.celebrate ? _celebrateController.value * 2 * math.pi : 0.0;
        final bump = math.sin(_celebrateController.value * math.pi) * 0.22;
        // Puls mai vizibil, continuu, pentru personajele-imagine care cântă,
        // ca să pară că prind viață și "cântă la instrument" cât timp sunt
        // vizibile pe ecran, nu doar că îl țin nemișcat în mână.
        final playPulse = hasImage && isMusician ? 1 + math.sin(t * 2 * math.pi).abs() * 0.12 : 1.0;
        return Transform.translate(
          offset: Offset(0, bob),
          child: Transform.rotate(
            angle: sway + spin,
            child: Transform.scale(scale: (1 + bump) * playPulse, child: child),
          ),
        );
      },
      child: hasImage
          ? Builder(builder: (context) {
              final frameIndex =
                  (_frameController.value * _frames.length).floor().clamp(0, _frames.length - 1);
              return SizedBox(
                width: widget.size,
                height: widget.size * 1.2,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: 2,
                      child: Container(
                        width: widget.size * 0.55,
                        height: widget.size * 0.09,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    Positioned.fill(child: Image.asset(_frames[frameIndex], fit: BoxFit.contain)),
                  ],
                ),
              );
            })
          : CustomPaint(
              size: Size(widget.size, widget.size * 1.2),
              painter: _MascotPainter(
                color: widget.color,
                variant: widget.variant,
                instrument: widget.instrument,
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
    required this.blink,
    required this.armPhase,
    required this.carryingFlag,
  }) : super(repaint: Listenable.merge([blink, armPhase]));

  final Color color;
  final MascotVariant variant;
  final MascotInstrument instrument;
  final Animation<double> blink;
  final Animation<double> armPhase;
  final bool carryingFlag;

  static const _skin = Color(0xFFFFDCB8);
  static const _hair = Color(0xFF6B4630);

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width;
    final swing = math.sin(armPhase.value * 2 * math.pi);

    // Proporții "chibi": cap mare, corp mic - ca la personajele de copii din
    // jocurile educaționale.
    final headR = unit * 0.40;
    final headCenter = Offset(unit / 2, headR + unit * 0.02);
    final legLength = unit * 0.16;
    final torsoTop = headCenter.dy + headR - unit * 0.14;
    final torsoBottom = size.height - legLength;

    // --- umbră ---
    canvas.drawOval(
      Rect.fromCenter(center: Offset(unit / 2, size.height - 2), width: unit * 0.6, height: unit * 0.10),
      Paint()..color = Colors.black.withOpacity(0.12),
    );

    // --- picioare ---
    final legPaint = Paint()..color = _hair.withOpacity(0.85);
    for (final side in [-1, 1]) {
      final legRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(unit / 2 + side * unit * 0.13, torsoBottom + legLength / 2),
          width: unit * 0.15,
          height: legLength,
        ),
        Radius.circular(unit * 0.07),
      );
      canvas.drawRRect(legRect, legPaint);
    }

    // --- tors (rotunjit, tip body de copil) ---
    final torsoRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(unit / 2 - unit * 0.32, torsoTop, unit / 2 + unit * 0.32, torsoBottom),
      Radius.circular(unit * 0.18),
    );
    canvas.drawRRect(torsoRect, Paint()..color = color);
    canvas.drawRRect(
      torsoRect,
      Paint()
        ..color = Colors.black.withOpacity(0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    // --- brațe + recuzită ---
    final armPaint = Paint()
      ..color = _skin
      ..strokeWidth = unit * 0.075
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final leftShoulder = Offset(unit / 2 - unit * 0.30, torsoTop + unit * 0.06);
    final rightShoulder = Offset(unit / 2 + unit * 0.30, torsoTop + unit * 0.06);
    _paintArmsAndProps(canvas, unit, leftShoulder, rightShoulder, armPaint, swing);

    // --- cap ---
    canvas.drawCircle(headCenter + const Offset(0, 3), headR, Paint()..color = Colors.black.withOpacity(0.10));
    canvas.drawCircle(headCenter, headR, Paint()..color = _skin);

    // urechi mici
    final earPaint = Paint()..color = _skin;
    canvas.drawCircle(headCenter + Offset(-headR * 0.98, headR * 0.05), headR * 0.14, earPaint);
    canvas.drawCircle(headCenter + Offset(headR * 0.98, headR * 0.05), headR * 0.14, earPaint);

    // păr - breton rotunjit, generos, culoare naturală (nu costumul).
    final hairPath = Path()
      ..moveTo(headCenter.dx - headR * 1.02, headCenter.dy - headR * 0.05)
      ..quadraticBezierTo(headCenter.dx - headR * 1.05, headCenter.dy - headR * 1.15, headCenter.dx, headCenter.dy - headR * 1.28)
      ..quadraticBezierTo(headCenter.dx + headR * 1.05, headCenter.dy - headR * 1.15, headCenter.dx + headR * 1.02, headCenter.dy - headR * 0.05)
      ..quadraticBezierTo(headCenter.dx, headCenter.dy - headR * 0.55, headCenter.dx - headR * 1.02, headCenter.dy - headR * 0.05)
      ..close();
    canvas.drawPath(hairPath, Paint()..color = _hair);

    // obrăjori
    final blushPaint = Paint()..color = Colors.pink.withOpacity(0.4);
    canvas.drawCircle(headCenter + Offset(-headR * 0.58, headR * 0.30), headR * 0.16, blushPaint);
    canvas.drawCircle(headCenter + Offset(headR * 0.58, headR * 0.30), headR * 0.16, blushPaint);

    // ochi mari, expresivi (clipesc periodic), cu o sclipire albă.
    final eyeOpen = 1 - blink.value;
    final eyePaint = Paint()..color = TColors.textPrimary;
    for (final dx in [-headR * 0.38, headR * 0.38]) {
      final eyeCenter = headCenter + Offset(dx, headR * 0.06);
      if (eyeOpen > 0.15) {
        final r = headR * 0.19 * eyeOpen.clamp(0.4, 1.0);
        canvas.drawCircle(eyeCenter, r, eyePaint);
        canvas.drawCircle(eyeCenter + Offset(-r * 0.32, -r * 0.32), r * 0.28, Paint()..color = Colors.white);
      } else {
        canvas.drawLine(
          eyeCenter + Offset(-headR * 0.16, 0),
          eyeCenter + Offset(headR * 0.16, 0),
          Paint()
            ..color = TColors.textPrimary
            ..strokeWidth = 2.4
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    // zâmbet larg, vesel.
    final smilePaint = Paint()
      ..color = TColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;
    final smileRect = Rect.fromCenter(center: headCenter + Offset(0, headR * 0.48), width: headR * 0.85, height: headR * 0.7);
    canvas.drawArc(smileRect, 0.2, math.pi - 0.4, false, smilePaint);
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
      final leftHand = leftShoulder + Offset(-unit * 0.26, -unit * (0.26 + 0.10 * swing));
      final rightHand = rightShoulder + Offset(unit * 0.26, -unit * (0.26 - 0.10 * swing));
      canvas.drawLine(leftShoulder, leftHand, armPaint);
      canvas.drawLine(rightShoulder, rightHand, armPaint);
      return;
    }

    if (variant == MascotVariant.musician) {
      switch (instrument) {
        case MascotInstrument.guitar:
          final bodyCenter = Offset(unit / 2, leftShoulder.dy + unit * 0.26);
          canvas.drawLine(leftShoulder, bodyCenter + Offset(-unit * 0.05, -unit * 0.05), armPaint);
          canvas.drawOval(
            Rect.fromCenter(center: bodyCenter, width: unit * 0.30, height: unit * 0.38),
            Paint()..color = const Color(0xFF8D5A2B),
          );
          canvas.drawCircle(bodyCenter, unit * 0.055, Paint()..color = const Color(0xFF5C3A1B));
          final neckTop = bodyCenter + Offset(unit * 0.22, -unit * 0.40);
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
          final triCenter = leftShoulder + Offset(-unit * 0.22, unit * 0.08);
          canvas.drawLine(leftShoulder, triCenter, armPaint);
          final s = unit * 0.15;
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
          final micHand = rightShoulder + Offset(unit * 0.05, -unit * 0.26);
          canvas.drawLine(rightShoulder, micHand, armPaint);
          canvas.drawLine(
            micHand,
            micHand + Offset(0, -unit * 0.12),
            Paint()
              ..color = TColors.darkGrey
              ..strokeWidth = unit * 0.03
              ..strokeCap = StrokeCap.round,
          );
          canvas.drawCircle(micHand + Offset(0, -unit * 0.17), unit * 0.065, Paint()..color = TColors.darkerGrey);
          final leftHand = leftShoulder + Offset(-unit * 0.18, -unit * (0.18 + 0.14 * swing.abs()));
          canvas.drawLine(leftShoulder, leftHand, armPaint);
          break;

        case MascotInstrument.tambourine:
          final tambourineCenter = leftShoulder + Offset(-unit * 0.28, unit * 0.02);
          canvas.drawLine(leftShoulder, tambourineCenter, armPaint);
          canvas.drawCircle(
            tambourineCenter,
            unit * 0.15,
            Paint()
              ..color = TColors.secondary
              ..style = PaintingStyle.stroke
              ..strokeWidth = unit * 0.045,
          );
          canvas.drawCircle(tambourineCenter, unit * 0.15, Paint()..color = TColors.secondary.withOpacity(0.25));
          final rightHand = rightShoulder + Offset(unit * 0.10, -unit * (0.12 + 0.16 * swing.abs()));
          canvas.drawLine(rightShoulder, rightHand, armPaint);
          break;

        case MascotInstrument.violin:
          // Folosit doar ca rezervă (înainte ca ilustrația reală să fie
          // disponibilă pentru o anumită culoare/context) - vioara ținută
          // sub bărbie, cu arcușul mișcându-se odată cu brațul drept.
          final violinCenter = leftShoulder + Offset(-unit * 0.02, unit * 0.16);
          canvas.drawLine(leftShoulder, violinCenter + Offset(0, -unit * 0.10), armPaint);
          canvas.drawOval(
            Rect.fromCenter(center: violinCenter, width: unit * 0.16, height: unit * 0.26),
            Paint()..color = const Color(0xFF8D5A2B),
          );
          final bowEnd = rightShoulder + Offset(unit * 0.02, -unit * (0.02 + 0.14 * swing.abs()));
          canvas.drawLine(rightShoulder, bowEnd, armPaint);
          break;
      }
      return;
    }

    // explorer
    final leftHand = leftShoulder + Offset(-unit * 0.24, -unit * (0.16 + 0.16 * swing.abs()));
    canvas.drawLine(leftShoulder, leftHand, armPaint);

    if (carryingFlag) {
      final rightHand = rightShoulder + Offset(unit * 0.18, -unit * 0.06);
      canvas.drawLine(rightShoulder, rightHand, armPaint);
      final poleTop = rightHand - Offset(0, unit * 0.42);
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
        ..lineTo(poleTop.dx + unit * 0.24, poleTop.dy + unit * 0.08)
        ..lineTo(poleTop.dx, poleTop.dy + unit * 0.16)
        ..close();
      canvas.drawPath(miniFlag, Paint()..color = Colors.redAccent);
    } else {
      final rightHand = rightShoulder + Offset(unit * 0.24, -unit * (0.16 - 0.16 * swing.abs()));
      canvas.drawLine(rightShoulder, rightHand, armPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.variant != variant ||
      oldDelegate.instrument != instrument ||
      oldDelegate.carryingFlag != carryingFlag;
}
