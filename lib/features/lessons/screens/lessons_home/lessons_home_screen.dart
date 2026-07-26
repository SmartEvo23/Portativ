import 'package:flutter/material.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/music/staff_widget.dart';
import '../../../../utils/constants/colors.dart';
import '../../models/lesson_level.dart';
import 'widgets/hobby_wheel_view.dart';
import 'widgets/kids_map_view.dart';
import 'widgets/student_path_view.dart';

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
            const Expanded(
              child: TabBarView(
                children: [
                  KidsMapView(),
                  StudentPathView(),
                  HobbyWheelView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
