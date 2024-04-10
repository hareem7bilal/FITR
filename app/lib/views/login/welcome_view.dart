import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/user_bloc/user_bloc.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/views/main-tab/main_tab_view.dart';
import 'package:flutter_application_1/views/login/login_view.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() {
    // Get the current user from Firebase
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      // If no user is signed in, navigate to the login screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      });
    } else {
      // If we have a user, fetch the user data using the UserBloc
      context.read<UserBloc>().add(GetUser(userId: firebaseUser.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Container(
          width: media.width,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                "assets/images/signup_and_login/welcome.png",
                width: media.width * 0.7,
                fit: BoxFit.contain,
              ),
              SizedBox(height: media.width * 0.05),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  String welcomeMessage = "Welcome!";

                  if (state.status == UserStatus.success &&
                      state.user != null) {
                    welcomeMessage = "Welcome, ${state.user!.firstName}!";
                  }

                  return Text(
                    welcomeMessage,
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
              Text(
                "You are all set up now, let's reach your goals together!",
                style: TextStyle(color: TColor.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              RoundButton(
                title: "Go To Home",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainTabView()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
