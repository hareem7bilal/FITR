import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/views/login/goal_view.dart';
import 'package:flutter_application_1/views/login/login_view.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:flutter_application_1/widgets/round_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import '../../blocs/sign_up_bloc/sign_up_bloc.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupView();
}

class _SignupView extends State<SignupView> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Validation logic for email
  bool isValidEmail(String email) {
    return RegExp(r'\S+@\S+\.\S+').hasMatch(email);
  }

  // Validation logic for password
  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  void showValidationError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  void attemptSignUp() {
    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    // Checking if any field is empty
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      showValidationError("Please fill in all fields");
      return; // Stop execution if any field is empty
    }

    // Email validation
    if (!isValidEmail(email)) {
      showValidationError("Please enter a valid email address");
      return; // Stop execution if the email is invalid
    }

    // Password validation
    if (!isValidPassword(password)) {
      showValidationError("Password must be at least 6 characters long");
      return; // Stop execution if the password is invalid
    }

    // If all validations pass, proceed with the sign-up process
    // Here, add your sign-up logic. This example directly navigates after "signing up".
    context.read<SignUpBloc>().add(
          SignUpRequired(
            MyUserModel(
              id: '12', // Assuming 'id' is necessary for your MyUserModel
              firstName: firstName,
              lastName: lastName,
              email: email,
            ),
            password,
          ),
        );

    // After successfully adding the user (assumed), navigate to the LoginView.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GoalView()),
    );
  }

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
                Text(
                  "Hey there,",
                  style: TextStyle(color: TColor.grey, fontSize: 16),
                ),
                Text(
                  "Create an Account",
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
                  keyboardType: TextInputType.emailAddress,
                ),
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
                      ),
                    ),
                  ),
                ),
                SizedBox(height: media.width * 0.08),

                RoundButton(
                  title: "Register",
                  onPressed: attemptSignUp, elevation: 0.0,
                ),

                SizedBox(height: media.width * 0.04),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        height: 1,
                        color: TColor.grey.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      " Or ",
                      style: TextStyle(color: TColor.black, fontSize: 12),
                    ),
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        height: 1,
                        color: TColor.grey.withOpacity(0.5),
                      ),
                    ),
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
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/images/icons/google.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
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
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/images/icons/facebook.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: media.width * 0.04),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: TColor.black, fontSize: 14),
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                // More widgets...
              ],
            ),
          ),
        ),
      ),
    );
  }
}
