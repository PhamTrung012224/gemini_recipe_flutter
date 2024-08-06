import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/authentication_bloc/authentication_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_in_screen/bloc/sign_in_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/main_screen/my_user/my_user_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/main_screen/my_user/my_user_event.dart';
import 'package:gemini_cookbook/src/config/presentations/main_screen/my_user/update_user_image/update_user_profile_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/onboarding_screen/onboarding_screen.dart';
import 'package:gemini_cookbook/src/config/themes/bloc/theme_mode_bloc.dart';
import 'package:gemini_cookbook/src/config/themes/bloc/theme_mode_state.dart';
import 'package:gemini_cookbook/src/config/themes/dark_theme.dart';
import 'package:gemini_cookbook/src/config/themes/light_theme.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: String.fromEnvironment('FIREBASE_KEY'),
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
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ThemeModeBloc(),
            ),
            BlocProvider<SignInBloc>(
              create: (context) => SignInBloc(
                  userRepository:
                  context.read<AuthenticationBloc>().userRepository),
            ),
            BlocProvider<UpdateUserProfileBloc>(
              create: (context) => UpdateUserProfileBloc(
                  userRepository:
                  context.read<AuthenticationBloc>().userRepository),
            ),
            BlocProvider<MyUserBloc>(
                create: (context) => MyUserBloc(
                    userRepository:
                    context.read<AuthenticationBloc>().userRepository)
                  ..add(GetUserData(
                      userId: context
                          .read<AuthenticationBloc>()
                          .state
                          .user!
                          .uid))),
          ],
          child: BlocBuilder<ThemeModeBloc, ThemeModeState>(
            builder: (context, state) {
              return MaterialApp(
                theme: LightTheme.themeData,
                darkTheme: DarkTheme.themeData,
                themeMode: state.isOnSwitch ? ThemeMode.dark : ThemeMode.light,
                // home: const RecipeScreen());
                home: const OnBoardingScreen(),
              );
            },
          ),
        ));
  }
}
