import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/widgets/round_button.dart';

class FinishedWorkoutView extends StatefulWidget {
  const FinishedWorkoutView({super.key});

  @override
  State<FinishedWorkoutView> createState() => _FinishedWorkoutViewState();
}

class _FinishedWorkoutViewState extends State<FinishedWorkoutView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    // Wrap everything in a SingleChildScrollView
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  "assets/images/signup_and_login/complete_workout.png",
                  height: media.width * 0.8,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(height: 20),
                Text(
                  "Congratulations, You Have Finished Your Workout",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Exercises is king and nutrition is queen. Combine the two and you will have a kingdom",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "-Jack Lalanne",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 30), // Adjust the spacing as needed
                RoundButton(
                  title: "Back To Home",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 20), // Adjust the spacing as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
