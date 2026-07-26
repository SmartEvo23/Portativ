import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/music/staff_widget.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/progress_controller.dart';
import '../../data/lessons_data.dart';
import '../../models/lesson_level.dart';
import '../../models/lesson_model.dart';
import '../lesson_detail/lesson_detail_screen.dart';

/// Ecranul "Lecții": alege un nivel (Copii / Elevi / Hobby) și vezi lecțiile lui.
class LessonsHomeScreen extends StatelessWidget {
  const LessonsHomeScreen({super.key, this.initialLevel});

  /// Dacă e setat, ecranul se deschide direct pe tab-ul acestei categorii
  /// (de exemplu la venirea dintr-un card de progres din dashboard).
  final LessonLevel? initialLevel;

  @override
  Widget build(BuildContext context) {
    final initialIndex = initialLevel == null ? 0 : LessonLevel.values.indexOf(initialLevel!);
    return DefaultTabController(
      length: LessonLevel.values.length,
      initialIndex: initialIndex < 0 ? 0 : initialIndex,
      child: Scaffold(
        appBar: TAppBar(title: const Text('Lecții')),
        body: Column(
          children: [
            const TabBar(
              labelColor: TColors.primary,
              unselectedLabelColor: TColors.darkGrey,
              indicatorColor: TColors.primary,
              tabs: [
                Tab(text: 'Copii'),
                Tab(text: 'Elevi'),
                Tab(text: 'Hobby'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: LessonLevel.values.map((level) => _LevelLessonsList(level: level)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelLessonsList extends StatelessWidget {
  const _LevelLessonsList({required this.level});

  final LessonLevel level;

  @override
  Widget build(BuildContext context) {
    final lessons = LessonsData.byLevel(level);
    return ListView(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      children: [
        Text(level.description, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: TSizes.spaceBtwItems),
        ...lessons.map((lesson) => Padding(
              padding: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
              child: _LessonCard(lesson: lesson),
            )),
      ],
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.lesson});

  final LessonModel lesson;

  @override
  Widget build(BuildContext context) {
    final progressController = Get.put(ProgressController());
    return Obx(() {
      final levelProgress = progressController.progress.value.of(lesson.level);
      final isRead = levelProgress.completedLessonIds.contains(lesson.id);
      final isPassed = levelProgress.isLessonPassed(lesson.id);

      return InkWell(
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        onTap: () => Get.to(() => LessonDetailScreen(lessonId: lesson.id)),
        child: Container(
          padding: const EdgeInsets.all(TSizes.md),
          decoration: BoxDecoration(
            color: TColors.lightContainer,
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            border: isPassed ? Border.all(color: TColors.success.withOpacity(0.5)) : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson.title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: TSizes.xs),
                    Text(lesson.summary, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: TSizes.xs),
                    Row(
                      children: [
                        Icon(Iconsax.tick_circle, size: TSizes.iconXs, color: isPassed ? TColors.success : TColors.darkGrey),
                        const SizedBox(width: TSizes.xs),
                        Text(
                          isPassed
                              ? 'Test trecut'
                              : isRead
                                  ? 'Citită · ${lesson.exercises.length} exerciții'
                                  : '${lesson.exercises.length} exerciții',
                          style: Theme.of(context).textTheme.labelSmall!.apply(color: isPassed ? TColors.success : null),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: TSizes.sm),
              const Icon(Iconsax.arrow_right_3, color: TColors.darkGrey),
            ],
          ),
        ),
      );
    });
  }
}

/// Mic portativ decorativ, folosit ca "logo" pe carduri sau headere.
class LessonStaffPreview extends StatelessWidget {
  const LessonStaffPreview({super.key, this.height = 60});

  final double height;

  @override
  Widget build(BuildContext context) {
    return StaffWidget(notePositions: const [0, 2, 4, 6, 8], height: height);
  }
}
