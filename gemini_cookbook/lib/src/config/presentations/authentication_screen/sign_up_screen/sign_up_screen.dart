import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/components/custom_textfield.dart';
import 'package:gemini_cookbook/src/config/components/ui_space.dart';
import 'package:gemini_cookbook/src/config/constants/constants.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_up_screen/bloc/sign_up_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_up_screen/bloc/sign_up_event.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_up_screen/bloc/sign_up_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:user_repository/user_repository.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool signUpRequired = false;
  bool obscurePassword = true;
  String? errorMessage;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          signUpRequired = false;
          showDialog<String>(
              builder: (context) => Dialog(
                    child: SingleChildScrollView(
                        child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12, top: 16, bottom: 16, right: 12),
                      child: Text(
                        state.errorMessage
                            .replaceAll(RegExp(r'\[.*?\]\s?'), ''),
                        style: TextStyleConstants.medium,
                      ),
                    )),
                  ),
              context: context);
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
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
                prefixIcon: const Icon(IconConstants.iconMail),
                textEditingController: emailController,
                obscureText: false,
                containerBorderRadius: 8,
                containerColor: Theme.of(context).colorScheme.surface,
                prefixIconColor: Theme.of(context).colorScheme.onSurface,
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
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
                prefixIcon: const Icon(IconConstants.iconPassword),
                textEditingController: passwordController,
                obscureText: obscurePassword,
                containerBorderRadius: 8,
                containerColor: Theme.of(context).colorScheme.surface,
                prefixIconColor: Theme.of(context).colorScheme.onSurface,
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
                suffixIconColor: Theme.of(context).colorScheme.onSurface,
                onChanged: (value) {
                  if (value!.contains(RegExp(r'(?=.*[A-Z])'))) {
                    setState(() {
                      containsUpperCase = true;
                    });
                  } else {
                    setState(() {
                      containsUpperCase = false;
                    });
                  }
                  if (value.contains(RegExp(r'.{8,}$'))) {
                    setState(() {
                      contains8Length = true;
                    });
                  } else {
                    setState(() {
                      contains8Length = false;
                    });
                  }
                  if (value.contains(RegExp(r'(?=.*[a-z])'))) {
                    setState(() {
                      containsLowerCase = true;
                    });
                  } else {
                    setState(() {
                      containsLowerCase = false;
                    });
                  }
                  if (value.contains(RegExp(
                      r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
                    setState(() {
                      containsSpecialChar = true;
                    });
                  } else {
                    setState(() {
                      containsSpecialChar = false;
                    });
                  }
                  if (value.contains(RegExp(r'(?=.*[0-9])'))) {
                    setState(() {
                      containsNumber = true;
                    });
                  } else {
                    setState(() {
                      containsNumber = false;
                    });
                  }
                  return null;
                },
              ),
              const UISpace(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 12.0,
                  runSpacing: 4.0,
                  children: [
                    Text(
                      '⚈ 1 Upper Case',
                      style: containsUpperCase
                          ? TextStyleConstants.validText
                          : TextStyleConstants.invalidText,
                    ),
                    Text(
                      '⚈ 1 Lower Case',
                      style: containsLowerCase
                          ? TextStyleConstants.validText
                          : TextStyleConstants.invalidText,
                    ),
                    Text(
                      '⚈ 1 Number',
                      style: containsNumber
                          ? TextStyleConstants.validText
                          : TextStyleConstants.invalidText,
                    ),
                    Text(
                      '⚈ 1 Special Character',
                      style: containsSpecialChar
                          ? TextStyleConstants.validText
                          : TextStyleConstants.invalidText,
                    ),
                    Text(
                      '⚈ 8 Characters',
                      style: contains8Length
                          ? TextStyleConstants.validText
                          : TextStyleConstants.invalidText,
                    ),
                  ],
                ),
              ),
              const UISpace(height: 10),
              CustomTextField(
                width: MediaQuery.of(context).size.width,
                text: 'Name',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
                prefixIcon: const Icon(IconConstants.iconName),
                textEditingController: nameController,
                obscureText: false,
                containerBorderRadius: 8,
                containerColor: Theme.of(context).colorScheme.surface,
                prefixIconColor: Theme.of(context).colorScheme.onSurface,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                focusNode: nameFocus,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill in this field';
                  } else if (!RegExp(Constants.rejectNameString)
                      .hasMatch(val)) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
                errorMsg: errorMessage,
              ),
              const UISpace(height: 20),
              (!signUpRequired)
                  ? GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          MyUser myUser = MyUser.empty;
                          myUser = myUser.copyWith(
                            email: emailController.value.text,
                            name: nameController.value.text,
                          );
                          context.read<SignUpBloc>().add(SignUpRequired(
                              myUser: myUser,
                              password: passwordController.value.text));
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24))),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        ),
                      ),
                    )
                  : Center(
                      child: LoadingAnimationWidget.discreteCircle(
                        color: Theme.of(context).colorScheme.primary,
                        size: 40,
                      ),
                    ),
            ],
          )),
    );
  }
}
