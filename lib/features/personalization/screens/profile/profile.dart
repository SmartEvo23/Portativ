import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/images/t_circular_image.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../lessons/controllers/progress_controller.dart';
import '../../../lessons/data/lessons_data.dart';
import '../../../lessons/models/lesson_level.dart';
import '../../../lessons/models/progress_model.dart';
import '../../controllers/user_controller.dart';
import 'change_name.dart';
import 'widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Profil', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(
                      () {
                        final networkImage = controller.user.value.profilePicture;
                        final image = networkImage.isNotEmpty ? networkImage : TImages.user;
                        return controller.imageUploading.value
                            ? const TShimmerEffect(width: 80, height: 80, radius: 80)
                            : TCircularImage(image: image, width: 80, height: 80, isNetworkImage: networkImage.isNotEmpty);
                      },
                    ),
                    TextButton(
                      onPressed: controller.imageUploading.value ? () {} : () => controller.uploadUserProfilePicture(),
                      child: const Text('Schimbare Poză Profil'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(title: 'Progresul tău', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              const _ProgressSummary(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(title: 'Informații Profil', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              TProfileMenu(onPressed: () => Get.to(() => const ChangeName()), title: 'Nume', value: controller.user.value.fullName),
              TProfileMenu(onPressed: () {}, title: 'Nume utilizator', value: controller.user.value.username),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(title: 'Informații Personale', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              TProfileMenu(onPressed: () {}, title: 'ID Utilizator', value: '45689', icon: Iconsax.copy),
              TProfileMenu(onPressed: () {}, title: 'E-mail', value: controller.user.value.email),
              TProfileMenu(onPressed: () {}, title: 'Număr Telefon', value: controller.user.value.phoneNumber),
              TProfileMenu(onPressed: () {}, title: 'Gen', value: 'Bărbat'),
              TProfileMenu(onPressed: () {}, title: 'Data Nașterii', value: '23 Iunie, 1994'),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              Center(
                child: TextButton(
                    onPressed: () => controller.deleteAccountWarningPopup(),
                    child: const Text('Închidere Cont', style: TextStyle(color: Colors.red))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// Rezumatul progresului la fiecare categorie de lecții, afișat în profil.
/// Fiecare categorie e independentă: punctele și nivelul unei categorii nu
/// sunt influențate de rezultatele din celelalte.
class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary();

  @override
  Widget build(BuildContext context) {
    final progressController = Get.put(ProgressController());
    return Obx(() {
      final progress = progressController.progress.value;
      final totalPoints = LessonLevel.values.fold<int>(0, (sum, level) => sum + progress.of(level).points);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(TSizes.md),
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.star1, color: TColors.primary),
                const SizedBox(width: TSizes.sm),
                Expanded(
                  child: Text('$totalPoints puncte adunate în total', style: Theme.of(context).textTheme.titleSmall),
                ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          ...LessonLevel.values.map(
            (level) => Padding(
              padding: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
              child: _ProgressRow(level: level, levelProgress: progress.of(level)),
            ),
          ),
        ],
      );
    });
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.level, required this.levelProgress});

  final LessonLevel level;
  final LevelProgress levelProgress;

  @override
  Widget build(BuildContext context) {
    final lessons = LessonsData.byLevel(level);
    final rank = ProgressRank.forPoints(levelProgress.points);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(level.label, style: Theme.of(context).textTheme.bodyMedium),
              Text('${rank.title} · Niv. ${rank.number}', style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(TSizes.sm),
            child: LinearProgressIndicator(
              value: rank.progress,
              minHeight: 6,
              backgroundColor: TColors.borderPrimary,
              valueColor: const AlwaysStoppedAnimation(TColors.primary),
            ),
          ),
        ),
        const SizedBox(width: TSizes.sm),
        Expanded(
          flex: 2,
          child: Text(
            '${levelProgress.lessonsCompletedCount}/${lessons.length} lecții',
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}
