import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../data/lessons_data.dart';
import '../../models/exercise_model.dart';
import '../lesson_detail/widgets/exercise_quiz.dart';

/// Ecranul "Exerciții": antrenament rapid cu întrebări amestecate din toate lecțiile.
class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  List<ExerciseModel>? _round;

  void _startRound() {
    final all = LessonsData.all.expand((lesson) => lesson.exercises).toList()..shuffle(Random());
    setState(() => _round = all.take(10).toList());
  }

  @override
  Widget build(BuildContext context) {
    final round = _round;
    return Scaffold(
      appBar: TAppBar(title: const Text('Exerciții')),
      body: SafeArea(
        child: round == null
            ? _StartPractice(onStart: _startRound)
            : ExerciseQuiz(exercises: round, onFinished: () => setState(() => _round = null)),
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
