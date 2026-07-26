import 'package:flutter/material.dart';

import '../../../models/lesson_level.dart';
import 'terrain_map_view.dart';

/// Harta de lecții pentru "Hobby": aceeași hartă de regat, cu mascote-
/// companion și explorator animat, dar fără deblocare secvențială - toate
/// lecțiile sunt libere, pentru recapitulare în orice ordine.
class HobbyWheelView extends StatelessWidget {
  const HobbyWheelView({super.key});

  @override
  Widget build(BuildContext context) {
    return const TerrainMapView(
      level: LessonLevel.hobby,
      sequentialUnlock: false,
      showCompanions: true,
      showExplorer: true,
      useWorldIntro: false,
    );
  }
}
