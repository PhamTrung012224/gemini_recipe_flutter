import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/main_screen/my_user/my_user_bloc.dart';

import '../home_screen/home_screen.dart';
import '../saved_recipe_screen/savedrecipe_screen.dart';
import '../started_screen/started_screen.dart';
import 'my_user/my_user_state.dart';

class MainScreen extends StatefulWidget {
  final String userId;
  const MainScreen({super.key, required this.userId});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentScreenIndex = 0;
  List<dynamic> screen = [];
  late String userName;
  late String imageUrl;

  @override
  void initState() {
    userName = context.read<MyUserBloc>().state.user?.name ?? '';
    imageUrl = context.read<MyUserBloc>().state.user?.picture ?? '';
    screen = [
      HomeScreen(
        userId: widget.userId,
      ),
      GenerateRecipeScreen(
        userName: userName,
        imageUrl: imageUrl,
      ),
      SavedRecipeScreen(userId: widget.userId),
    ];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            Theme.of(context).colorScheme.background.withOpacity(0.0),
      ),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyUserBloc, MyUserState>(
      listener: (context, state) {
        userName = state.user?.name??'';
        imageUrl = state.user?.picture??'';
        screen = [
          HomeScreen(
            userId: widget.userId,
          ),
          GenerateRecipeScreen(
            userName: userName,
            imageUrl: imageUrl,
          ),
          SavedRecipeScreen(userId: widget.userId),
        ];
      },
      child: Scaffold(
        body: screen[currentScreenIndex],
        bottomNavigationBar: NavigationBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          height: 80,
          animationDuration: const Duration(milliseconds: 1800),
          selectedIndex: currentScreenIndex,
          onDestinationSelected: (idx) {
            setState(() {
              currentScreenIndex = idx;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              selectedIcon: Icon(Icons.home),
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_add_outlined),
              label: 'Make Recipe',
              selectedIcon: Icon(Icons.bookmark_add),
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmarks_outlined),
              label: 'Saved Recipe',
              selectedIcon: Icon(Icons.bookmarks),
            ),
          ],
        ),
      ),
    );
  }
}
