import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lottie/lottie.dart';

import '../../components/gradient_text.dart';
import '../../constants/constants.dart';
import '../authentication_screen/authentication_bloc/authentication_bloc.dart';
import '../authentication_screen/sign_in_screen/bloc/sign_in_bloc.dart';
import '../choose_screen/bloc/choose_screen_bloc.dart';
import '../choose_screen/bloc/my_user/my_user_bloc.dart';
import '../choose_screen/bloc/my_user/my_user_event.dart';
import '../choose_screen/bloc/my_user/update_user_image/update_user_image_bloc.dart';
import '../choose_screen/choose_screen.dart';

class GenerateRecipeScreen extends StatefulWidget {
  const GenerateRecipeScreen({super.key});

  @override
  State<GenerateRecipeScreen> createState() => _GenerateRecipeScreenState();
}

class _GenerateRecipeScreenState extends State<GenerateRecipeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GradientText(
          "Let's Make Recipe",
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary
          ]),
          style: TextStyleConstants.tabBarTitle,
        ),
        centerTitle: true,
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                frameRate: const FrameRate(30),
                LottieConstants.makeRecipeAnimation,
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider<SignInBloc>(
                                    create: (context) => SignInBloc(
                                        userRepository: context
                                            .read<AuthenticationBloc>()
                                            .userRepository),
                                  ),
                                  BlocProvider<UpdateUserImageBloc>(
                                    create: (context) => UpdateUserImageBloc(
                                        userRepository: context
                                            .read<AuthenticationBloc>()
                                            .userRepository),
                                  ),
                                  BlocProvider<ChooseScreenBloc>(
                                    create: (context) => ChooseScreenBloc(),
                                  ),
                                  BlocProvider<MyUserBloc>(
                                      create: (context) => MyUserBloc(
                                          userRepository: context
                                              .read<AuthenticationBloc>()
                                              .userRepository)
                                        ..add(GetUserData(
                                            userId: context
                                                .read<AuthenticationBloc>()
                                                .state
                                                .user!
                                                .uid))),
                                ],
                                child: const ChooseScreen(),
                              )));
                    });
                  },
                  child: Text(
                    "Get Started",
                    style: TextStyleConstants.headline1,
                  )),
            ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
