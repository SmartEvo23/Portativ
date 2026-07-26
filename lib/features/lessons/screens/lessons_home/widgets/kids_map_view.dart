import 'package:flutter/material.dart';

import '../../../models/lesson_level.dart';
import 'terrain_map_view.dart';

/// Harta de lecții pentru "Copii": hartă de regat completă, cu mascote-
/// companion, explorator animat cu steag și poveste la fiecare tărâm nou.
class KidsMapView extends StatelessWidget {
  const KidsMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return const TerrainMapView(
      level: LessonLevel.copii,
      sequentialUnlock: true,
      showCompanions: true,
      showExplorer: true,
      useWorldIntro: true,
    );
  }
}
