import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/images/t_circular_image.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
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

const List<String> _kRomanianMonths = [
  'ianuarie', 'februarie', 'martie', 'aprilie', 'mai', 'iunie',
  'iulie', 'august', 'septembrie', 'octombrie', 'noiembrie', 'decembrie',
];

String _formatMemberSince(DateTime? date) {
  if (date == null) return '-';
  return '${_kRomanianMonths[date.month - 1]} ${date.year}';
}

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
              TProfileMenu(onPressed: () {}, title: 'E-mail', value: controller.user.value.email, icon: Iconsax.direct),
              TProfileMenu(onPressed: () {}, title: 'Număr Telefon', value: controller.user.value.phoneNumber, icon: Iconsax.mobile),
              TProfileMenu(
                onPressed: () {},
                title: 'Membru din',
                value: _formatMemberSince(AuthenticationRepository.instance.firebaseUser?.metadata.creationTime),
                icon: Iconsax.calendar,
              ),
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

/// Rezumatul progresului la fiecare categorie de lecții, afișat în profil ca
/// insigne separate - fiecare categorie e independentă: punctele și nivelul
/// unei categorii nu sunt influențate de rezultatele din celelalte.
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
          Row(
            children: [
              for (final level in LessonLevel.values) ...[
                Expanded(child: _ProgressBadge(level: level, levelProgress: progress.of(level))),
                if (level != LessonLevel.values.last) const SizedBox(width: TSizes.sm),
              ],
            ],
          ),
        ],
      );
    });
  }
}

class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({required this.level, required this.levelProgress});

  final LessonLevel level;
  final LevelProgress levelProgress;

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
    final rank = ProgressRank.forPoints(levelProgress.points);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: TSizes.md, horizontal: TSizes.sm),
      decoration: BoxDecoration(
        color: TColors.lightContainer,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: TColors.primary.withOpacity(0.12),
            child: Icon(_icon, color: TColors.primary),
          ),
          const SizedBox(height: TSizes.sm),
          Text(level.label, style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(
            rank.title,
            style: Theme.of(context).textTheme.labelSmall!.apply(color: TColors.primary),
            textAlign: TextAlign.center,
          ),
          Text('Nivel ${rank.number}', style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center),
          const SizedBox(height: TSizes.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(TSizes.sm),
            child: LinearProgressIndicator(
              value: rank.progress,
              minHeight: 5,
              backgroundColor: TColors.borderPrimary,
              valueColor: const AlwaysStoppedAnimation(TColors.primary),
            ),
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            '${levelProgress.lessonsCompletedCount}/${lessons.length} lecții',
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
