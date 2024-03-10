import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:flutter_application_1/widgets/round_textfield.dart';
import 'package:flutter_application_1/views/login/signin_view.dart';
import 'package:flutter_application_1/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:user_repository/user_repository.dart';


class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupView();
}

class _SignupView extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool signUpRequired = false;
  bool isCheck = false;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return BlocListener<SignUpBloc, SignUpState>(
			listener: (context, state) {
				if(state is SignUpSuccess) {
					setState(() {
					  signUpRequired = false;
					});
				} else if(state is SignUpProcess) {
					setState(() {
					  signUpRequired = true;
					});
				} else if(state is SignUpFailure) {
					return;
				} 
			},
			child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Hey there,",
                style: TextStyle(color: TColor.grey, fontSize: 16)),
            Text("Create an awesome Account",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            SizedBox(height: media.width * 0.05),
            RoundTextField(
              controller: firstNameController,
              hintText: "First Name",
              icon: "assets/images/icons/profile.png",
            ),
            SizedBox(height: media.width * 0.04),
            RoundTextField(
              controller: lastNameController,
              hintText: "Last Name",
              icon: "assets/images/icons/profile.png",
            ),
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
            !signUpRequired
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      MyUserModel myUser = MyUserModel.empty;
                      myUser = myUser.copyWith(
                        email: emailController.text,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                      );

                      setState(() {
                        context.read<SignUpBloc>().add(
                          SignUpRequired(
                            myUser,
                            passwordController.text
                          )
                        );
                      });																			
                    }
                  },
                  style: TextButton.styleFrom(
                    elevation: 3.0,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60)
                    )
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  )
                ),
              )
            : const CircularProgressIndicator(),
            // RoundButton(title: "Register", onPressed: () {}),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SigninView()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Already have an account? ",
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
    );
  }
}
