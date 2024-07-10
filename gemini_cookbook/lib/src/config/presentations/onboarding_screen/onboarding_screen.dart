import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/components/gradient_text.dart';
import 'package:gemini_cookbook/src/config/constants/constants.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/authentication_bloc/authentication_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/authentication_bloc/authentication_state.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_in_screen/bloc/sign_in_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/home_screen_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/home_screen.dart';
import 'package:gemini_cookbook/src/config/themes/color_source.dart';
import '../authentication_screen/login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            body: Stack(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageConstants.onBoardingBackground),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GradientText(
                          'Gemini',
                          style: TextStyleConstants.onBoardingTitle,
                          gradient: const LinearGradient(colors: [
                            ColorConstants.gradientBlue,
                            ColorConstants.gradientOrange
                          ]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 32),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GradientText(
                          'Recipe',
                          style: TextStyleConstants.onBoardingTitle,
                          gradient: const LinearGradient(colors: [
                            ColorConstants.gradientOrange,
                            ColorConstants.gradientBlue
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              Future.delayed(const Duration(seconds: 3));
          if (state.status == AuthenticationStatus.authenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<SignInBloc>(
                  create: (_) => SignInBloc(
                      userRepository:
                          context.read<AuthenticationBloc>().userRepository),
                ),
                BlocProvider<HomeScreenBloc>(
                  create: (_) => HomeScreenBloc(),
                ),
              ],
              child: const HomeScreen(),
            );
          } else {
            return LoginScreen(
                userRepository:
                    context.read<AuthenticationBloc>().userRepository);
          }
        })
      ],
    );
  }
}
