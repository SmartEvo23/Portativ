import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/progress_controller.dart';
import '../../../data/lessons_data.dart';
import '../../../models/lesson_level.dart';
import '../../../models/lesson_model.dart';
import '../../lesson_detail/lesson_detail_screen.dart';

/// Ecranul "Hobby": lecțiile sunt așezate în cerc, în jurul unui nucleu
/// armonic - fără blocaje, gândit pentru recapitulare liberă, în orice ordine.
class HobbyWheelView extends StatefulWidget {
  const HobbyWheelView({super.key});

  @override
  State<HobbyWheelView> createState() => _HobbyWheelViewState();
}

class _HobbyWheelViewState extends State<HobbyWheelView> with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 50))..repeat();

  static const double _wheelSize = 360;
  static const double _radius = 112;
  static const double _nodeSize = 86;

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessons = LessonsData.byLevel(LessonLevel.hobby);
    final progressController = Get.put(ProgressController());

    return Obx(() {
      final progress = progressController.progress.value.of(LessonLevel.hobby);

      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.4,
            colors: [Color(0xFF2E2360), Color(0xFF16123A)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
          child: Column(
            children: [
              SizedBox(
                width: _wheelSize,
                height: _wheelSize,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) =>
                          Transform.rotate(angle: _rotationController.value * 2 * math.pi, child: child),
                      child: CustomPaint(size: const Size(_wheelSize, _wheelSize), painter: _RingsPainter()),
                    ),
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(colors: [TColors.secondary, TColors.primary]),
                        boxShadow: [BoxShadow(color: TColors.primary.withOpacity(0.55), blurRadius: 26)],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 38),
                    ),
                    for (var i = 0; i < lessons.length; i++)
                      _WheelNode(
                        angle: (2 * math.pi * i / lessons.length) - (math.pi / 2),
                        lesson: lessons[i],
                        passed: progress.isLessonPassed(lessons[i].id),
                        radius: _radius,
                        size: _nodeSize,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                child: Text(
                  'Recapitulare liberă - alege orice lecție, în orice ordine.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white70),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      );
    });
  }
}

class _WheelNode extends StatelessWidget {
  const _WheelNode({required this.angle, required this.lesson, required this.passed, required this.radius, required this.size});

  final double angle;
  final LessonModel lesson;
  final bool passed;
  final double radius;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dx = radius * math.cos(angle);
    final dy = radius * math.sin(angle);

    return Transform.translate(
      offset: Offset(dx, dy),
      child: GestureDetector(
        onTap: () => Get.to(() => LessonDetailScreen(lessonId: lesson.id)),
        child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: passed ? TColors.success : Colors.white,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12)],
          ),
          alignment: Alignment.center,
          child: Text(
            lesson.title,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall!.apply(color: passed ? Colors.white : TColors.textPrimary),
          ),
        ),
      ),
    );
  }
}

/// Inele concentrice decorative, ca niște unde sonore în jurul nucleului.
class _RingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radii = [70.0, 105.0, 140.0, 165.0];
    for (var i = 0; i < radii.length; i++) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = i.isEven ? 1.5 : 1
        ..color = Colors.white.withOpacity(0.10 + (i * 0.02));
      canvas.drawCircle(center, radii[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) => false;
}
