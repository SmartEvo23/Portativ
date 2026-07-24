/// O variantă de răspuns pentru un exercițiu grilă.
class ExerciseOption {
  const ExerciseOption({required this.text, required this.isCorrect});

  final String text;
  final bool isCorrect;
}

/// Un exercițiu simplu, cu întrebare și variante de răspuns.
///
/// Dacă [notePosition] este setat, exercițiul afișează o notă desenată pe portativ
/// (vezi [TrebleClefNotes]) deasupra întrebării - de exemplu "Ce notă este aceasta?".
class ExerciseModel {
  const ExerciseModel({
    required this.question,
    this.notePosition,
    required this.options,
  });

  final String question;
  final int? notePosition;
  final List<ExerciseOption> options;
}
