import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/constants/constants.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_in_screen/bloc/sign_in_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_in_screen/sign_in_screen.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_up_screen/bloc/sign_up_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_up_screen/sign_up_screen.dart';
import 'package:user_repository/user_repository.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository userRepository;
  const LoginScreen({super.key, required this.userRepository});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void didChangeDependencies() {
    isDarkMode = (Theme.of(context).brightness == Brightness.dark);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      isDarkMode
                          ? ImageConstants.loginDarkBackground
                          : ImageConstants.loginBackground,
                    ),
                    fit: BoxFit.cover)),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40))),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.6,
                    child: Column(
                      children: [
                        TabBar(
                            labelColor: Theme.of(context).colorScheme.primary,
                            indicatorColor:
                                Theme.of(context).colorScheme.primary,
                            unselectedLabelColor:
                                Theme.of(context).colorScheme.onBackground,
                            controller: tabController,
                            tabs: [
                              Text('Sign in',
                                  style: TextStyleConstants.tabBarTitle),
                              Text('Sign up',
                                  style: TextStyleConstants.tabBarTitle)
                            ]),
                        Expanded(
                          child:
                              TabBarView(controller: tabController, children: [
                            BlocProvider(
                              create: (context) => SignInBloc(
                                  userRepository: widget.userRepository),
                              child: const SignInScreen(),
                            ),
                            BlocProvider(
                              create: (context) => SignUpBloc(
                                  userRepository: widget.userRepository),
                              child: const SignUpScreen(),
                            )
                          ]),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
