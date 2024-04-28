import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/views/onboarding/onboarding_view.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:flutter_tts/flutter_tts.dart';

class StartingView extends StatefulWidget {
  const StartingView({super.key});

  @override
  State<StartingView> createState() => StartingViewState();
}

class StartingViewState extends State<StartingView> {
  bool isChangeColor = true;
  FlutterTts tts = FlutterTts();

   @override
  void initState() {
    super.initState();
    speakAppDescription();
  }

  Future<void> speakAppDescription() async {
    await tts.setLanguage("en-UK");
 
    await tts.setPitch(1);
    await tts.speak("Welcome to FITR! Your journey from Injury to Rehab starts here.");
  }
  
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: Container(
        width: media.width,
        decoration: BoxDecoration(
            gradient: isChangeColor
                ? LinearGradient(
                    colors: TColor.primaryG,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)
                : null),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text("FITR",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 50,
                    fontWeight: FontWeight.w700)),
            Text("From Injury To Rehab",
                style: TextStyle(
                  color: TColor.lightGrey,
                  fontSize: 18,
                )),
            const Spacer(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: RoundButton(
                    title: "Get Started",
                    onPressed: () {
                      if (isChangeColor) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OnBoardingView()));
                      } else {
                        setState(() {
                          isChangeColor = true;
                        });
                      }
                    },
                    type: isChangeColor
                        ? RoundButtonType.textGradient
                        : RoundButtonType.bgGradient, elevation: 0.0,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
