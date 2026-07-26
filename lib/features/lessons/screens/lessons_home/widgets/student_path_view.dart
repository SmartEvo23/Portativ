import 'package:flutter/material.dart';

import '../../../models/lesson_level.dart';
import 'terrain_map_view.dart';

/// Harta de lecții pentru "Elevi": aceeași hartă de regat, dar sobră - fără
/// mascote sau explorator animat, doar un marcaj static al poziției curente.
class StudentPathView extends StatelessWidget {
  const StudentPathView({super.key});

  @override
  Widget build(BuildContext context) {
    return const TerrainMapView(
      level: LessonLevel.elevi,
      sequentialUnlock: true,
      showCompanions: false,
      showExplorer: false,
      useWorldIntro: false,
      sober: true,
    );
  }
}
