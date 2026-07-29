import 'package:get/get.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../models/lesson_level.dart';
import '../models/progress_model.dart';

/// Ține evidența progresului utilizatorului la lecții și exerciții, separat
/// pe fiecare categorie (Copii / Elevi / Hobby). Progresul este salvat în
/// documentul utilizatorului din Firestore (câmpul "Progress").
class ProgressController extends GetxController {
  static ProgressController get instance => Get.find();

  final Rx<ProgressModel> progress = ProgressModel.empty().obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    loadProgress();
    super.onInit();
  }

  Future<void> loadProgress() async {
    try {
      isLoading.value = true;
      final json = await Get.put(UserRepository()).fetchProgress();
      progress.value = ProgressModel.fromJson(json);
    } catch (_) {
      // Utilizator neautentificat sau eroare de rețea: pornim de la progres gol.
      progress.value = ProgressModel.empty();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _persist() async {
    try {
      await Get.put(UserRepository()).updateSingleField({'Progress': progress.value.toJson()});
    } catch (_) {
      // Progresul rămâne vizibil local chiar dacă sincronizarea eșuează momentan.
    }
  }

  /// Marchează o lecție ca fiind citită/finalizată (folosit pentru lecțiile fără exerciții).
  void markLessonCompleted(LessonLevel level, String lessonId) {
    final already = progress.value.of(level).completedLessonIds.contains(lessonId);
    if (already) return;
    progress.value = progress.value
        .updateLevel(level, (lp) => lp.copyWith(completedLessonIds: {...lp.completedLessonIds, lessonId}))
        .withActivityToday();
    _persist();
  }

  /// Înregistrează rezultatul unui test de lecție; păstrează scorul maxim obținut,
  /// astfel încât reîncercările să nu poată scădea progresul deja făcut.
  void recordLessonQuizResult(LessonLevel level, String lessonId, int correct, int total) {
    progress.value = progress.value.updateLevel(level, (lp) {
      final currentBest = lp.bestScores[lessonId] ?? 0;
      final improved = correct > currentBest;
      return lp.copyWith(
        completedLessonIds: {...lp.completedLessonIds, lessonId},
        bestScores: improved ? {...lp.bestScores, lessonId: correct} : lp.bestScores,
        totalExercises: {...lp.totalExercises, lessonId: total},
      );
    }).withActivityToday();
    _persist();
  }

  /// Adaugă puncte din antrenamentul liber (ecranul "Exerciții"), pe categoria de proveniență
  /// a fiecărui exercițiu răspuns corect.
  void recordPracticeResult(LessonLevel level, int correctCount) {
    if (correctCount <= 0) return;
    progress.value = progress.value
        .updateLevel(level, (lp) => lp.copyWith(practicePoints: lp.practicePoints + correctCount * LevelProgress.pointsPerPracticeAnswer))
        .withActivityToday();
    _persist();
  }
}
