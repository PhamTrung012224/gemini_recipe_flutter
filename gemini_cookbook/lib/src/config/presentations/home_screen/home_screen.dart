import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/models/objects/prompt_response_object.dart';

import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

import '../../components/gradient_text.dart';
import '../../components/ui_icon.dart';
import '../../components/ui_space.dart';
import '../../constants/constants.dart';
import '../../models/objects/suggest_response_object.dart';
import '../../models/objects/youtube_response_object.dart';
import '../../models/services/youtube_search/youtube_search.dart';
import '../authentication_screen/authentication_bloc/authentication_bloc.dart';
import '../authentication_screen/sign_in_screen/bloc/sign_in_bloc.dart';
import '../authentication_screen/sign_in_screen/bloc/sign_in_event.dart';
import '../choose_screen/bloc/my_user/my_user_bloc.dart';
import '../choose_screen/bloc/my_user/my_user_event.dart';
import '../choose_screen/bloc/my_user/my_user_state.dart';
import '../choose_screen/bloc/my_user/update_user_image/update_user_image_bloc.dart';
import '../choose_screen/bloc/my_user/update_user_image/update_user_image_event.dart';
import '../choose_screen/bloc/my_user/update_user_image/update_user_image_state.dart';
import '../recipe_screen/recipe_screen.dart';
import '../recipe_screen/save_recipe_bloc/save_recipe_bloc.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  NavigatorState? _navigator;
  BuildContext? _context;
  bool isDarkMode = false;
  bool _isLoadingRecipe = false;
  bool _isLoadingLogOut = false;
  final YoutubeSearchRepository youtube = YoutubeSearchRepository();
  final suggestCollection =
      FirebaseFirestore.instance.collection('suggest_recipes');
  final recipeCollection = FirebaseFirestore.instance.collection('recipes');

  @override
  void didChangeDependencies() {
    isDarkMode = (Theme.of(context).brightness == Brightness.dark);
    _navigator = Navigator.of(context);
    _context=context;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<UpdateUserImageBloc, UpdateUserImageState>(
      listener: (context, state) {
        if (state is UploadPictureSuccess) {
          setState(() {
            context.read<MyUserBloc>().add(GetUserData(
                userId: context.read<MyUserBloc>().state.user!.userId));
          });
        }
      },
      child: Stack(
        children: [
          Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: isDarkMode
                  ? const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xff511709),
                        Color(0xff4c2921),
                      ]),
                    )
                  : const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xffffeabd),
                        Color(0xffffac37),
                      ]),
                    )),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  expandedHeight: MediaQuery.of(context).size.height * 0.28,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: isDarkMode
                                ? const BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color(0xff511709),
                                      Color(0xff4c2921),
                                    ]),
                                  )
                                : const BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color(0xffffeabd),
                                      Color(0xffffac37),
                                    ]),
                                  )),
                        Column(children: [
                          UISpace(
                              height:
                                  MediaQuery.of(context).size.height * 0.008),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8.0),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    UIIcon(
                                        size: 42,
                                        icon: IconConstants.accountIcon,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                    BlocBuilder<MyUserBloc, MyUserState>(
                                      builder: (context, state) {
                                        return GestureDetector(
                                          onTap: () async {
                                            final image =
                                                await getProfileImage();
                                            if (image != null) {
                                              setState(() {
                                                context
                                                    .read<UpdateUserImageBloc>()
                                                    .add(UpdateProfileImage(
                                                        userId:
                                                            state.user!.userId,
                                                        path: image.path));
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: 42,
                                            height: 42,
                                            decoration: const BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                            child: (state.user?.picture
                                                        .isNotEmpty ??
                                                    false)
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Image.network(
                                                      state.user!.picture,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Center(
                                    child: BlocBuilder<MyUserBloc, MyUserState>(
                                      builder: (context, state) {
                                        return Text(
                                          "Hello ${state.user?.name ?? ''}!",
                                          style: TextStyleConstants.title,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        _isLoadingLogOut = true;
                                      });
                                      await precacheImage(
                                              AssetImage(isDarkMode
                                                  ? ImageConstants
                                                      .loginDarkBackground
                                                  : ImageConstants
                                                      .loginBackground),
                                              context)
                                          .catchError((error) {
                                        log('Error preloading image: $error');
                                      });
                                      _context
                                          !.read<SignInBloc>()
                                          .add(SignOutRequired());
                                      setState(() {
                                        _isLoadingLogOut = false;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.logout_sharp,
                                      size: 40,
                                    ))
                              ],
                            ),
                          ),
                          UISpace(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Don't know what to eat today, let's us give you some suggestions",
                                    style: TextStyleConstants.headline1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ])
                      ],
                    ),
                    title: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.013,
                                  left: 8,
                                  bottom: MediaQuery.of(context).size.height *
                                      0.013),
                              child: GradientText(
                                'Recommend dishes',
                                gradient: LinearGradient(colors: [
                                  Theme.of(context).colorScheme.onSurface,
                                  Theme.of(context).colorScheme.onSurface
                                ]),
                                style: TextStyleConstants.headline1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    titlePadding: const EdgeInsets.all(0),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("suggest_recipes")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active &&
                          (snapshot.data?.docs.length ?? 0) >= 1) {
                        final result = snapshot.data!.docs.toList();

                        List<String> breakfastUserId = [];
                        List<String> lunchUserId = [];
                        List<String> dinnerUserId = [];
                        List<String> dessertUserId = [];
                        List<String> vegetarianUserId = [];
                        List<String> soupUserId = [];
                        List<String> saladUserId = [];

                        List<String> breakfastImage = [];
                        List<String> lunchImage = [];
                        List<String> dinnerImage = [];
                        List<String> dessertImage = [];
                        List<String> vegetarianImage = [];
                        List<String> soupImage = [];
                        List<String> saladImage = [];

                        List<SuggestResponse> breakfastResponse = [];
                        List<SuggestResponse> lunchResponse = [];
                        List<SuggestResponse> dinnerResponse = [];
                        List<SuggestResponse> dessertResponse = [];
                        List<SuggestResponse> saladResponse = [];
                        List<SuggestResponse> soupResponse = [];
                        List<SuggestResponse> vegetarianResponse = [];

                        for (var recipe in result) {
                          switch (SuggestResponse.fromJson(recipe["recipeJson"])
                              .category) {
                            case 'Breakfast recipes':
                              {
                                breakfastUserId.add(recipe["userId"]);
                                breakfastImage.add(recipe["picture"]);
                                breakfastResponse.add(SuggestResponse.fromJson(
                                    recipe["recipeJson"]));
                              }
                            case 'Lunch recipes':
                              {
                                lunchUserId.add(recipe["userId"]);
                                lunchImage.add(recipe["picture"]);
                                lunchResponse.add(SuggestResponse.fromJson(
                                    recipe["recipeJson"]));
                              }
                            case 'Dinner recipes':
                              {
                                dinnerUserId.add(recipe["userId"]);
                                dinnerImage.add(recipe["picture"]);
                                dinnerResponse.add(SuggestResponse.fromJson(
                                    recipe["recipeJson"]));
                              }
                            case 'Salad recipes':
                              {
                                saladUserId.add(recipe["userId"]);
                                saladImage.add(recipe["picture"]);
                                saladResponse.add(SuggestResponse.fromJson(
                                    recipe["recipeJson"]));
                              }
                            case 'Soup recipes':
                              {
                                soupUserId.add(recipe["userId"]);
                                soupImage.add(recipe["picture"]);
                                soupResponse.add(SuggestResponse.fromJson(
                                    recipe["recipeJson"]));
                              }
                            case 'Dessert recipes':
                              {
                                dessertUserId.add(recipe["userId"]);
                                dessertImage.add(recipe["picture"]);
                                dessertResponse.add(SuggestResponse.fromJson(
                                    recipe["recipeJson"]));
                              }
                            case 'Vegetarian Dishes':
                              {
                                vegetarianUserId.add(recipe["userId"]);
                                vegetarianImage.add(recipe["picture"]);
                                vegetarianResponse.add(SuggestResponse.fromJson(
                                    recipe["recipeJson"]));
                              }
                            default:
                          }
                        }
                        return BlocBuilder<MyUserBloc, MyUserState>(
                          builder: (context, userState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    'For Breakfast:',
                                    style: TextStyleConstants.title,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.28,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: breakfastResponse.length,
                                    itemBuilder: (context, idx) =>
                                        GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _isLoadingRecipe = true;
                                        });
                                        final res = await getYoutubeResponse(
                                            'How to make ${breakfastResponse[idx].title}',
                                            5);

                                        final PromptResponse promptResponse =
                                            PromptResponse.fromJson(
                                                breakfastResponse[idx]
                                                    .toJson());

                                        final YoutubeResponse youtubeResponse =
                                            YoutubeResponse.fromJson(res);

                                        final savedCheck =
                                            await recipeCollection
                                                .where('ownerId',
                                                    isEqualTo:
                                                        userState.user!.userId)
                                                .where('title',
                                                    isEqualTo:
                                                        breakfastResponse[idx]
                                                            .title)
                                                .get();

                                        setState(() {
                                          _isLoadingRecipe = false;
                                        });

                                        _navigator!.push(
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (context) => SaveRecipeBloc(
                                                  userRepository: context
                                                      .read<
                                                          AuthenticationBloc>()
                                                      .userRepository),
                                              child: RecipeScreen(
                                                userId: userState.user!.userId,
                                                promptResponse: promptResponse,
                                                youtubeResponse:
                                                    youtubeResponse,
                                                savedCheck: savedCheck.size >= 1
                                                    ? true
                                                    : false,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                        child: Column(children: [
                                          breakfastImage[idx].isEmpty
                                              ? const SizedBox.shrink()
                                              : ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                  child: Image.network(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    breakfastImage[idx],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                breakfastResponse[idx].title,
                                                textAlign: TextAlign.left,
                                                style: TextStyleConstants
                                                    .headline2,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                                const UISpace(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text('For Lunch:',
                                      style: TextStyleConstants.title),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.28,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: lunchResponse.length,
                                    itemBuilder: (context, idx) =>
                                        GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _isLoadingRecipe = true;
                                        });
                                        final res = await getYoutubeResponse(
                                            'How to make ${lunchResponse[idx].title}',
                                            5);

                                        final PromptResponse promptResponse =
                                            PromptResponse.fromJson(
                                                lunchResponse[idx].toJson());

                                        final YoutubeResponse youtubeResponse =
                                            YoutubeResponse.fromJson(res);

                                        final savedCheck =
                                            await recipeCollection
                                                .where(
                                                    'ownerId',
                                                    isEqualTo: userState
                                                        .user!.userId)
                                                .where(
                                                    'title',
                                                    isEqualTo:
                                                        lunchResponse[idx]
                                                            .title)
                                                .get();

                                        setState(() {
                                          _isLoadingRecipe = false;
                                        });

                                        _navigator!.push(
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (context) => SaveRecipeBloc(
                                                  userRepository: context
                                                      .read<
                                                          AuthenticationBloc>()
                                                      .userRepository),
                                              child: RecipeScreen(
                                                userId: userState.user!.userId,
                                                promptResponse: promptResponse,
                                                youtubeResponse:
                                                    youtubeResponse,
                                                savedCheck: savedCheck.size >= 1
                                                    ? true
                                                    : false,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                        child: Column(children: [
                                          lunchImage[idx].isEmpty
                                              ? const SizedBox.shrink()
                                              : ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                  child: Image.network(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    lunchImage[idx],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                lunchResponse[idx].title,
                                                textAlign: TextAlign.left,
                                                style: TextStyleConstants
                                                    .headline2,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                                const UISpace(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text('For Dinner:',
                                      style: TextStyleConstants.title),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.28,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: dinnerResponse.length,
                                    itemBuilder: (context, idx) =>
                                        GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _isLoadingRecipe = true;
                                        });
                                        final res = await getYoutubeResponse(
                                            'How to make ${dinnerResponse[idx].title}',
                                            5);

                                        final PromptResponse promptResponse =
                                            PromptResponse.fromJson(
                                                dinnerResponse[idx].toJson());

                                        final YoutubeResponse youtubeResponse =
                                            YoutubeResponse.fromJson(res);

                                        final savedCheck =
                                            await recipeCollection
                                                .where('ownerId',
                                                    isEqualTo:
                                                        userState.user!.userId)
                                                .where('title',
                                                    isEqualTo:
                                                        dinnerResponse[idx]
                                                            .title)
                                                .get();

                                        setState(() {
                                          _isLoadingRecipe = false;
                                        });

                                        _navigator!.push(
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (context) => SaveRecipeBloc(
                                                  userRepository: context
                                                      .read<
                                                          AuthenticationBloc>()
                                                      .userRepository),
                                              child: RecipeScreen(
                                                userId: userState.user!.userId,
                                                promptResponse: promptResponse,
                                                youtubeResponse:
                                                    youtubeResponse,
                                                savedCheck: savedCheck.size >= 1
                                                    ? true
                                                    : false,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                        child: Column(children: [
                                          dinnerImage[idx].isEmpty
                                              ? const SizedBox.shrink()
                                              : ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                  child: Image.network(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    dinnerImage[idx],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                dinnerResponse[idx].title,
                                                textAlign: TextAlign.left,
                                                style: TextStyleConstants
                                                    .headline2,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                                const UISpace(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text('Dessert Dishes:',
                                      style: TextStyleConstants.title),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.28,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: dessertResponse.length,
                                    itemBuilder: (context, idx) =>
                                        GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _isLoadingRecipe = true;
                                        });
                                        final res = await getYoutubeResponse(
                                            'How to make ${dessertResponse[idx].title}',
                                            5);

                                        final PromptResponse promptResponse =
                                            PromptResponse.fromJson(
                                                dessertResponse[idx].toJson());

                                        final YoutubeResponse youtubeResponse =
                                            YoutubeResponse.fromJson(res);

                                        final savedCheck =
                                            await recipeCollection
                                                .where('ownerId',
                                                    isEqualTo:
                                                        userState.user!.userId)
                                                .where('title',
                                                    isEqualTo:
                                                        dessertResponse[idx]
                                                            .title)
                                                .get();

                                        setState(() {
                                          _isLoadingRecipe = false;
                                        });

                                        _navigator!.push(
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (context) => SaveRecipeBloc(
                                                  userRepository: context
                                                      .read<
                                                          AuthenticationBloc>()
                                                      .userRepository),
                                              child: RecipeScreen(
                                                userId: userState.user!.userId,
                                                promptResponse: promptResponse,
                                                youtubeResponse:
                                                    youtubeResponse,
                                                savedCheck: savedCheck.size >= 1
                                                    ? true
                                                    : false,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                        child: Column(children: [
                                          dessertImage[idx].isEmpty
                                              ? const SizedBox.shrink()
                                              : ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                  child: Image.network(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    dessertImage[idx],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                dessertResponse[idx].title,
                                                textAlign: TextAlign.left,
                                                style: TextStyleConstants
                                                    .headline2,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                                const UISpace(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text('Vegetarian Dishes:',
                                      style: TextStyleConstants.title),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.28,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: vegetarianResponse.length,
                                    itemBuilder: (context, idx) =>
                                        GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _isLoadingRecipe = true;
                                        });
                                        final res = await getYoutubeResponse(
                                            'How to make ${vegetarianResponse[idx].title}',
                                            5);

                                        final PromptResponse promptResponse =
                                            PromptResponse.fromJson(
                                                vegetarianResponse[idx]
                                                    .toJson());

                                        final YoutubeResponse youtubeResponse =
                                            YoutubeResponse.fromJson(res);

                                        final savedCheck =
                                            await recipeCollection
                                                .where('ownerId',
                                                    isEqualTo:
                                                        userState.user!.userId)
                                                .where('title',
                                                    isEqualTo:
                                                        vegetarianResponse[idx]
                                                            .title)
                                                .get();

                                        setState(() {
                                          _isLoadingRecipe = false;
                                        });

                                        _navigator!.push(
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (context) => SaveRecipeBloc(
                                                  userRepository: context
                                                      .read<
                                                          AuthenticationBloc>()
                                                      .userRepository),
                                              child: RecipeScreen(
                                                userId: userState.user!.userId,
                                                promptResponse: promptResponse,
                                                youtubeResponse:
                                                    youtubeResponse,
                                                savedCheck: savedCheck.size >= 1
                                                    ? true
                                                    : false,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                        child: Column(children: [
                                          vegetarianImage[idx].isEmpty
                                              ? const SizedBox.shrink()
                                              : ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                  child: Image.network(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    vegetarianImage[idx],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                vegetarianResponse[idx].title,
                                                textAlign: TextAlign.left,
                                                style: TextStyleConstants
                                                    .headline2,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                                const UISpace(height: 16),
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text('Soup Dishes:',
                                        style: TextStyleConstants.title)),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.28,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: soupResponse.length,
                                    itemBuilder: (context, idx) =>
                                        GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _isLoadingRecipe = true;
                                        });
                                        final res = await getYoutubeResponse(
                                            'How to make ${soupResponse[idx].title}',
                                            5);

                                        final PromptResponse promptResponse =
                                            PromptResponse.fromJson(
                                                soupResponse[idx].toJson());

                                        final YoutubeResponse youtubeResponse =
                                            YoutubeResponse.fromJson(res);

                                        final savedCheck =
                                            await recipeCollection
                                                .where('ownerId',
                                                    isEqualTo:
                                                        userState.user!.userId)
                                                .where('title',
                                                    isEqualTo:
                                                        soupResponse[idx].title)
                                                .get();

                                        setState(() {
                                          _isLoadingRecipe = false;
                                        });

                                        _navigator!.push(
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (context) => SaveRecipeBloc(
                                                  userRepository: context
                                                      .read<
                                                          AuthenticationBloc>()
                                                      .userRepository),
                                              child: RecipeScreen(
                                                userId: userState.user!.userId,
                                                promptResponse: promptResponse,
                                                youtubeResponse:
                                                    youtubeResponse,
                                                savedCheck: savedCheck.size >= 1
                                                    ? true
                                                    : false,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                        child: Column(children: [
                                          soupImage[idx].isEmpty
                                              ? const SizedBox.shrink()
                                              : ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                  child: Image.network(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    soupImage[idx],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                soupResponse[idx].title,
                                                textAlign: TextAlign.left,
                                                style: TextStyleConstants
                                                    .headline2,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                                const UISpace(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text('Salad Dishes:',
                                      style: TextStyleConstants.title),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.28,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: saladResponse.length,
                                    itemBuilder: (context, idx) =>
                                        GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _isLoadingRecipe = true;
                                        });
                                        final res = await getYoutubeResponse(
                                            'How to make ${saladResponse[idx].title}',
                                            5);

                                        final PromptResponse promptResponse =
                                            PromptResponse.fromJson(
                                                saladResponse[idx].toJson());

                                        final YoutubeResponse youtubeResponse =
                                            YoutubeResponse.fromJson(res);

                                        final savedCheck =
                                            await recipeCollection
                                                .where(
                                                    'ownerId',
                                                    isEqualTo: userState
                                                        .user!.userId)
                                                .where(
                                                    'title',
                                                    isEqualTo:
                                                        saladResponse[idx]
                                                            .title)
                                                .get();

                                        setState(() {
                                          _isLoadingRecipe = false;
                                        });

                                        _navigator!.push(
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                              create: (context) => SaveRecipeBloc(
                                                  userRepository: context
                                                      .read<
                                                          AuthenticationBloc>()
                                                      .userRepository),
                                              child: RecipeScreen(
                                                userId: userState.user!.userId,
                                                promptResponse: promptResponse,
                                                youtubeResponse:
                                                    youtubeResponse,
                                                savedCheck: savedCheck.size >= 1
                                                    ? true
                                                    : false,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                        child: Column(children: [
                                          saladImage[idx].isEmpty
                                              ? const SizedBox.shrink()
                                              : ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                  child: Image.network(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    saladImage[idx],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                saladResponse[idx].title,
                                                textAlign: TextAlign.left,
                                                style: TextStyleConstants
                                                    .headline2,
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                                const UISpace(height: 16),
                              ],
                            );
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                )),
              ],
            ),
          ),
          _isLoadingLogOut
              ? Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Theme.of(context).colorScheme.primary, size: 90),
                )
              : (_isLoadingRecipe == true
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.withOpacity(0.4),
                      child: Center(
                        child: Lottie.asset(LottieConstants.cookingAnimation,
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.4),
                      ),
                    )
                  : const SizedBox())
        ],
      ),
    );
  }

  Future<XFile?> getProfileImage() async {
    ImagePicker imagePicker = ImagePicker();
    return await imagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<Map<String, dynamic>> getYoutubeResponse(
      String q, int maxResults) async {
    try {
      return youtube.search(q, maxResults);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  void dispose() {
    _navigator = null;
    _context=null;
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
