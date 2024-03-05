import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:flutter_application_1/widgets/round_textfield.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupView();
}

class _SignupView extends State<SignupView> {
  bool isCheck = false;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: TColor.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Hey there,",
                      style: TextStyle(color: TColor.grey, fontSize: 16)),
                  Text("Create an Account",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: media.width * 0.05),
                  const RoundTextField(
                    hintText: "First Name",
                    icon: "assets/images/icons/profile.png",
                  ),
                  SizedBox(height: media.width * 0.04),
                  const RoundTextField(
                    hintText: "Last Name",
                    icon: "assets/images/icons/profile.png",
                  ),
                  SizedBox(height: media.width * 0.04),
                  const RoundTextField(
                      hintText: "Email",
                      icon: "assets/images/icons/message.png",
                      keyboardType: TextInputType.emailAddress),
                  SizedBox(height: media.width * 0.04),
                  RoundTextField(
                      hintText: "Password",
                      icon: "assets/images/icons/lock.png",
                      obscureText: true,
                      rightIcon: TextButton(
                        onPressed: () {},
                        child: Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/images/icons/hide.png",
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                              color: TColor.grey,
                            )),
                      )),
                  Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isCheck = !isCheck;
                            });
                          },
                          icon: Icon(
                              isCheck
                                  ? Icons.check_box_outlined
                                  : Icons.check_box_outline_blank_outlined,
                              color: TColor.grey,
                              size: 20)),
                      Expanded(
                        child: Text(
                            "By continuing you accept our privacy policy and\nterms of use",
                            style: TextStyle(color: TColor.grey, fontSize: 10)),
                      ),
                    ],
                  ),
                  SizedBox(height: media.width * 0.08),
                  RoundButton(title: "Register", onPressed: () {}),
                  SizedBox(height: media.width * 0.04),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              width: double.maxFinite,
                              height: 1,
                              color: TColor.grey.withOpacity(0.5))),
                      Text(" Or ",
                          style: TextStyle(color: TColor.black, fontSize: 12)),
                      Expanded(
                          child: Container(
                              width: double.maxFinite,
                              height: 1,
                              color: TColor.grey.withOpacity(0.5))),
                    ],
                  ),
                  SizedBox(height: media.width * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: TColor.white,
                                border: Border.all(
                                  width: 1,
                                  color: TColor.grey.withOpacity(0.4),
                                ),
                                borderRadius: BorderRadius.circular(15)),
                                child: Image.asset("assets/images/icons/google.png", width: 20, height:20),

                          )
                          ),

                          SizedBox(width: media.width * 0.04),

                          GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: TColor.white,
                                border: Border.all(
                                  width: 1,
                                  color: TColor.grey.withOpacity(0.4),
                                ),
                                borderRadius: BorderRadius.circular(15)),
                                child: Image.asset("assets/images/icons/facebook.png", width: 20, height:20),

                          )
                          )
                    ],
                  ),
                  SizedBox(height: media.width * 0.04),
                  TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Already have an account?",
                              style:
                                  TextStyle(color: TColor.black, fontSize: 14)),
                          Text("Login",
                              style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
