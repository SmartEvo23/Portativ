/// O variantă de răspuns pentru un exercițiu grilă.
class ExerciseOption {
  const ExerciseOption({required this.text, required this.isCorrect});

  final String text;
  final bool isCorrect;
}

/// O notă din cadrul unei secvențe audio ([SoundCue]) - poziția ei pe portativ
/// (vezi [TrebleClefNotes]) și volumul cu care e redată (1.0 = normal/forte,
/// valori mai mici = mai încet/piano - folosit la exercițiile de dinamică).
class CuedNote {
  const CuedNote(this.position, {this.volume = 1.0});

  final int position;
  final double volume;
}

/// O secvență de sunete care se redă la cerere (sau automat) pentru un
/// exercițiu de "ureche muzicală" - una sau mai multe note, cântate pe rând,
/// cu o pauză de [gapMs] milisecunde între ele.
class SoundCue {
  const SoundCue(this.notes, {this.gapMs = 450});

  final List<CuedNote> notes;
  final int gapMs;
}

/// Un exercițiu simplu, cu întrebare și variante de răspuns.
///
/// Dacă [notePosition] este setat, exercițiul afișează o notă desenată pe portativ
/// (vezi [TrebleClefNotes]) deasupra întrebării - de exemplu "Ce notă este aceasta?"
/// - și un buton "Ascultă" care redă sunetul acelei note.
///
/// Dacă [soundCue] este setat, exercițiul redă (automat, cu buton de reascultare)
/// o secvență de sunete înainte ca elevul să răspundă - folosit la exercițiile
/// chiar de "ureche muzicală" (înalt/jos, tare/încet, intervale, game).
class ExerciseModel {
  const ExerciseModel({
    required this.question,
    this.notePosition,
    this.soundCue,
    required this.options,
  });

  final String question;
  final int? notePosition;
  final SoundCue? soundCue;
  final List<ExerciseOption> options;
}
