import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/components/gradient_text.dart';
import 'package:gemini_cookbook/src/config/constants/constants.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/authentication_bloc/authentication_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/authentication_bloc/authentication_state.dart';
import 'package:gemini_cookbook/src/config/presentations/main_screen/main_screen.dart';
import 'package:gemini_cookbook/src/config/themes/color_source.dart';
import '../authentication_screen/login_screen.dart';
import '../choose_screen/bloc/choose_screen_bloc.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool showOnboarding = true;
  BuildContext? _context;

  @override
  void initState() {
    super.initState();
    // Automatically hide the onboarding screen after 3 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showOnboarding = false;
        });
      }
    });
  }

  @override
  didChangeDependencies() {
    _context = context;
    preloadImages();
    super.didChangeDependencies();
  }

  Future<void> preloadImages() async {
    await precacheImage(
            const AssetImage(ImageConstants.loginBackground), _context!)
        .catchError((error) {
      log('Error preloading image: $error');
    });

    await precacheImage(
            const AssetImage(ImageConstants.loginDarkBackground), _context!)
        .catchError((error) {
      log('Error preloading image: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
            SafeArea(
              child: SizedBox(
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
              ),
            )
          ]),
        ),
        if (!showOnboarding)
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return BlocProvider<ChooseScreenBloc>(
                create: (context) => ChooseScreenBloc(),
                child: MainScreen(
                  userId: context.read<AuthenticationBloc>().state.user!.uid,
                ),
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

  @override
  void dispose() {
    _context = null;
    super.dispose();
  }
}
