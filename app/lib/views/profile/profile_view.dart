import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:flutter_application_1/views/profile/complete_profile_view.dart';
import 'package:flutter_application_1/widgets/setting_row.dart';
import 'package:flutter_application_1/widgets/title_subtitle_cell.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/views/login/login_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/user_bloc/user_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    fetchCurrentUserData();
  }

  bool positive = false;

  void togglePositive() {
    setState(() {
      positive = !positive;
    });
  }

  void fetchCurrentUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // If we have a user, fetch the user data using the UserBloc
      BlocProvider.of<UserBloc>(context).add(GetUser(userId: user.uid));
    } else {
      // If no user is signed in, navigate to the login screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: TColor.white,
          centerTitle: true,
          elevation: 0,
          leadingWidth: 0,
          title: Text(
            "Profile",
            style: TextStyle(
                color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          actions: [
            InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(8),
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: TColor.lightGrey,
                    borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  "images/buttons/more_btn.png",
                  width: 15,
                  height: 15,
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
        backgroundColor: TColor.white,
        body: SingleChildScrollView(child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state.status == UserStatus.success && state.user != null) {
              final user = state.user!;
              // Convert each property to a string, using 'toString()' and ensure null safety with '??'
              final String name = "${user.firstName} ${user.lastName}";
              final String height = user.height?.toString() ?? "not specified";
              final String weight = user.weight?.toString() ?? "not specified";
              String age = "not specified";

              // Check if dob is not null before calculating age.
              if (user.dob != null) {
                DateTime dob = user
                    .dob!; // Use the actual DOB field from your user model, now safely unwrapped.
                age = calculateAge(dob);
              }
              return buildUserProfile(context, name, height, weight, age, positive, togglePositive);
            }
            return const Center(child: CircularProgressIndicator());
          },
        )));
  }
}

// Utility function to calculate age from DOB.
String calculateAge(DateTime dob) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - dob.year;
  if (currentDate.month < dob.month ||
      (currentDate.month == dob.month && currentDate.day < dob.day)) {
    age--;
  }
  return age.toString();
}

Widget buildUserProfile(BuildContext context, String name, String height,
    String weight, String age, bool positive, void Function() togglePositive) {

  List accountArr = [
    {"image": "images/icons/profile.png", "name": "Personal Data", "tag": "1"},
    {
      "image": "images/icons/achievement.png",
      "name": "Achievement",
      "tag": "2"
    },
    {
      "image": "images/icons/activity_history.png",
      "name": "Activity History",
      "tag": "3"
    },
    {
      "image": "images/icons/workout_progress.png",
      "name": "Workout Progress",
      "tag": "4"
    }
  ];

  List otherArr = [
    {"image": "images/icons/email.png", "name": "Contact Us", "tag": "5"},
    {
      "image": "images/icons/privacy_policy.png",
      "name": "Privacy Policy",
      "tag": "6"
    },
    {"image": "images/icons/settings.png", "name": "Settings", "tag": "7"},
  ];

  return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset("images/pics/blank_avatar.png",
                    width: 50, height: 50, fit: BoxFit.cover)),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Text("Rehabilitation Program",
                    style: TextStyle(
                      color: TColor.grey,
                      fontSize: 12,
                    ))
              ],
            )),
            SizedBox(
              width: 70,
              height: 25,
              child: RoundButton(
                title: "Edit",
                type: RoundButtonType.bgGradient,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CompleteProfileView(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
                child: TitleSubtitleCell(title: height, subtitle: "Height")),
            const SizedBox(width: 15),
            Expanded(
                child: TitleSubtitleCell(title: weight, subtitle: "Weight")),
            const SizedBox(width: 15),
            Expanded(child: TitleSubtitleCell(title: age, subtitle: "Age")),
          ],
        ),
        const SizedBox(height: 25),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 2)
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Account",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: accountArr.length,
                  itemBuilder: (context, index) {
                    var iObj = accountArr[index] as Map? ?? {};
                    return SettingRow(
                        icon: iObj["image"].toString(),
                        title: iObj["name"].toString(),
                        onPressed: () {});
                  })
            ])),
        const SizedBox(height: 25),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 2)
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Notifications",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              SizedBox(
                height: 30,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/icons/notification.png",
                        width: 15,
                        height: 15,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        child: Text("Pop-up Notifications",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 12,
                            )),
                      ),
                      CustomAnimatedToggleSwitch<bool>(
                        current: positive,
                        values: const [false, true],
                        spacing: 0.0,
                        indicatorSize: const Size.square(30.0),
                        animationDuration: const Duration(milliseconds: 200),
                        animationCurve: Curves.linear,
                        onChanged: (b) => togglePositive(),
                        iconBuilder: (context, local, global) {
                          return const SizedBox();
                        },
                        cursors: const ToggleCursors(
                            defaultCursor: SystemMouseCursors.click),
                        onTap: (_) => togglePositive(),
                        iconsTappable: false,
                        wrapperBuilder: (context, global, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                  left: 10.0,
                                  right: 10.0,
                                  height: 30.0,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: TColor.secondaryG),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50.0)),
                                    ),
                                  )),
                              child,
                            ],
                          );
                        },
                        foregroundIndicatorBuilder: (context, global) {
                          return SizedBox.fromSize(
                            size: const Size(10, 10),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: TColor.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(50.0)),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black38,
                                      spreadRadius: 0.05,
                                      blurRadius: 1.1,
                                      offset: Offset(0.0, 0.8))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ]),
              ),
            ])),
        const SizedBox(height: 25),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 2)
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Other",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: otherArr.length,
                  itemBuilder: (context, index) {
                    var iObj = otherArr[index] as Map? ?? {};
                    return SettingRow(
                        icon: iObj["image"].toString(),
                        title: iObj["name"].toString(),
                        onPressed: () {});
                  })
            ])),
      ]));
}
