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
      "title": "Set Rehabilitation Goals",
      "subtitle":
          "Having trouble setting recovery goals? We're here to help you define and track your rehabilitation milestones, ensuring a focused recovery.",
      "image": "assets/images/onboarding/onboarding_1.png"
    },
    {
      "title": "Stay Active",
      "subtitle":
          "Engage in recommended exercises tailored to your recovery needs. It might be challenging, but staying active is key to effective rehabilitation.",
      "image": "assets/images/onboarding/onboarding_2.png"
    },
    {
      "title": "Nutrition for Recovery",
      "subtitle":
          "Fuel your body with the right nutrients to aid in your recovery. Let us help you plan your daily meals for optimal rehabilitation.",
      "image": "assets/images/onboarding/onboarding_3.png"
    },
    {
      "title": "Enhance Recovery Through Sleep",
      "subtitle":
          "Quality sleep is crucial for recovery. We provide tips and habits to improve your sleep, helping you wake up refreshed and ready to heal.",
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
                              duration: const Duration(milliseconds: 450),
                              curve: Curves.bounceInOut);
                          //controller.jumpToPage(selectPage);
                          setState(() {});
                        } else {
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
