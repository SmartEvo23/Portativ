import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/music/staff_widget.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/exercise_model.dart';

/// Derulează o listă de exerciții grilă, unul câte unul, cu feedback imediat
/// și un scor final. Poate fi reutilizat atât în interiorul unei lecții, cât
/// și în ecranul de antrenament liber.
class ExerciseQuiz extends StatefulWidget {
  const ExerciseQuiz({super.key, required this.exercises, required this.onFinished});

  final List<ExerciseModel> exercises;

  /// Apelat când chestionarul se termină (fie normal, fie prin ieșire timpurie),
  /// cu lista răspunsurilor date, în ordine (true = corect).
  final void Function(List<bool> correctness) onFinished;

  @override
  State<ExerciseQuiz> createState() => _ExerciseQuizState();
}

class _ExerciseQuizState extends State<ExerciseQuiz> {
  int _index = 0;
  int _score = 0;
  int? _selectedOption;
  final List<bool> _correctness = [];

  ExerciseModel get _current => widget.exercises[_index];

  void _selectOption(int optionIndex) {
    if (_selectedOption != null) return;
    setState(() {
      _selectedOption = optionIndex;
      final isCorrect = _current.options[optionIndex].isCorrect;
      if (isCorrect) _score++;
      _correctness.add(isCorrect);
    });
  }

  void _next() {
    if (_index == widget.exercises.length - 1) {
      _showSummary();
      return;
    }
    setState(() {
      _index++;
      _selectedOption = null;
    });
  }

  void _finish() => widget.onFinished(List<bool>.from(_correctness));

  void _showSummary() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Gata!'),
        content: Text('Ai răspuns corect la $_score din ${widget.exercises.length} exerciții.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _finish();
            },
            child: const Text('Închide'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercise = _current;
    final bool answered = _selectedOption != null;

    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Exercițiul ${_index + 1}/${widget.exercises.length}', style: Theme.of(context).textTheme.labelLarge),
              IconButton(onPressed: _finish, icon: const Icon(Iconsax.close_circle)),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          if (exercise.notePosition != null) ...[
            StaffWidget(notePositions: [exercise.notePosition!], height: 140),
            const SizedBox(height: TSizes.spaceBtwItems),
          ],
          Text(exercise.question, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwSections),
          Expanded(
            child: ListView.separated(
              itemCount: exercise.options.length,
              separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
              itemBuilder: (context, i) {
                final option = exercise.options[i];
                Color? backgroundColor;
                Color? borderColor = TColors.borderPrimary;
                if (answered) {
                  if (option.isCorrect) {
                    backgroundColor = TColors.success.withOpacity(0.12);
                    borderColor = TColors.success;
                  } else if (i == _selectedOption) {
                    backgroundColor = TColors.error.withOpacity(0.12);
                    borderColor = TColors.error;
                  }
                }
                return InkWell(
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                  onTap: () => _selectOption(i),
                  child: Container(
                    padding: const EdgeInsets.all(TSizes.md),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(color: borderColor!),
                      borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(option.text, style: Theme.of(context).textTheme.bodyLarge)),
                        if (answered && option.isCorrect) const Icon(Iconsax.tick_circle, color: TColors.success),
                        if (answered && !option.isCorrect && i == _selectedOption)
                          const Icon(Iconsax.close_circle, color: TColors.error),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (answered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(backgroundColor: TColors.primary, foregroundColor: TColors.white),
                child: Text(_index == widget.exercises.length - 1 ? 'Termină' : 'Continuă'),
              ),
            ),
        ],
      ),
    );
  }
}
