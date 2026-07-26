import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../controllers/progress_controller.dart';
import '../../../data/lessons_data.dart';
import '../../../models/lesson_level.dart';
import '../../../utils/lesson_unlock.dart';
import '../../lesson_detail/lesson_detail_screen.dart';

/// Traseul de lecții pentru "Elevi": un parcurs vertical, clar și sobru -
/// fără elemente jucăușe, potrivit unui public mai matur. Lecțiile se leagă
/// una de alta printr-o linie continuă, în ordine.
class StudentPathView extends StatelessWidget {
  const StudentPathView({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = LessonsData.byLevel(LessonLevel.elevi);
    final progressController = Get.put(ProgressController());

    return Obx(() {
      final progress = progressController.progress.value.of(LessonLevel.elevi);

      return ListView.builder(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        itemCount: lessons.length,
        itemBuilder: (context, i) {
          final lesson = lessons[i];
          final unlocked = isLessonUnlocked(lessons, i, progress);
          final passed = progress.isLessonPassed(lesson.id);
          final read = progress.completedLessonIds.contains(lesson.id);
          final isLast = i == lessons.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: !unlocked
                            ? TColors.borderPrimary
                            : passed
                                ? TColors.success
                                : TColors.primary,
                      ),
                      alignment: Alignment.center,
                      child: !unlocked
                          ? const Icon(Icons.lock_rounded, size: 16, color: TColors.darkGrey)
                          : Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    if (!isLast) Expanded(child: Container(width: 2, color: TColors.borderPrimary)),
                  ],
                ),
                const SizedBox(width: TSizes.md),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: TSizes.spaceBtwSections),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                      onTap: unlocked
                          ? () => Get.to(() => LessonDetailScreen(lessonId: lesson.id))
                          : () => TLoaders.warningSnackBar(
                              title: 'Lecție blocată', message: 'Termină mai întâi lecția anterioară.'),
                      child: Opacity(
                        opacity: unlocked ? 1 : 0.55,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(TSizes.md),
                          decoration: BoxDecoration(
                            color: TColors.lightContainer,
                            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                            border: passed ? Border.all(color: TColors.success.withOpacity(0.5)) : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lesson.title, style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: TSizes.xs),
                              Text(lesson.summary, style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: TSizes.xs),
                              Text(
                                passed
                                    ? 'Test trecut'
                                    : read
                                        ? 'Citită · ${lesson.exercises.length} exerciții'
                                        : '${lesson.exercises.length} exerciții',
                                style:
                                    Theme.of(context).textTheme.labelSmall!.apply(color: passed ? TColors.success : null),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
