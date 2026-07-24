import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:portativ/utils/constants/colors.dart';
import 'package:portativ/utils/helpers/helper_functions.dart';

import 'features/lessons/screens/dashboard/lessons_dashboard_screen.dart';
import 'features/lessons/screens/lessons_home/lessons_home_screen.dart';
import 'features/lessons/screens/practice/practice_screen.dart';
import 'features/personalization/screens/setting/settings.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppScreenController());
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          animationDuration: const Duration(seconds: 3),
          selectedIndex: controller.selectedMenu.value,
          backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.black : Colors.white,
          elevation: 0,
          indicatorColor: THelperFunctions.isDarkMode(context) ? TColors.white.withOpacity(0.1) : TColors.black.withOpacity(0.1),
          onDestinationSelected: (index) => controller.selectedMenu.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Acasă'),
            NavigationDestination(icon: Icon(Iconsax.music), label: 'Lecții'),
            NavigationDestination(icon: Icon(Iconsax.flash_1), label: 'Exerciții'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profil'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedMenu.value]),
    );
  }
}

class AppScreenController extends GetxController {
  static AppScreenController get instance => Get.find();

  final Rx<int> selectedMenu = 0.obs;

  final screens = [
    const LessonsDashboardScreen(),
    const LessonsHomeScreen(),
    const PracticeScreen(),
    const SettingsScreen(),
  ];
}
