import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/music/staff_widget.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../data/lessons_data.dart';
import '../../models/lesson_level.dart';
import '../lesson_detail/lesson_detail_screen.dart';
import '../practice/practice_screen.dart';

/// Ecranul "Acasă": salut, portativ decorativ și acces rapid la niveluri.
class LessonsDashboardScreen extends StatelessWidget {
  const LessonsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.isRegistered<UserController>() ? UserController.instance : null;

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
                    Text('Alege un nivel', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    ...LessonLevel.values.map((level) => Padding(
                          padding: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                          child: _LevelCard(level: level),
                        )),
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

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.level});

  final LessonLevel level;

  @override
  Widget build(BuildContext context) {
    final lessonCount = LessonsData.byLevel(level).length;
    return InkWell(
      borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      onTap: () {
        final firstLesson = LessonsData.byLevel(level).first;
        Get.to(() => LessonDetailScreen(lessonId: firstLesson.id));
      },
      child: Container(
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: TColors.lightContainer,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        ),
        child: Row(
          children: [
            const Icon(Iconsax.music, color: TColors.primary, size: TSizes.iconLg),
            const SizedBox(width: TSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(level.label, style: Theme.of(context).textTheme.titleMedium),
                  Text('$lessonCount lecții · ${level.description}', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Iconsax.arrow_right_3, color: TColors.darkGrey),
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
