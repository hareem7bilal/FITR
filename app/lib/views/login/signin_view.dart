import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:flutter_application_1/widgets/round_textfield.dart';
import 'package:flutter_application_1/views/login/signup_view.dart';
import 'package:flutter_application_1/blocs/sign_in_bloc/sign_in_bloc.dart';


class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninView();
}

class _SigninView extends State<SigninView> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool signInRequired = false;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if(state is SignInSuccess) {
					setState(() {
					  signInRequired = false;
					});
				} else if(state is SignInProcess) {
					setState(() {
					  signInRequired = true;
					});
				} else if(state is SignInFailure) {
					setState(() {
					  signInRequired = false;
					});
				}
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome Back,",
                style: TextStyle(color: TColor.grey, fontSize: 16)),
            Text("Sign in Account",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            // SizedBox(height: media.width * 0.05),
            // const RoundTextField(
            //   hintText: "First Name",
            //   icon: "assets/images/icons/profile.png",
            // ),
            // SizedBox(height: media.width * 0.04),
            // const RoundTextField(
            //   hintText: "Last Name",
            //   icon: "assets/images/icons/profile.png",
            // ),
            SizedBox(height: media.width * 0.04),
            RoundTextField(
                controller: emailController,
                hintText: "Email",
                icon: "assets/images/icons/message.png",
                keyboardType: TextInputType.emailAddress),
            SizedBox(height: media.width * 0.04),
            RoundTextField(
                controller: passwordController,
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
            // Row(
              //crossAxisAlignment: CrossAxisAlignment.start,
              // children: [
                // IconButton(
                //     onPressed: () {
                //       setState(() {
                //         isCheck = !isCheck;
                //       });
                //     },
                //     icon: Icon(
                //         isCheck
                //             ? Icons.check_box_outlined
                //             : Icons.check_box_outline_blank_outlined,
                //         color: TColor.grey,
                //         size: 20)),
                // Expanded(
                //   child: Text(
                //       "By continuing you accept our privacy policy and\nterms of use",
                //       style: TextStyle(color: TColor.grey, fontSize: 10)),
                // ),
            //   ],
            // ),
            SizedBox(height: media.width * 0.08),
            !signInRequired
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SignInBloc>().add(SignInRequired(
                            emailController.text,
                            passwordController.text));
                      }
                    },
                    style: TextButton.styleFrom(
                        elevation: 3.0,
                        backgroundColor:
                            Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60))),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      child: Text(
                        'Sign In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    )),
              )
            : const CircularProgressIndicator(),
            // RoundButton(title: "Log in", onPressed: () {}) 
            // SizedBox(height: media.width * 0.04),
            // Row(
            //   children: [
            //     Expanded(
            //         child: Container(
            //             width: double.maxFinite,
            //             height: 1,
            //             color: TColor.grey.withOpacity(0.5))),
            //     Text(" Or ",
            //         style: TextStyle(color: TColor.black, fontSize: 12)),
            //     Expanded(
            //         child: Container(
            //             width: double.maxFinite,
            //             height: 1,
            //             color: TColor.grey.withOpacity(0.5))),
            //   ],
            // ),
            // SizedBox(height: media.width * 0.04),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     GestureDetector(
            //         onTap: () {},
            //         child: Container(
            //           width: 50,
            //           height: 50,
            //           alignment: Alignment.center,
            //           decoration: BoxDecoration(
            //               color: TColor.white,
            //               border: Border.all(
            //                 width: 1,
            //                 color: TColor.grey.withOpacity(0.4),
            //               ),
            //               borderRadius: BorderRadius.circular(15)),
            //               child: Image.asset("assets/images/icons/google.png", width: 20, height:20),

            //         )
            //         ),

            //         SizedBox(width: media.width * 0.04),

            //         GestureDetector(
            //         onTap: () {},
            //         child: Container(
            //           width: 50,
            //           height: 50,
            //           alignment: Alignment.center,
            //           decoration: BoxDecoration(
            //               color: TColor.white,
            //               border: Border.all(
            //                 width: 1,
            //                 color: TColor.grey.withOpacity(0.4),
            //               ),
            //               borderRadius: BorderRadius.circular(15)),
            //               child: Image.asset("assets/images/icons/facebook.png", width: 20, height:20),

            //         )
            //         )
            //   ],
            // ),
            SizedBox(height: media.width * 0.04),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupView()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Don't have an account? ",
                        style:
                            TextStyle(color: TColor.black, fontSize: 14)),
                    Text("Create Account",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                  ],
                )),
          ],
        )),
        );
  }
}
