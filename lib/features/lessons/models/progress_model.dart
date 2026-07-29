import 'lesson_level.dart';

/// Progresul utilizatorului într-o singură categorie (Copii / Elevi / Hobby).
///
/// Fiecare categorie este complet independentă de celelalte: un elev avansat
/// nu are nevoie de rezultate la categoria "Copii" ca să își vadă punctele
/// și nivelul lui - fiecare categorie își ține propriile lecții citite,
/// scoruri la teste și puncte.
class LevelProgress {
  const LevelProgress({
    this.completedLessonIds = const {},
    this.bestScores = const {},
    this.totalExercises = const {},
    this.practicePoints = 0,
  });

  /// ID-urile lecțiilor citite/finalizate.
  final Set<String> completedLessonIds;

  /// Cel mai bun scor obținut la testul fiecărei lecții (lessonId -> nr. corecte).
  final Map<String, int> bestScores;

  /// Numărul total de exerciții al fiecărei lecții (cache, pentru afișare/calcul).
  final Map<String, int> totalExercises;

  /// Puncte obținute din antrenamentul liber (ecranul "Exerciții").
  final int practicePoints;

  static const int pointsPerLesson = 15;
  static const int pointsPerCorrectAnswer = 5;
  static const int pointsPerPracticeAnswer = 2;

  int get lessonPoints => completedLessonIds.length * pointsPerLesson;

  int get exercisePoints => bestScores.values.fold(0, (sum, v) => sum + v * pointsPerCorrectAnswer);

  /// Totalul de puncte al acestei categorii - independent de celelalte categorii.
  int get points => lessonPoints + exercisePoints + practicePoints;

  int get lessonsCompletedCount => completedLessonIds.length;

  bool isLessonPassed(String lessonId) {
    final total = totalExercises[lessonId] ?? 0;
    if (total == 0) return false;
    return (bestScores[lessonId] ?? 0) == total;
  }

  int get testsPassedCount => completedLessonIds.where(isLessonPassed).length;

  LevelProgress copyWith({
    Set<String>? completedLessonIds,
    Map<String, int>? bestScores,
    Map<String, int>? totalExercises,
    int? practicePoints,
  }) {
    return LevelProgress(
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      bestScores: bestScores ?? this.bestScores,
      totalExercises: totalExercises ?? this.totalExercises,
      practicePoints: practicePoints ?? this.practicePoints,
    );
  }

  factory LevelProgress.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LevelProgress();
    return LevelProgress(
      completedLessonIds: ((json['completed'] as List?) ?? const []).map((e) => e.toString()).toSet(),
      bestScores: ((json['bestScores'] as Map?) ?? const {}).map((k, v) => MapEntry(k.toString(), (v as num).toInt())),
      totalExercises:
          ((json['totalExercises'] as Map?) ?? const {}).map((k, v) => MapEntry(k.toString(), (v as num).toInt())),
      practicePoints: (json['practicePoints'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'completed': completedLessonIds.toList(),
        'bestScores': bestScores,
        'totalExercises': totalExercises,
        'practicePoints': practicePoints,
      };
}

/// Progresul complet al utilizatorului, câte o intrare [LevelProgress]
/// independentă pentru fiecare categorie din [LessonLevel], plus un "streak"
/// global (zile consecutive în care a exersat ceva) - nu e legat de o
/// singură categorie, e o măsură simplă de obișnuință zilnică.
class ProgressModel {
  const ProgressModel(this.byLevel, {this.currentStreak = 0, this.lastActiveDate});

  final Map<LessonLevel, LevelProgress> byLevel;

  /// Numărul de zile consecutive în care utilizatorul a finalizat cel puțin
  /// o acțiune de progres (lecție citită, test trecut sau exercițiu corect).
  final int currentStreak;

  /// Ultima zi (format `yyyy-MM-dd`, calendar local) în care s-a înregistrat
  /// activitate - folosită doar ca să calculăm dacă streak-ul continuă, se
  /// resetează sau rămâne neschimbat (mai multe acțiuni în aceeași zi).
  final String? lastActiveDate;

  LevelProgress of(LessonLevel level) => byLevel[level] ?? const LevelProgress();

  factory ProgressModel.empty() => ProgressModel({for (final level in LessonLevel.values) level: const LevelProgress()});

  factory ProgressModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProgressModel.empty();
    return ProgressModel(
      {for (final level in LessonLevel.values) level: LevelProgress.fromJson(json[level.name] as Map<String, dynamic>?)},
      currentStreak: (json['streak'] as num?)?.toInt() ?? 0,
      lastActiveDate: json['lastActiveDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        for (final level in LessonLevel.values) level.name: of(level).toJson(),
        'streak': currentStreak,
        'lastActiveDate': lastActiveDate,
      };

  static String _dateKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Întoarce o copie a progresului, cu categoria [level] înlocuită prin [update].
  ProgressModel updateLevel(LessonLevel level, LevelProgress Function(LevelProgress current) update) {
    final next = Map<LessonLevel, LevelProgress>.from(byLevel);
    next[level] = update(of(level));
    return ProgressModel(next, currentStreak: currentStreak, lastActiveDate: lastActiveDate);
  }

  /// Înregistrează activitate "azi" - de apelat de fiecare dată când
  /// utilizatorul finalizează ceva (lecție, test, exercițiu corect).
  /// - dacă e deja înregistrată activitate azi, nu schimbă nimic.
  /// - dacă ultima activitate a fost ieri, streak-ul crește cu 1.
  /// - altfel (prima activitate sau a fost o pauză mai mare), streak-ul repornește de la 1.
  ProgressModel withActivityToday({DateTime? now}) {
    final today = _dateKey(now ?? DateTime.now());
    if (lastActiveDate == today) return this;

    final yesterday = _dateKey((now ?? DateTime.now()).subtract(const Duration(days: 1)));
    final continuesStreak = lastActiveDate == yesterday;
    return ProgressModel(
      byLevel,
      currentStreak: continuesStreak ? currentStreak + 1 : 1,
      lastActiveDate: today,
    );
  }
}

/// Rangul (nivelul) calculat din punctele acumulate într-o categorie.
class LevelRank {
  const LevelRank({required this.number, required this.title, required this.pointsIntoLevel, required this.pointsForNextLevel});

  final int number;
  final String title;
  final int pointsIntoLevel;
  final int pointsForNextLevel;

  double get progress => pointsForNextLevel == 0 ? 1.0 : (pointsIntoLevel / pointsForNextLevel).clamp(0.0, 1.0);
}

class ProgressRank {
  static const List<String> _titles = ['Începător', 'Ucenic', 'Priceput', 'Avansat', 'Maestru'];
  static const List<int> _thresholds = [0, 15, 35, 60, 90];
  static const int _extraStep = 50;

  /// Calculează rangul (nume + progres spre următorul nivel) pornind de la punctele acumulate.
  static LevelRank forPoints(int points) {
    int tierIndex = 0;
    for (int i = _thresholds.length - 1; i >= 0; i--) {
      if (points >= _thresholds[i]) {
        tierIndex = i;
        break;
      }
    }

    if (tierIndex < _titles.length - 1) {
      final currentThreshold = _thresholds[tierIndex];
      final nextThreshold = _thresholds[tierIndex + 1];
      return LevelRank(
        number: tierIndex + 1,
        title: _titles[tierIndex],
        pointsIntoLevel: points - currentThreshold,
        pointsForNextLevel: nextThreshold - currentThreshold,
      );
    }

    final base = _thresholds.last;
    final extra = points - base;
    final extraLevels = extra ~/ _extraStep;
    return LevelRank(
      number: _titles.length + extraLevels,
      title: extraLevels == 0 ? _titles.last : '${_titles.last} +$extraLevels',
      pointsIntoLevel: extra % _extraStep,
      pointsForNextLevel: _extraStep,
    );
  }
}
