import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/login/signup_view.dart';
import 'package:flutter_application_1/widgets/onboarding_page.dart';
import '../../utils/color_extension.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => OnBoardingViewState();
}

class OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      selectPage = controller.page?.round() ?? 0;
      setState(() {});
    });
  }

  List pageArr = [
    {
      "title": "Track Your Goals",
      "subtitle":
          "Dont worry if you have trouble determining your goals, we can help you determine and track them!",
      "image": "assets/images/onboarding/onboarding_1.png"
    },
    {
      "title": "Get Burn",
      "subtitle":
          "Let’s keep burning, to achive yours goals, it hurts only temporarily, if you give up now you will be in pain forever",
      "image": "assets/images/onboarding/onboarding_2.png"
    },
    {
      "title": "Eat Well",
      "subtitle":
          "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
      "image": "assets/images/onboarding/onboarding_3.png"
    },
    {
      "title": "Improve Sleep Quality",
      "subtitle":
          "Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning",
      "image": "assets/images/onboarding/onboarding_4.png"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: TColor.white,
        body: Stack(alignment: Alignment.bottomRight, children: [
          PageView.builder(
              controller: controller,
              itemCount: pageArr.length,
              itemBuilder: (context, index) {
                var pObj = pageArr[index] as Map? ?? {};
                return OnboardingPage(pObj: pObj);
              }),
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    color: TColor.primaryColor1,
                    value: (selectPage + 1) / 4,
                    strokeWidth: 2,
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(25),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: TColor.primaryColor1,
                        borderRadius: BorderRadius.circular(35)),
                    child: IconButton(
                      icon: Icon(Icons.navigate_next, color: TColor.white),
                      onPressed: () {
                        if (selectPage < 3) {
                          selectPage = selectPage + 1;
                          controller.animateToPage(selectPage,
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.bounceInOut);
                          //controller.jumpToPage(selectPage);
                          setState(() {});
                        } else {
                          //open welcome screen
                          print("Open Welcome Screen");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupView()));
                        }
                      },
                    )),
              ],
            ),
          )
        ]));
  }
}
