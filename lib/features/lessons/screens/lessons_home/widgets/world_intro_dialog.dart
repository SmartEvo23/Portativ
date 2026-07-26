import 'package:flutter/material.dart';

import '../../../../../common/widgets/music/mascot_widget.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/local_storage/storage_utility.dart';
import '../../../data/lesson_worlds.dart';
import '../../../models/lesson_module.dart';

String _seenWorldKey(LessonModule module) => 'seenWorldIntro_${module.name}';

/// Arată, o singură dată per utilizator, o mică poveste de bun-venit atunci
/// când copilul intră prima dată într-o lume (modul) nouă de pe hartă.
/// Apelează [onContinue] imediat după (sau direct, dacă a mai fost văzută).
Future<void> showWorldIntroIfNeeded(
  BuildContext context,
  LessonModule module,
  VoidCallback onContinue,
) async {
  final world = worldForModule(module);
  if (world == null) {
    onContinue();
    return;
  }

  final storage = TLocalStorage.instance();
  final alreadySeen = storage.readData<bool>(_seenWorldKey(module)) ?? false;
  if (alreadySeen) {
    onContinue();
    return;
  }

  await storage.writeData<bool>(_seenWorldKey(module), true);

  if (!context.mounted) {
    onContinue();
    return;
  }

  await showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, _, __) => _WorldIntroContent(world: world),
    transitionBuilder: (context, animation, _, child) => ScaleTransition(
      scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
      child: FadeTransition(opacity: animation, child: child),
    ),
  );

  onContinue();
}

class _WorldIntroContent extends StatelessWidget {
  const _WorldIntroContent({required this.world});

  final LessonWorld world;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: TSizes.lg),
          padding: const EdgeInsets.all(TSizes.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: world.gradient),
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg * 1.5),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 24, offset: const Offset(0, 12))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MascotWidget(size: 84),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                world.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.textPrimary),
              ),
              const SizedBox(height: TSizes.xs),
              Text(
                world.tagline,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge!.apply(color: TColors.textPrimary.withOpacity(0.7)),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                world.story,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.textPrimary),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    foregroundColor: TColors.white,
                    padding: const EdgeInsets.symmetric(vertical: TSizes.md),
                  ),
                  child: const Text('Începe aventura!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
