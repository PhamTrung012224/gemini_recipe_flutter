import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/components/gradient_text.dart';
import 'package:gemini_cookbook/src/config/constants/constants.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/home_screen_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/home_screen.dart';
import 'package:gemini_cookbook/src/config/themes/color_source.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  void _startTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BlocProvider(
            create: (_) => HomeScreenBloc(), child: const HomeScreen()),
      ));
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/recipeBackground.jpg"),
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
    );
  }
}
