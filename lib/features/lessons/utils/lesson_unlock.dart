import '../models/lesson_model.dart';
import '../models/progress_model.dart';

/// Determină dacă lecția de la [index] este deblocată, pe baza progresului
/// secvențial: prima lecție e mereu deblocată, iar următoarele se deblochează
/// pe rând, după ce lecția anterioară a fost citită/finalizată.
bool isLessonUnlocked(List<LessonModel> orderedLessons, int index, LevelProgress progress) {
  if (index <= 0) return true;
  final previous = orderedLessons[index - 1];
  return progress.completedLessonIds.contains(previous.id);
}

/// Numărul de stele (0-3) obținut la testul unei lecții, pe baza celui mai
/// bun scor înregistrat.
int starsForLesson(String lessonId, LevelProgress progress) {
  final total = progress.totalExercises[lessonId] ?? 0;
  if (total == 0) return 0;
  final best = progress.bestScores[lessonId] ?? 0;
  final ratio = best / total;
  if (ratio >= 1.0) return 3;
  if (ratio >= 0.66) return 2;
  if (ratio > 0) return 1;
  return 0;
}
