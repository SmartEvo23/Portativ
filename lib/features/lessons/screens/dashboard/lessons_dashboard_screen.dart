import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/music/staff_widget.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../controllers/progress_controller.dart';
import '../../data/lessons_data.dart';
import '../../models/lesson_level.dart';
import '../../models/progress_model.dart';
import '../lessons_home/lessons_home_screen.dart' show LessonsHomeScreen;
import '../practice/practice_screen.dart';

/// Ecranul "Acasă": salut, un rezumat al progresului la fiecare categorie de
/// lecții (independent unul de altul) și acces rapid la antrenament.
class LessonsDashboardScreen extends StatelessWidget {
  const LessonsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.isRegistered<UserController>() ? UserController.instance : null;
    final progressController = Get.put(ProgressController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TPrimaryHeaderContainer(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(TSizes.md, TSizes.md, TSizes.md, TSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (userController == null)
                        Text('Salut!', style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white))
                      else
                        Obx(() {
                          final name = userController.user.value.firstName;
                          return Text(
                            name.isEmpty ? 'Salut!' : 'Salut, $name!',
                            style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white),
                          );
                        }),
                      const SizedBox(height: TSizes.xs),
                      Text('Hai să învățăm puțină muzică astăzi',
                          style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StaffWidget(notePositions: [0, 2, 4, 6, 8], height: 110),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Text('Progresul tău', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: TSizes.xs),
                    Text(
                      'Fiecare categorie are propriul nivel și punctaj - nu depinde de celelalte.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Obx(() {
                      final progress = progressController.progress.value;
                      return Column(
                        children: LessonLevel.values
                            .map((level) => Padding(
                                  padding: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                                  child: _CategoryProgressCard(level: level, progress: progress.of(level)),
                                ))
                            .toList(),
                      );
                    }),
                    const SizedBox(height: TSizes.sm),
                    _PracticeBanner(),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryProgressCard extends StatelessWidget {
  const _CategoryProgressCard({required this.level, required this.progress});

  final LessonLevel level;
  final LevelProgress progress;

  IconData get _icon {
    switch (level) {
      case LessonLevel.copii:
        return Iconsax.star1;
      case LessonLevel.elevi:
        return Iconsax.edit;
      case LessonLevel.hobby:
        return Iconsax.heart;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessons = LessonsData.byLevel(level);
    final rank = ProgressRank.forPoints(progress.points);

    return InkWell(
      borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      onTap: () => Get.to(() => LessonsHomeScreen(initialLevel: level)),
      child: Container(
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: TColors.lightContainer,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: TColors.primary.withOpacity(0.12),
                  child: Icon(_icon, color: TColors.primary),
                ),
                const SizedBox(width: TSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(level.label, style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        '${rank.title} · Nivel ${rank.number}',
                        style: Theme.of(context).textTheme.bodySmall!.apply(color: TColors.primary),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${progress.points}', style: Theme.of(context).textTheme.titleMedium),
                    Text('puncte', style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ],
            ),
            const SizedBox(height: TSizes.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(TSizes.sm),
              child: LinearProgressIndicator(
                value: rank.progress,
                minHeight: 6,
                backgroundColor: TColors.borderPrimary,
                valueColor: const AlwaysStoppedAnimation(TColors.primary),
              ),
            ),
            const SizedBox(height: TSizes.sm),
            Row(
              children: [
                _StatChip(icon: Iconsax.music, label: '${progress.lessonsCompletedCount}/${lessons.length} lecții citite'),
                const SizedBox(width: TSizes.sm),
                _StatChip(icon: Iconsax.tick_circle, label: '${progress.testsPassedCount}/${lessons.length} teste trecute'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
        decoration: BoxDecoration(color: TColors.white, borderRadius: BorderRadius.circular(TSizes.sm)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: TSizes.iconXs, color: TColors.darkGrey),
            const SizedBox(width: 4),
            Flexible(child: Text(label, style: Theme.of(context).textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}

class _PracticeBanner extends StatelessWidget {
  const _PracticeBanner();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      onTap: () => Get.to(() => const PracticeScreen()),
      child: Container(
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: TColors.primary,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        ),
        child: Row(
          children: [
            const Icon(Iconsax.flash_1, color: TColors.white, size: TSizes.iconLg),
            const SizedBox(width: TSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Antrenament rapid', style: Theme.of(context).textTheme.titleMedium!.apply(color: TColors.white)),
                  Text('10 întrebări amestecate din toate lecțiile',
                      style: Theme.of(context).textTheme.bodySmall!.apply(color: TColors.white)),
                ],
              ),
            ),
            const Icon(Iconsax.arrow_right_3, color: TColors.white),
          ],
        ),
      ),
    );
  }
}
