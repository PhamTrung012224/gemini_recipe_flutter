import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/components/custom_textfield.dart';
import 'package:gemini_cookbook/src/config/components/ui_space.dart';
import 'package:gemini_cookbook/src/config/constants/constants.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_in_screen/bloc/sign_in_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_in_screen/bloc/sign_in_event.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_in_screen/bloc/sign_in_state.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/home_screen_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  bool obscurePassword = true;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          setState(() {
            signInRequired = false;
          });
        } else if (state is SignInProcess) {
          setState(() {
            signInRequired = true;
          });
        } else if (state is SignInFailure) {
          setState(() {
            signInRequired = false;
            errorMessage = 'Invalid email or password';
          });
        }
      },
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              const UISpace(height: 16),
              CustomTextField(
                width: MediaQuery.of(context).size.width,
                text: 'Email',
                style: TextStyleConstants.inputText,
                prefixIcon: const Icon(IconConstants.iconMail),
                textEditingController: emailController,
                obscureText: false,
                containerBorderRadius: 8,
                containerColor: Colors.white,
                prefixIconColor: Colors.black54,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                focusNode: emailFocus,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill in this field';
                  } else if (!RegExp(Constants.rejectEmailString)
                      .hasMatch(val)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                errorMsg: errorMessage,
              ),
              const UISpace(height: 16),
              CustomTextField(
                width: MediaQuery.of(context).size.width,
                text: 'Password',
                style: TextStyleConstants.inputText,
                prefixIcon: const Icon(IconConstants.iconPassword),
                textEditingController: passwordController,
                obscureText: obscurePassword,
                containerBorderRadius: 8,
                containerColor: Colors.white,
                prefixIconColor: Colors.black54,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                focusNode: passwordFocus,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill in this field';
                  } else if (!RegExp(Constants.rejectPasswordString)
                      .hasMatch(val)) {
                    return 'Please enter a valid password';
                  }
                  return null;
                },
                errorMsg: errorMessage,
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    child: Icon(obscurePassword
                        ? IconConstants.iconHidePassword
                        : IconConstants.iconShowPassword)),
                suffixIconColor: Colors.black54,
              ),
              const UISpace(height: 20),
              (!signInRequired)
                  ? GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<SignInBloc>().add(SignInRequired(email: emailController.value.text, password: passwordController.value.text));
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24))),
                        child: Text(
                          'Sign in',
                          style: TextStyleConstants.loginButtonTitle,
                        ),
                      ),
                    )
                  : const CircularProgressIndicator(),
            ],
          )),
    );
  }
}
