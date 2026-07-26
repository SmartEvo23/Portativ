import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/progress_controller.dart';
import '../../data/lessons_data.dart';
import '../../models/exercise_model.dart';
import '../../models/lesson_level.dart';
import '../lesson_detail/widgets/exercise_quiz.dart';

/// Ecranul "Exerciții": antrenament rapid cu întrebări amestecate din toate lecțiile.
class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  List<ExerciseModel>? _round;
  List<LessonLevel>? _roundLevels;
  late final ProgressController _progress = Get.put(ProgressController());

  void _startRound() {
    final pairs = LessonsData.all.expand((lesson) => lesson.exercises.map((e) => (level: lesson.level, exercise: e))).toList()
      ..shuffle(Random());
    final taken = pairs.take(10).toList();
    setState(() {
      _round = taken.map((p) => p.exercise).toList();
      _roundLevels = taken.map((p) => p.level).toList();
    });
  }

  void _onFinished(List<bool> correctness) {
    final levels = _roundLevels ?? const <LessonLevel>[];
    final tally = <LessonLevel, int>{};
    for (var i = 0; i < correctness.length && i < levels.length; i++) {
      if (correctness[i]) tally[levels[i]] = (tally[levels[i]] ?? 0) + 1;
    }
    tally.forEach((level, count) => _progress.recordPracticeResult(level, count));
    setState(() {
      _round = null;
      _roundLevels = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final round = _round;
    return Scaffold(
      appBar: TAppBar(title: const Text('Exerciții')),
      body: SafeArea(
        child: round == null ? _StartPractice(onStart: _startRound) : ExerciseQuiz(exercises: round, onFinished: _onFinished),
      ),
    );
  }
}

class _StartPractice extends StatelessWidget {
  const _StartPractice({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.flash_1, size: 64, color: TColors.primary),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text('Antrenament rapid', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: TSizes.sm),
          Text(
            'Zece întrebări amestecate, din toate lecțiile - un mod distractiv de a-ți verifica cunoștințele.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(backgroundColor: TColors.primary, foregroundColor: TColors.white),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: TSizes.lg, vertical: TSizes.sm),
              child: Text('Începe'),
            ),
          ),
        ],
      ),
    );
  }
}
