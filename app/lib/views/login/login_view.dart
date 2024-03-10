import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/views/login/complete_profile_view.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:flutter_application_1/widgets/round_textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginView();
}

class _LoginView extends State<LoginView> {
  bool isCheck = false;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: TColor.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              height: media.height,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Hey there,",
                      style: TextStyle(color: TColor.grey, fontSize: 16)),
                  Text("Welcome back",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: media.width * 0.05),
                  const RoundTextField(
                      hintText: "Email",
                      icon: "images/icons/message.png",
                      keyboardType: TextInputType.emailAddress),
                  SizedBox(height: media.width * 0.04),
                  RoundTextField(
                      hintText: "Password",
                      icon: "images/icons/lock.png",
                      obscureText: true,
                      rightIcon: TextButton(
                        onPressed: () {},
                        child: Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            child: Image.asset(
                              "images/icons/hide.png",
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                              color: TColor.grey,
                            )),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Text(
                                "Forgot your password?",
                                style: TextStyle(color: TColor.grey, fontSize: 10, 
                                decoration: TextDecoration.underline)),
                    ),
                        
                    ],
                  ),
                  SizedBox(height: media.width * 0.1),
                  RoundButton(
                      title: "Login",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CompleteProfileView()));
                      }),
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
                            child: Image.asset("assets/images/icons/google.png",
                                width: 20, height: 20),
                          )),
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
                            child: Image.asset(
                                "assets/images/icons/facebook.png",
                                width: 20,
                                height: 20),
                          ))
                    ],
                  ),
                  SizedBox(height: media.width * 0.04),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Don't have an account yet? ",
                              style:
                                  TextStyle(color: TColor.black, fontSize: 14)),
                          Text("Register",
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
