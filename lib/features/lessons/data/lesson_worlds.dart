import 'package:flutter/material.dart';

import '../../../common/widgets/music/mascot_widget.dart';
import '../models/lesson_module.dart';

/// O "lume" tematică din aventura Copiilor - grupează un modul de lecții
/// într-o poveste, cu propriul decor, fundal colorat și mascote-companion
/// care "locuiesc" acolo (cântă sau dansează în buclă, tot timpul).
class LessonWorld {
  const LessonWorld({
    required this.module,
    required this.title,
    required this.tagline,
    required this.story,
    required this.gradient,
    required this.companionVariant,
    required this.companionColor,
    this.companionInstrument = MascotInstrument.tambourine,
    this.companionInstruments,
  });

  final LessonModule module;
  final String title;
  final String tagline;
  final String story;
  final List<Color> gradient;

  /// Ce fel de mascote-companion locuiesc pe acest tărâm (muzicieni sau dansatori).
  final MascotVariant companionVariant;
  final Color companionColor;

  /// Instrument implicit, folosit dacă [companionInstruments] nu e setat.
  final MascotInstrument companionInstrument;

  /// Listă opțională de instrumente, pentru variație între cei doi
  /// companioni ai unui tărâm (stânga/dreapta) - ex. în Orașul
  /// Instrumentelor, un companion cântă la vioară, celălalt la tobă.
  final List<MascotInstrument>? companionInstruments;

  /// Instrumentul folosit de companionul de la poziția [index] (0 = stânga,
  /// 1 = dreapta). Ciclează prin [companionInstruments] dacă e setat, altfel
  /// folosește [companionInstrument] pentru toți companionii.
  MascotInstrument instrumentFor(int index) {
    final list = companionInstruments;
    if (list == null || list.isEmpty) return companionInstrument;
    return list[index % list.length];
  }
}

/// Tărâmurile/lumile hărților de lecții, câte una pentru fiecare modul -
/// folosite pentru decorul hărților de la toate cele 3 categorii (Copii,
/// Elevi, Hobby). Poveștile (tagline/story) sunt folosite doar la Copii
/// (dialogul de introducere într-o lume nouă); celelalte categorii refolosesc
/// doar titlul, gradientul și stilul mascotelor-companion.
const List<LessonWorld> kKidsWorlds = [
  LessonWorld(
    module: LessonModule.teorieDeBaza,
    title: 'Pădurea Portativului',
    tagline: 'Primii pași în lumea notelor',
    story:
        'Ai pășit în Pădurea Portativului! Aici, printre cele 5 linii fermecate, locuiesc notele mici și jucăușe, '
        'care fredonează întruna. Ajută-le să-și găsească locul și vei deveni un adevărat explorator muzical!',
    gradient: [Color(0xFFBFEAF5), Color(0xFFE3F8E1)],
    companionVariant: MascotVariant.musician,
    companionColor: Color(0xFF7FD8A6),
    companionInstruments: [MascotInstrument.bell, MascotInstrument.flute],
  ),
  LessonWorld(
    module: LessonModule.ritm,
    title: 'Muntele Ritmului',
    tagline: 'Bătăi, tobe și pași de dans',
    story:
        'Ai ajuns în Regatul Dansului, de pe Muntele Ritmului! Aici locuitorii mascați dansează în perechi, pe ritmul '
        'unui vals lin. Ascultă cu atenție, bate din palme și învață cum se numără timpii unei melodii.',
    gradient: [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
    companionVariant: MascotVariant.dancer,
    companionColor: Color(0xFFFFB74D),
  ),
  LessonWorld(
    module: LessonModule.instrumente,
    title: 'Orașul Instrumentelor',
    tagline: 'Viori, tobe și trompete',
    story:
        'Bun venit în Orașul Instrumentelor! Pe fiecare stradă locuiește un mic muzician care cântă întruna la '
        'instrumentul lui - unele cântă, altele bat, altele suflă. Hai să le cunoști pe toate!',
    gradient: [Color(0xFFD1C4E9), Color(0xFFB39DDB)],
    companionVariant: MascotVariant.musician,
    companionColor: Color(0xFFB39DDB),
    companionInstruments: [MascotInstrument.violin, MascotInstrument.trumpet],
  ),
  LessonWorld(
    module: LessonModule.urecheMuzicala,
    title: 'Peștera Ecourilor',
    tagline: 'Sunete înalte, joase, tari și încete',
    story:
        'Ai intrat în Peștera Ecourilor! Aici locuitorii cântă la microfon și glasul lor se-ntoarce ca ecou de pe '
        'pereți - unele sunete înalte, unele joase, unele tari, altele abia șoptite. Antrenează-ți urechea!',
    gradient: [Color(0xFFB2EBF2), Color(0xFF80DEEA)],
    companionVariant: MascotVariant.musician,
    companionColor: Color(0xFF4DD0E1),
    companionInstruments: [MascotInstrument.microphone, MascotInstrument.drum],
  ),
  LessonWorld(
    module: LessonModule.armonie,
    title: 'Turnul Armoniei',
    tagline: 'Acorduri și culori muzicale avansate',
    story:
        'Ai urcat în Turnul Armoniei! Aici sunetele se combină în acorduri bogate, ca niște culori care se amestecă '
        'perfect. E locul celor mai avansați exploratori muzicali!',
    gradient: [Color(0xFFFFE082), Color(0xFFFFB300)],
    companionVariant: MascotVariant.musician,
    companionColor: Color(0xFFFFC107),
    companionInstruments: [MascotInstrument.piano, MascotInstrument.tambourine],
  ),
];

LessonWorld? worldForModule(LessonModule module) {
  for (final world in kKidsWorlds) {
    if (world.module == module) return world;
  }
  return null;
}
