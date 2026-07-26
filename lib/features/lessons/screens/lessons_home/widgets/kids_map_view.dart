import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../controllers/progress_controller.dart';
import '../../../data/lessons_data.dart';
import '../../../models/lesson_level.dart';
import '../../../models/lesson_model.dart';
import '../../../utils/lesson_unlock.dart';
import '../../lesson_detail/lesson_detail_screen.dart';

/// Harta de lecții pentru "Copii": o cărare colorată și șerpuită, cu opriri
/// (lecțiile), deblocate pe rând, în stilul hărților din jocurile de tip
/// Candy Crush - dar cu temă muzicală.
class KidsMapView extends StatefulWidget {
  const KidsMapView({super.key});

  @override
  State<KidsMapView> createState() => _KidsMapViewState();
}

class _KidsMapViewState extends State<KidsMapView> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat(reverse: true);

  static const double _nodeSpacing = 170;
  static const double _topPadding = 70;
  static const double _bottomPadding = 120;
  static const double _nodeDiameter = 80;
  static const double _labelWidth = 130;

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessons = LessonsData.byLevel(LessonLevel.copii);
    final progressController = Get.put(ProgressController());
    final mapHeight = _topPadding + lessons.length * _nodeSpacing + _bottomPadding;

    return Obx(() {
      final progress = progressController.progress.value.of(LessonLevel.copii);
      final nextIndex = lessons.indexWhere((l) => !progress.completedLessonIds.contains(l.id));

      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFBFEAF5), Color(0xFFE3F8E1)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final positions = <Offset>[
              for (var i = 0; i < lessons.length; i++)
                Offset((i.isEven ? 0.30 : 0.70) * width, _topPadding + i * _nodeSpacing),
            ];

            return SingleChildScrollView(
              child: SizedBox(
                width: width,
                height: mapHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(child: CustomPaint(painter: _CloudsPainter())),
                    CustomPaint(size: Size(width, mapHeight), painter: _PathPainter(positions: positions)),
                    for (var i = 0; i < lessons.length; i++)
                      Positioned(
                        left: positions[i].dx - _labelWidth / 2,
                        top: positions[i].dy - _nodeDiameter / 2,
                        width: _labelWidth,
                        child: _MapNode(
                          lesson: lessons[i],
                          index: i,
                          unlocked: isLessonUnlocked(lessons, i, progress),
                          stars: starsForLesson(lessons[i].id, progress),
                          isNext: i == nextIndex,
                          pulseController: _pulseController,
                          diameter: _nodeDiameter,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class _MapNode extends StatelessWidget {
  const _MapNode({
    required this.lesson,
    required this.index,
    required this.unlocked,
    required this.stars,
    required this.isNext,
    required this.pulseController,
    required this.diameter,
  });

  final LessonModel lesson;
  final int index;
  final bool unlocked;
  final int stars;
  final bool isNext;
  final AnimationController pulseController;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final passed = stars > 0;
    final Color fillColor = !unlocked
        ? TColors.darkGrey.withOpacity(0.55)
        : passed
            ? TColors.success
            : TColors.primary;

    Widget circle = Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      alignment: Alignment.center,
      child: unlocked
          ? Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold))
          : const Icon(Icons.lock_rounded, color: Colors.white, size: 28),
    );

    if (isNext && unlocked) {
      circle = AnimatedBuilder(
        animation: pulseController,
        builder: (context, child) => Transform.scale(scale: 1.0 + pulseController.value * 0.08, child: child),
        child: circle,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: unlocked
              ? () => Get.to(() => LessonDetailScreen(lessonId: lesson.id))
              : () => TLoaders.warningSnackBar(title: 'Lecție blocată', message: 'Termină mai întâi lecția anterioară.'),
          child: circle,
        ),
        const SizedBox(height: 6),
        Text(
          lesson.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall!.apply(color: TColors.textPrimary),
        ),
        if (unlocked) ...[
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              3,
              (i) => Icon(
                i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                size: 16,
                color: i < stars ? Colors.amber : Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Desenează cărarea șerpuită, punctată, care leagă lecțiile între ele.
class _PathPainter extends CustomPainter {
  _PathPainter({required this.positions});

  final List<Offset> positions;

  @override
  void paint(Canvas canvas, Size size) {
    if (positions.length < 2) return;

    final path = Path()..moveTo(positions.first.dx, positions.first.dy);
    for (var i = 1; i < positions.length; i++) {
      final p0 = positions[i - 1];
      final p1 = positions[i];
      final midY = (p0.dy + p1.dy) / 2;
      path.cubicTo(p0.dx, midY, p1.dx, midY, p1.dx, p1.dy);
    }

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(_dashPath(path), paint);
  }

  Path _dashPath(Path source, {double dashLength = 16, double gapLength = 12}) {
    final dashed = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      while (distance < metric.length) {
        final length = draw ? dashLength : gapLength;
        final next = math.min(distance + length, metric.length);
        if (draw) dashed.addPath(metric.extractPath(distance, next), Offset.zero);
        distance = next;
        draw = !draw;
      }
    }
    return dashed;
  }

  @override
  bool shouldRepaint(covariant _PathPainter oldDelegate) => oldDelegate.positions != positions;
}

/// Norișori decorativi, desenați simplu (fără imagini externe).
class _CloudsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.5);
    final centers = [
      Offset(size.width * 0.18, 30),
      Offset(size.width * 0.82, 150),
      Offset(size.width * 0.15, 400),
      Offset(size.width * 0.85, 560),
      Offset(size.width * 0.20, 740),
      Offset(size.width * 0.80, 900),
    ];
    for (final c in centers) {
      if (c.dy > size.height) continue;
      canvas.drawCircle(c, 24, paint);
      canvas.drawCircle(c + const Offset(20, 6), 16, paint);
      canvas.drawCircle(c + const Offset(-20, 6), 16, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CloudsPainter oldDelegate) => false;
}
