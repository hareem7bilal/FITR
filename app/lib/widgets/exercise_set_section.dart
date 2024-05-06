import 'package:flutter/material.dart';
import 'package:workout_repository/workout_repository.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/widgets/exercises_row.dart';

class ExercisesSetSection extends StatelessWidget {
  final WorkoutSet set;
  final Function(Map obj) onPressed;
  const ExercisesSetSection(
      {super.key, required this.set, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var exercisesArr = set.exercises;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          set.title,
          style: TextStyle(
              color: TColor.black, fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 8,
        ),
        ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: exercisesArr.length,
            itemBuilder: (context, index) {
              var exercise = exercisesArr[index];
              return ExercisesRow(
                exercise: exercise,
                onPressed: () {
                  onPressed(exercise.toMap());
                },
              );
            }),
      ],
    );
  }
}
