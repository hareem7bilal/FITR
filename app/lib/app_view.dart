import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
//import 'package:flutter_application_1/views/yt.dart';
//import 'package:flutter_application_1/views/instability_assessment.dart';
//import 'package:flutter_application_1/views/pose.dart';
//import 'package:flutter_application_1/views/main-tab/main_tab_view.dart';
//import 'package:flutter_application_1/views/onboarding/starting_view.dart';
import 'package:flutter_application_1/views/workout-tracker/workout_schedule_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Fitness Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins",
        scaffoldBackgroundColor: Colors.white,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            //return const StartingView();
            return const WorkoutScheduleView();
          } else {
            //return const YTView();
            return const WorkoutScheduleView();
            //return const InstabilityDetector();
            //return const PoseDetector();
          }
        },
      ),

      //const SignupView(),
    );
  }
}
