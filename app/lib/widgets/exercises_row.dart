import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:workout_repository/workout_repository.dart';

class ExercisesRow extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onPressed;
  const ExercisesRow({super.key, required this.exercise, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              exercise.image!.isEmpty
                  ? 'assets/images/training/default.png'
                  : exercise.image!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                // Check if 'duration' exists and display it
                if (exercise.duration!.isNotEmpty)
                  Text(
                    'Duration: ${exercise.duration}',
                    style: TextStyle(
                      color: TColor.grey,
                      fontSize: 12,
                    ),
                  ),
                // Check if 'repetitions' exists and display it
                if (exercise.repetitions!= null && exercise.repetitions! > 0)
                  Text(
                    'Repetitions: ${exercise.repetitions}',
                    style: TextStyle(
                      color: TColor.grey,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
              onPressed: onPressed,
              icon: Image.asset(
                "assets/images/icons/next_go.png",
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ))
        ],
      ),
    );
  }
}
