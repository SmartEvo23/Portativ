import 'exercise_model.dart';
import 'lesson_level.dart';
import 'lesson_module.dart';

/// O lecție de teoria muzicii: câteva paragrafe de explicație, urmate de exerciții.
class LessonModel {
  const LessonModel({
    required this.id,
    required this.level,
    this.module = LessonModule.teorieDeBaza,
    required this.title,
    required this.summary,
    required this.content,
    this.exercises = const [],
    this.showcaseNotePositions = const [],
  });

  final String id;
  final LessonLevel level;

  /// Marea temă din care face parte lecția (Ritm, Instrumente, etc.).
  final LessonModule module;
  final String title;
  final String summary;

  /// Paragrafele de explicație ale lecției, afișate în ordine.
  final List<String> content;

  final List<ExerciseModel> exercises;

  /// Notele afișate pe portativul ilustrativ din capul lecției (opțional).
  final List<int> showcaseNotePositions;
}
