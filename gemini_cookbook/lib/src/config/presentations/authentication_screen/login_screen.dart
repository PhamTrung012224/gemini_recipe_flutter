import 'package:flutter/cupertino.dart';
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

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height:MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      ImageConstants.loginBackground,
                    ),
                    fit: BoxFit.cover)),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.6,
                  child: Column(
                    children: [
                      TabBar(
                          labelColor: Colors.tealAccent,
                          indicatorColor: Colors.tealAccent,
                          unselectedLabelColor: Colors.white70,
                          controller: tabController,
                          tabs: [
                            Text('Sign in',
                                style: TextStyleConstants.tabBarTitle),
                            Text('Sign up', style: TextStyleConstants.tabBarTitle)
                          ]),
                      Expanded(
                        child: TabBarView(controller: tabController, children: [
                          BlocProvider(
                            create: (context) =>
                                SignInBloc(userRepository: widget.userRepository),
                            child: const SignInScreen(),
                          ),
                          BlocProvider(
                            create: (context) =>
                                SignUpBloc(userRepository: widget.userRepository),
                            child: const SignUpScreen(),
                          )
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
