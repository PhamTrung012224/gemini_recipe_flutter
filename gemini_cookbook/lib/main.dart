import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/authentication_bloc/authentication_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/onboarding_screen/onboarding_screen.dart';
import 'package:gemini_cookbook/src/config/themes/dark_theme.dart';
import 'package:gemini_cookbook/src/config/themes/light_theme.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyA6f5p6KPVxBVdcVQI--meCUnYgbdpQImM',
    appId: '1:812782569235:android:e1deac914b8092bb78bce6',
    messagingSenderId: '812782569235',
    projectId: 'recipe-with-gemini',
    storageBucket: 'recipe-with-gemini.appspot.com',
  ));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  // make flutter draw behind navigation bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(MyApp(FirebaseUserRepository()));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return RepositoryProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(userRepository: userRepository),
        child: MaterialApp(
          theme: LightTheme.themeData,
          darkTheme: DarkTheme.themeData,
          themeMode: ThemeMode.system,
          // home: const RecipeScreen());
          home: const OnBoardingScreen(),
        ));
  }
}
