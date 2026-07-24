import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/music/staff_widget.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../data/lessons_data.dart';
import '../../models/exercise_model.dart';
import '../../models/lesson_model.dart';
import 'widgets/exercise_quiz.dart';

/// Ecranul unei lecții: explicații, urmate de exercițiile ei.
class LessonDetailScreen extends StatefulWidget {
  const LessonDetailScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  late final LessonModel lesson = LessonsData.byId(widget.lessonId);
  bool _showExercises = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(showBackArrow: true, title: Text(lesson.title)),
      body: SafeArea(
        child: _showExercises && lesson.exercises.isNotEmpty
            ? ExerciseQuiz(
                exercises: lesson.exercises,
                onFinished: () => setState(() => _showExercises = false),
              )
            : _LessonContent(
                lesson: lesson,
                onStartExercises: lesson.exercises.isEmpty ? null : () => setState(() => _showExercises = true),
              ),
      ),
    );
  }
}

class _LessonContent extends StatelessWidget {
  const _LessonContent({required this.lesson, required this.onStartExercises});

  final LessonModel lesson;
  final VoidCallback? onStartExercises;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      children: [
        if (lesson.showcaseNotePositions.isNotEmpty) ...[
          StaffWidget(notePositions: lesson.showcaseNotePositions, height: 130),
          const SizedBox(height: TSizes.spaceBtwSections),
        ],
        ...lesson.content.map(
          (paragraph) => Padding(
            padding: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
            child: Text(paragraph, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
        if (onStartExercises != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onStartExercises,
              icon: const Icon(Iconsax.edit),
              label: const Text('Începe exercițiile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                foregroundColor: TColors.white,
                padding: const EdgeInsets.symmetric(vertical: TSizes.md),
              ),
            ),
          ),
      ],
    );
  }
}
