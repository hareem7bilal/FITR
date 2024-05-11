import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:flutter/material.dart';
import '../../blocs/workout_bloc/workout_bloc.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WhatTrainRow extends StatelessWidget {
  final Map wObj;
  const WhatTrainRow({super.key, required this.wObj});

  @override
  Widget build(BuildContext context) {
   
   
    void deleteWorkout(String workoutId) {
      if (FirebaseAuth.instance.currentUser == null) {
        // Show a SnackBar indicating the user needs to be authenticated
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("You must be logged in to delete workouts.")),
        );
      }
      try {
        // Dispatch the delete event if the user is authenticated
        BlocProvider.of<WorkoutBloc>(context).add(DeleteWorkout(workoutId));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Workout deleted successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete workout: ${e.toString()}")),
        );
      }
    }

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                TColor.primaryColor2.withOpacity(0.3),
                TColor.primaryColor1.withOpacity(0.3)
              ]),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wObj["title"].toString(),
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${wObj["exercises"].toString()} | ${wObj["time"].toString()}",
                        style: TextStyle(
                          color: TColor.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: RoundButton(
                            title: "View More",
                            fontSize: 10,
                            type: RoundButtonType.textGradient,
                            elevation: 0.05,
                            fontWeight: FontWeight.w400,
                            onPressed: () {}),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.54),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        wObj["image"].toString(),
                        width: 90,
                        height: 90,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
           if (!wObj["isStandard"])
          Positioned(
            top: 5,
            right: 5,
            child: SizedBox(
              width: 24, // Set button width
              height: 24, // Set button height
              child: IconButton(
                iconSize: 18, // Set icon size
                padding: EdgeInsets.zero, // Reduce padding for smaller size
                constraints:
                    const BoxConstraints(), // Reduce constraints for minimal size
                icon: const Icon(Icons.close, color: Colors.black26),
                onPressed: () => deleteWorkout(wObj["id"]),
              ),
            ),
          )
        ]));
  }
}
