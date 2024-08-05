import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lottie/lottie.dart';

import '../../components/gradient_text.dart';
import '../../constants/constants.dart';
import '../choose_screen/bloc/choose_screen_bloc.dart';
import '../choose_screen/choose_screen.dart';

class GenerateRecipeScreen extends StatefulWidget {
  final String imageUrl;
  final String userName;
  const GenerateRecipeScreen(
      {super.key, required this.userName, required this.imageUrl});

  @override
  State<GenerateRecipeScreen> createState() => _GenerateRecipeScreenState();
}

class _GenerateRecipeScreenState extends State<GenerateRecipeScreen> {
  late String userName;
  late String imageUrl;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    userName = widget.userName;
    imageUrl = widget.imageUrl;
    super.didChangeDependencies();
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
                  style: ElevatedButton.styleFrom(
                      maximumSize:
                          Size(MediaQuery.of(context).size.width * 0.55, 48),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.55, 48),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)))),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              create: (context) => ChooseScreenBloc(),
                              child: const ChooseScreen(),
                            )));
                  },
                  child: Text(
                    "Get Started",
                    style: TextStyleConstants.title,
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
