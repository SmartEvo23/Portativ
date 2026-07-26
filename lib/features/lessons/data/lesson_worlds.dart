import 'package:flutter/material.dart';

import '../models/lesson_module.dart';

/// O "lume" tematică din aventura Copiilor - grupează un modul de lecții
/// într-o poveste, cu propriul decor și fundal colorat.
class LessonWorld {
  const LessonWorld({
    required this.module,
    required this.title,
    required this.tagline,
    required this.story,
    required this.gradient,
  });

  final LessonModule module;
  final String title;
  final String tagline;
  final String story;
  final List<Color> gradient;
}

/// Lumile aventurii pentru categoria "Copii", câte una pentru fiecare modul.
const List<LessonWorld> kKidsWorlds = [
  LessonWorld(
    module: LessonModule.teorieDeBaza,
    title: 'Pădurea Portativului',
    tagline: 'Primii pași în lumea notelor',
    story:
        'Ai pășit în Pădurea Portativului! Aici, printre cele 5 linii fermecate, locuiesc notele mici și jucăușe. '
        'Ajută-le să-și găsească locul și vei deveni un adevărat explorator muzical!',
    gradient: [Color(0xFFBFEAF5), Color(0xFFE3F8E1)],
  ),
  LessonWorld(
    module: LessonModule.ritm,
    title: 'Muntele Ritmului',
    tagline: 'Bătăi, tobe și pași de dans',
    story:
        'Ai urcat pe Muntele Ritmului! Aici, fiecare stâncă bate un ritm al ei. '
        'Ascultă cu atenție, bate din palme și învață cum se numără timpii unei melodii.',
    gradient: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
  ),
  LessonWorld(
    module: LessonModule.instrumente,
    title: 'Orașul Instrumentelor',
    tagline: 'Viori, tobe și trompete',
    story:
        'Bun venit în Orașul Instrumentelor! Pe fiecare stradă locuiește un instrument diferit - unele cântă, '
        'altele bat, altele suflă. Hai să le cunoști pe toate!',
    gradient: [Color(0xFFD1C4E9), Color(0xFFB39DDB)],
  ),
  LessonWorld(
    module: LessonModule.urecheMuzicala,
    title: 'Peștera Ecourilor',
    tagline: 'Sunete înalte, joase, tari și încete',
    story:
        'Ai intrat în Peștera Ecourilor! Aici fiecare sunet se aude altfel - unele înalte, unele joase, unele tari, '
        'altele abia șoptite. Antrenează-ți urechea și descoperă secretele sunetului!',
    gradient: [Color(0xFFB2EBF2), Color(0xFF80DEEA)],
  ),
];

LessonWorld? worldForModule(LessonModule module) {
  for (final world in kKidsWorlds) {
    if (world.module == module) return world;
  }
  return null;
}
