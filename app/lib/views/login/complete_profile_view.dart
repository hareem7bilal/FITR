import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/views/login/goal_view.dart';
import 'package:flutter_application_1/widgets/round_textfield.dart';
import 'package:flutter_application_1/widgets/round_button.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  TextEditingController txtDate = TextEditingController();
  TextEditingController txtWeight = TextEditingController();
  TextEditingController txtHeight = TextEditingController();
  String? selectedGender;
  String? dateOfBirth;
  String? weight;
  String? height;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset("images/signup_and_login/complete_profile.png",
                    width: media.width, fit: BoxFit.fitWidth),
                SizedBox(height: media.width * 0.05),
                Text("Lets Complete Your Profile",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700)),
                Text("It will help us know more about you!",
                    style: TextStyle(color: TColor.grey, fontSize: 12)),
                SizedBox(height: media.width * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: TColor.lightGrey,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal:15),
                              width: 20,
                              height: 20,
                              child: Image.asset(
                                "images/icons/gender.png",
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                                color: TColor.grey,
                              ),
                            ),

                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    hint: Text(
                                      "Choose Gender",
                                      style: TextStyle(
                                          color: TColor.grey, fontSize: 12),
                                    ),
                                    isExpanded: true,
                                    items: ["Male", "Female"]
                                        .map((name) => DropdownMenuItem(
                                              value: name,
                                              child: Text(
                                                name,
                                                style: TextStyle(
                                                    color: TColor.grey,
                                                    fontSize: 16),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      selectedGender = value;
                                    }),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                      SizedBox(height: media.width * 0.04),
                      RoundTextField(
                        controller: txtDate,
                        hintText: "Date Of Birth",
                        icon: "images/icons/calender.png",
                        onChanged: (value) {
                          dateOfBirth = value;
                        },
                      ),
                      SizedBox(height: media.width * 0.04),
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              controller: txtWeight,
                              hintText: "Your Weight",
                              icon: "images/icons/weight-scale.png",
                              onChanged: (value) {
                                weight = value;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                              width: 45,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  gradient:
                                      LinearGradient(colors: TColor.primaryG),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text("KG",
                                  style: TextStyle(
                                      color: TColor.white, fontSize: 12)))
                        ],
                      ),
                      SizedBox(height: media.width * 0.04),
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextField(
                              controller: txtHeight,
                              hintText: "Your Height",
                              icon: "images/icons/swap.png",
                              onChanged: (value) {
                                      height = value;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  gradient:
                                      LinearGradient(colors: TColor.primaryG),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text("CM",
                                  style: TextStyle(
                                      color: TColor.white, fontSize: 12)))
                        ],
                      ),
                      SizedBox(height: media.width * 0.07),
                      RoundButton(
                          title: "Next >",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GoalView()));
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
