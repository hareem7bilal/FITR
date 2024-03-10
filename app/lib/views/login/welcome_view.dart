import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/widgets/round_button.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
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
                Image.asset("images/signup_and_login/welcome.png",
                      width: media.width*0.7, fit: BoxFit.contain,),
                  SizedBox(height: media.width * 0.05),
                  Text("Welcome, Stefani!",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  Text("You are all set up now, let's reach your\n goals together!",
                      style: TextStyle(color: TColor.grey, fontSize: 12), textAlign: TextAlign.center,),
                  const Spacer(),
                  
                  RoundButton(
                    title: "Go To Home",
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const WelcomeView()));
                    }),
              ],
            ),
          ),
        ),
    );
  }
}