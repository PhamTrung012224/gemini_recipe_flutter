import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/components/ui_icon.dart';
import 'package:gemini_cookbook/src/config/components/ui_space.dart';
import 'package:gemini_cookbook/src/config/constants/constants.dart';
import 'package:gemini_cookbook/src/config/models/objects/image_object.dart';
import 'package:gemini_cookbook/src/config/models/objects/prompt_object.dart';
import 'package:gemini_cookbook/src/config/models/objects/prompt_response_object.dart';
import 'package:gemini_cookbook/src/config/models/objects/youtube_response_object.dart';
import 'package:gemini_cookbook/src/config/models/services/gemini/gemini.dart';
import 'package:gemini_cookbook/src/config/models/services/youtube_search/youtube_search.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_in_screen/bloc/sign_in_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_in_screen/bloc/sign_in_event.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_in_screen/bloc/sign_in_state.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/home_screen_event.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/my_user/my_user_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/my_user/my_user_event.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/my_user/my_user_state.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/my_user/update_user_image/update_user_image_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/my_user/update_user_image/update_user_image_event.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/my_user/update_user_image/update_user_image_state.dart';
import 'package:gemini_cookbook/src/config/presentations/recipe_screen/recipe_screen.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mime/mime.dart';
import 'package:safe_text/safe_text.dart';

import '../../themes/color_source.dart';
import 'bloc/home_screen_bloc.dart';
import 'bloc/home_screen_state.dart';

const String _apiKey = String.fromEnvironment('API_KEY');

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> meal = [
    'breakfast',
    'brunch',
    'elevenses',
    'lunch',
    'tea',
    'supper',
    'dinner',
  ];
  final List<String> ingredients = [
    'oil',
    'butter',
    'flour',
    'salt',
    'pepper',
    'sugar',
    'milk',
    'vinegar'
  ];
  final List<String> cuisines = [
    'Italian',
    'Mexican',
    'American',
    'French',
    'Japanese',
    'Chinese',
    'Indian',
    'Greek',
    'Vietnamese',
    'Ethiopian',
    'South African',
  ];
  final List<String> dietaryRestrictions = [
    'vegetarian',
    'dairy free',
    'kosher',
    'low carb',
    'wheat allergy',
    'nut allergy',
    'fish allergy',
    'soy allergy',
  ];
  late GenerativeModel _model;
  late final ImageObject imgData = ImageObject(image: [], imageData: []);
  late final TextEditingController textEditingController;
  late final FocusNode textFieldFocus;
  final YoutubeSearchRepository youtube = YoutubeSearchRepository();
  bool _isLoading = false;
  bool isDarkMode = false;

  @override
  void initState() {
    _model = GenerativeModel(
      safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high)
      ],
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
    // _model1 = YouTubeApi(http.);
    textEditingController = TextEditingController();
    textFieldFocus = FocusNode();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    isDarkMode = (Theme.of(context).brightness == Brightness.dark);
    //Load background of Recipe Screen
    preloadImages();
    super.didChangeDependencies();
  }

  Future<void> preloadImages() async {
    await precacheImage(
            AssetImage(isDarkMode
                ? ImageConstants.recipeDarkBackground
                : ImageConstants.recipeBackground),
            context)
        .catchError((error) {
      log('Error preloading image: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
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
          GestureDetector(
            onTap: () {
              textFieldFocus.unfocus();
            },
            child: SafeArea(
              child: Scaffold(
                  body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    expandedHeight: MediaQuery.of(context).size.height * 0.28,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: isDarkMode
                                  ? const BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Color(0xFF3d5a80),
                                        Color(0xff82a8bd),
                                      ]),
                                    )
                                  : const BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Color(0xff8ecae6),
                                        Color(0xff2886a8),
                                      ]),
                                    )),
                          Column(children: [
                            UISpace(
                                height:
                                    MediaQuery.of(context).size.height * 0.015),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
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
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                        child: BlocBuilder<MyUserBloc,
                                            MyUserState>(
                                          builder: (context, state) {
                                            return (state.user?.picture
                                                        .isNotEmpty ??
                                                    false)
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      final image =
                                                          await getProfileImage();
                                                      if (image != null) {
                                                        setState(() {
                                                          context
                                                              .read<
                                                                  UpdateUserImageBloc>()
                                                              .add(UpdateProfileImage(
                                                                  userId: state
                                                                      .user!
                                                                      .userId,
                                                                  path: image
                                                                      .path));
                                                        });
                                                      }
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: Image.network(
                                                        state.user!.picture,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Center(
                                      child:
                                          BlocBuilder<MyUserBloc, MyUserState>(
                                        builder: (context, state) {
                                          return Text(
                                            "Hello ${state.user?.name ?? ''}!",
                                            style: TextStyleConstants.headline1,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  BlocBuilder<SignInBloc, SignInState>(
                                    builder: (context, state) {
                                      return GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              _isLoading = true;
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
                                            context
                                                .read<SignInBloc>()
                                                .add(SignOutRequired());
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          },
                                          child: UIIcon(
                                              size: 28,
                                              icon: IconConstants.logoutIcon,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface));
                                    },
                                  )
                                ],
                              ),
                            ),
                            UISpace(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Tell me what ingredients you have and what you're feelin, and I'll create a recipe for you!",
                                      style: TextStyleConstants.headline2,
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
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(50))),
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
                                child: Text(
                                  'Create a recipe',
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
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(50))),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 48,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            'Create a recipe:',
                                            style:
                                                TextStyleConstants.semiMedium,
                                          ),
                                        ))),
                                const UISpace(height: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: getImage,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              top: 12,
                                              bottom: 8,
                                              right: 10),
                                          child: Container(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'I have these ingredients:',
                                                    style: TextStyleConstants
                                                        .medium,
                                                  ),
                                                  const UISpace(height: 10),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                52) /
                                                            3,
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                52) /
                                                            3,
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primaryContainer,
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        12))),
                                                        child: Transform.scale(
                                                            scale: 1.8,
                                                            child: const Icon(Icons
                                                                .image_outlined)),
                                                      ),
                                                      SizedBox(
                                                        width: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    52) *
                                                                2 /
                                                                3 +
                                                            16,
                                                        height: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                52) /
                                                            3,
                                                        child: (imgData.image
                                                                    ?.isNotEmpty ??
                                                                false)
                                                            ? ListView.builder(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            4),
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemBuilder:
                                                                    (context,
                                                                            idx) =>
                                                                        Row(
                                                                  children: [
                                                                    const SizedBox(
                                                                        width:
                                                                            4),
                                                                    ClipRRect(
                                                                      borderRadius: const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              12)),
                                                                      child: Stack(
                                                                          children: [
                                                                            Image(
                                                                              image: imgData.image![idx].image,
                                                                              height: (MediaQuery.of(context).size.width - 52) / 3,
                                                                              width: (MediaQuery.of(context).size.width - 52) / 3,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  imgData.image!.removeAt(idx);
                                                                                  imgData.imageData!.removeAt(idx);
                                                                                });
                                                                              },
                                                                              child: const Padding(
                                                                                padding: EdgeInsets.only(top: 2, left: 76),
                                                                                child: Icon(Icons.remove_circle_outline, color: ColorConstants.removeButtonColor),
                                                                              ),
                                                                            )
                                                                          ]),
                                                                    ),
                                                                  ],
                                                                ),
                                                                itemCount:
                                                                    imgData
                                                                        .image!
                                                                        .length,
                                                              )
                                                            : Container(),
                                                      )
                                                    ],
                                                  ),
                                                  const UISpace(height: 10)
                                                ],
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const UISpace(height: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 12, bottom: 8),
                                        child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Text('I want to make:',
                                                style:
                                                    TextStyleConstants.medium)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, bottom: 12),
                                        child: InlineChoice.multiple(
                                            itemCount: meal.length,
                                            itemBuilder: (context, idx) =>
                                                BlocBuilder<HomeScreenBloc,
                                                    HomeScreenState>(
                                                  builder: (context, state) {
                                                    return ChoiceChip(
                                                      label: Text(
                                                        meal[idx],
                                                        style:
                                                            TextStyleConstants
                                                                .semiMedium,
                                                      ),
                                                      selected: state
                                                          .isMealSelected[idx],
                                                      onSelected: (bool value) {
                                                        //New list
                                                        List<bool> list =
                                                            List.from(state
                                                                .isMealSelected);
                                                        list[idx] = value;
                                                        //New ingredient
                                                        String tempMeal = '';
                                                        for (var i = 0;
                                                            i < list.length;
                                                            i++) {
                                                          if (list[i] == true) {
                                                            tempMeal +=
                                                                '${meal[i]}, ';
                                                          }
                                                        }
                                                        //
                                                        context.read<HomeScreenBloc>().add(TapMealChip(
                                                            isMealSelected:
                                                                list,
                                                            mealPrompt: PromptObject(
                                                                cuisines: state
                                                                    .prompt
                                                                    .cuisines,
                                                                dietaryRestrictions:
                                                                    state.prompt
                                                                        .dietaryRestrictions,
                                                                ingredients: state
                                                                    .prompt
                                                                    .ingredients,
                                                                meal:
                                                                    tempMeal)));
                                                      },
                                                    );
                                                  },
                                                )),
                                      )
                                    ],
                                  ),
                                ),
                                const UISpace(height: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 12, bottom: 8),
                                        child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                'I also have these staple ingredients:',
                                                style:
                                                    TextStyleConstants.medium)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, bottom: 12),
                                        child: InlineChoice.multiple(
                                            itemCount: ingredients.length,
                                            itemBuilder: (context, idx) =>
                                                BlocBuilder<HomeScreenBloc,
                                                    HomeScreenState>(
                                                  builder: (context, state) {
                                                    return ChoiceChip(
                                                      label: Text(
                                                        ingredients[idx],
                                                        style:
                                                            TextStyleConstants
                                                                .semiMedium,
                                                      ),
                                                      selected: state
                                                              .isIngredientsSelected[
                                                          idx],
                                                      onSelected: (bool value) {
                                                        //New list
                                                        List<bool> list =
                                                            List.from(state
                                                                .isIngredientsSelected);
                                                        list[idx] = value;
                                                        //New ingredient
                                                        String tempIngredients =
                                                            '';
                                                        for (var i = 0;
                                                            i < list.length;
                                                            i++) {
                                                          if (list[i] == true) {
                                                            tempIngredients +=
                                                                '${ingredients[i]}, ';
                                                          }
                                                        }
                                                        //
                                                        context.read<HomeScreenBloc>().add(TapIngredientChip(
                                                            isIngredientsSelected:
                                                                list,
                                                            ingredientsPrompt: PromptObject(
                                                                cuisines: state
                                                                    .prompt
                                                                    .cuisines,
                                                                dietaryRestrictions:
                                                                    state.prompt
                                                                        .dietaryRestrictions,
                                                                meal: state
                                                                    .prompt
                                                                    .meal,
                                                                ingredients:
                                                                    tempIngredients)));
                                                      },
                                                    );
                                                  },
                                                )),
                                      )
                                    ],
                                  ),
                                ),
                                const UISpace(height: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 12, bottom: 8),
                                        child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Text("I'm in the mood for:",
                                                style:
                                                    TextStyleConstants.medium)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, bottom: 12),
                                        child: InlineChoice.multiple(
                                            itemCount: cuisines.length,
                                            itemBuilder: (context, idx) =>
                                                BlocBuilder<HomeScreenBloc,
                                                    HomeScreenState>(
                                                  builder: (context, state) {
                                                    return ChoiceChip(
                                                      label: Text(
                                                        cuisines[idx],
                                                        style:
                                                            TextStyleConstants
                                                                .semiMedium,
                                                      ),
                                                      selected: state
                                                              .isCuisinesSelected[
                                                          idx],
                                                      onSelected: (bool value) {
                                                        List<bool> list =
                                                            List.from(state
                                                                .isCuisinesSelected);
                                                        list[idx] = value;
                                                        String tempCuisines =
                                                            '';
                                                        for (var i = 0;
                                                            i < list.length;
                                                            i++) {
                                                          if (list[i] == true) {
                                                            tempCuisines +=
                                                                '${cuisines[i]}, ';
                                                          }
                                                        }
                                                        context.read<HomeScreenBloc>().add(TapCuisineChip(
                                                            isCuisineSelected:
                                                                list,
                                                            cuisinesPrompt: PromptObject(
                                                                ingredients: state
                                                                    .prompt
                                                                    .ingredients,
                                                                dietaryRestrictions:
                                                                    state.prompt
                                                                        .dietaryRestrictions,
                                                                meal: state
                                                                    .prompt
                                                                    .meal,
                                                                cuisines:
                                                                    tempCuisines)));
                                                      },
                                                    );
                                                  },
                                                )),
                                      )
                                    ],
                                  ),
                                ),
                                const UISpace(height: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 12, bottom: 8),
                                        child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                "I have the following dietary restrictions:",
                                                style:
                                                    TextStyleConstants.medium)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, bottom: 12),
                                        child: InlineChoice.multiple(
                                            itemCount:
                                                dietaryRestrictions.length,
                                            itemBuilder: (context, idx) =>
                                                BlocBuilder<HomeScreenBloc,
                                                    HomeScreenState>(
                                                  builder: (context, state) {
                                                    return ChoiceChip(
                                                      label: Text(
                                                        dietaryRestrictions[
                                                            idx],
                                                        style:
                                                            TextStyleConstants
                                                                .semiMedium,
                                                      ),
                                                      selected: state
                                                              .isDietaryRestrictionsSelected[
                                                          idx],
                                                      onSelected: (bool value) {
                                                        List<bool> list =
                                                            List.from(state
                                                                .isDietaryRestrictionsSelected);
                                                        list[idx] = value;
                                                        String
                                                            tempDietaryRestrictions =
                                                            '';
                                                        for (var i = 0;
                                                            i < list.length;
                                                            i++) {
                                                          if (list[i] == true) {
                                                            tempDietaryRestrictions +=
                                                                '${dietaryRestrictions[i]}, ';
                                                          }
                                                        }
                                                        context.read<HomeScreenBloc>().add(TapDietaryRestrictionChip(
                                                            isDietaryRestrictionSelected:
                                                                list,
                                                            dietaryRestrictionPrompt: PromptObject(
                                                                ingredients: state
                                                                    .prompt
                                                                    .ingredients,
                                                                cuisines: state
                                                                    .prompt
                                                                    .cuisines,
                                                                meal: state
                                                                    .prompt
                                                                    .meal,
                                                                dietaryRestrictions:
                                                                    tempDietaryRestrictions)));
                                                      },
                                                    );
                                                  },
                                                )),
                                      )
                                    ],
                                  ),
                                ),
                                const UISpace(height: 10),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  child: BlocBuilder<HomeScreenBloc,
                                      HomeScreenState>(
                                    builder: (context, state) {
                                      return TextField(
                                        style: TextStyleConstants.semiMedium,
                                        decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: 8, right: 8),
                                            hintText:
                                                'Enter additional information...'),
                                        controller: textEditingController,
                                        focusNode: textFieldFocus,
                                      );
                                    },
                                  ),
                                ),
                                const UISpace(height: 4),
                                Text(
                                  "Note: If no information or unrelated information is given, we will generate random Asian recipes for you.",
                                  style: TextStyleConstants.semiNormal,
                                ),
                                const UISpace(height: 20),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      BlocBuilder<HomeScreenBloc,
                                          HomeScreenState>(
                                        builder: (context, state) {
                                          return GestureDetector(
                                            onTap: () async {
                                              // final res =
                                              //     await getYoutubeResponse();
                                              showDialog<String>(
                                                  builder: (context) => Dialog(
                                                        child:
                                                            SingleChildScrollView(
                                                                child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 12,
                                                                  top: 16,
                                                                  bottom: 16,
                                                                  right: 12),
                                                          child: Text(
                                                            "${state.prompt.prompt} \n\nAlso include these following information if these information related to food or ingredients: ${textEditingController.value.text}",
                                                            style:
                                                                TextStyleConstants
                                                                    .normal,
                                                          ),
                                                        )),
                                                      ),
                                                  context: context);
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  12,
                                              height: 48,
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons
                                                      .info_outline_rounded),
                                                  const SizedBox(width: 8),
                                                  Text('Full Prompt',
                                                      style: TextStyleConstants
                                                          .medium),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      BlocBuilder<HomeScreenBloc,
                                          HomeScreenState>(
                                        builder: (context, state) {
                                          return GestureDetector(
                                            onTap: () async {
                                              try {
                                                String filteredText;
                                                try {
                                                  filteredText =
                                                      SafeText.filterText(
                                                    text: textEditingController
                                                        .value.text,
                                                    extraWords:
                                                        Constants.extraBadWords,
                                                    useDefaultWords: true,
                                                    fullMode: true,
                                                    obscureSymbol: "",
                                                  );
                                                } on FormatException {
                                                  // Handle specific exception for text formatting
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      backgroundColor:
                                                          Colors.blueGrey,
                                                      content: Text(
                                                        'Format Error: Please avoid using Special Characters !, #, [, +, ...',
                                                        style:
                                                            TextStyleConstants
                                                                .semiNormal,
                                                      ),
                                                    ),
                                                  );
                                                  textEditingController.clear();
                                                  return; // Stop further execution in case of this error
                                                }

                                                //Submit prompt to Gemini
                                                final res = await _submitPrompt(
                                                  _model,
                                                  state.prompt,
                                                  filteredText,
                                                  imgData.imageData,
                                                );

                                                final Map<String, dynamic>
                                                    jsonMap = json.decode(
                                                        res.text.toString());
                                                final PromptResponse response =
                                                    PromptResponse.fromJson(
                                                        jsonMap);
                                                imgData.resetData();
                                                textEditingController.clear();
                                                final res1 =
                                                    await getYoutubeResponse(
                                                        'How to make ${response.title}',
                                                        5);

                                                final YoutubeResponse
                                                    response1 =
                                                    YoutubeResponse.fromJson(
                                                        res1);

                                                context
                                                    .read<HomeScreenBloc>()
                                                    .add(TapResetPromptEvent());
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecipeScreen(
                                                      promptResponse: response,
                                                      youtubeResponse:
                                                          response1,
                                                    ),
                                                  ),
                                                );
                                              } on HttpException {
                                                // Handle network-related exceptions
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        Colors.blueGrey,
                                                    content: Text(
                                                      'Network Error: Unable to submit your request.',
                                                      style: TextStyleConstants
                                                          .semiNormal,
                                                    ),
                                                  ),
                                                );
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              } catch (e) {
                                                // Handle any other exceptions that weren't caught by the specific catches
                                                log(e.toString());
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        Colors.blueGrey,
                                                    content: Text(
                                                      'An unexpected error occurred. Please try again.',
                                                      style: TextStyleConstants
                                                          .semiNormal,
                                                    ),
                                                  ),
                                                );
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  20,
                                              height: 48,
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.send_sharp),
                                                  const SizedBox(width: 8),
                                                  Text('Submit Prompt',
                                                      style: TextStyleConstants
                                                          .medium),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                const UISpace(height: 20),
                                BlocBuilder<HomeScreenBloc, HomeScreenState>(
                                  builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () {
                                        imgData.resetData();
                                        textEditingController.clear();
                                        context
                                            .read<HomeScreenBloc>()
                                            .add(TapResetPromptEvent());
                                        setState(() {});
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              20,
                                          height: 48,
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.restart_alt),
                                              const SizedBox(width: 8),
                                              Text('Reset Prompt',
                                                  style: TextStyleConstants
                                                      .medium),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const UISpace(height: 48),
                              ])),
                    ),
                  ),
                ],
              )),
            ),
          ),
          _isLoading == true
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.withOpacity(0.4),
                  child: Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      size: 80,
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Future<GenerateContentResponse> _submitPrompt(
      GenerativeModel model,
      PromptObject prompt,
      String additionalInformation,
      List<DataPart>? images) async {
    setState(() {
      _isLoading = true;
    });
    textFieldFocus.unfocus();
    return await GeminiService.generateContent(
        model, prompt, additionalInformation, images);
  }

  Future<void> getImage() async {
    ImagePicker imagePicker = ImagePicker();
    final img = await imagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      imgData.image!.add(Image(image: FileImage(File(img.path))));
      imgData.imageData!.add(DataPart(lookupMimeType(img.path).toString(),
          File(img.path).readAsBytesSync()));
      setState(() {});
    }
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
}
