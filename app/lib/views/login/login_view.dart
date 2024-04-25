import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/views/login/welcome_view.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:flutter_application_1/widgets/round_textfield.dart';
import 'package:flutter_application_1/views/login/signup_view.dart';
import 'forgot_password.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/sign_in_bloc/sign_in_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginView();
}

class _LoginView extends State<LoginView> {
  bool isCheck = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            // Navigate to the next screen after successful sign-in
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeView()),
            );
          } else if (state is SignInProcess) {
            // Handle sign-in process (e.g., show loading indicator)
          } else if (state is SignInFailure) {
            // Handle sign-in failure (e.g., display error message)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sign-in failed. Please try again.'),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Hey there,",
                    style: TextStyle(color: TColor.grey, fontSize: 16),
                  ),
                  Text(
                    "Welcome back",
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        RoundTextField(
                          controller: emailController,
                          hintText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          icon: "assets/images/icons/message.png",
                          // validator: (value) {
                          //   if (value?.isEmpty ?? true) {
                          //     return 'Please enter your email';
                          //   }
                          //   return null;
                          // },
                        ),
                        const SizedBox(height: 20),
                        RoundTextField(
                          controller: passwordController,
                          hintText: "Password",
                          obscureText: true,
                          icon: "assets/images/icons/lock.png",
                          // validator: (value) {
                          //   if (value?.isEmpty ?? true) {
                          //     return 'Please enter your password';
                          //   }
                          //   return null;
                          // },
                        ),
                        const SizedBox(height: 20),
                        RoundButton(
                          title: "Login",
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              // Dispatch SignInRequired event with entered credentials
                              BlocProvider.of<SignInBloc>(context).add(
                                SignInRequired(
                                  emailController.text,
                                  passwordController.text,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 3),
                        TextButton(
                          onPressed: () {
                            // Navigate to Forgot Password screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ForgotPassword()),
                            );
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: TColor.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Navigate to the registration screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupView()),
                      );
                    },
                    child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don't have an account yet? ",
                        style: TextStyle(color: TColor.black, fontSize: 14),
                      ),
                      Text(
                        "Register",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
