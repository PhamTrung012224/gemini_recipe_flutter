import 'package:flutter/material.dart';
import 'package:gemini_cookbook/src/config/presentations/onboarding_screen/onboarding_screen.dart';
import 'package:gemini_cookbook/src/config/themes/dark_theme.dart';
import 'package:gemini_cookbook/src/config/themes/light_theme.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: LightTheme.themeData,
        darkTheme: DarkTheme.themeData,
        themeMode: ThemeMode.system,
        // home: const RecipeScreen());
        home: const OnBoardingScreen());
        // home: BlocProvider(
        //     create: (_) => HomeScreenBloc(), child: const HomeScreen()));
  }
}
