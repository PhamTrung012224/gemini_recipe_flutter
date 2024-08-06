import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:choice/choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/authentication_bloc/authentication_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/recipe_screen/recipe_screen.dart';
import 'package:gemini_cookbook/src/config/presentations/recipe_screen/save_recipe_bloc/save_recipe_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mime/mime.dart';
import 'package:safe_text/safe_text.dart';

import '../../components/gradient_text.dart';
import '../../themes/color_source.dart';
import '../main_screen/my_user/my_user_event.dart';
import '../main_screen/my_user/update_user_image/update_user_profile_bloc.dart';
import '../main_screen/my_user/update_user_image/update_user_profile_state.dart';
import '../profile_screen/profile_screen.dart';
import 'bloc/choose_screen_bloc.dart';
import 'bloc/choose_screen_event.dart';
import 'bloc/choose_screen_state.dart';
import '../main_screen/my_user/my_user_bloc.dart';
import '../main_screen/my_user/my_user_state.dart';


const String _apiKey = String.fromEnvironment('API_KEY');

class ChooseScreen extends StatefulWidget {
  const ChooseScreen({super.key});
  @override
  State<ChooseScreen> createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  BuildContext? _context;

  int currentStep = 0;
  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;

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
  final recipeCollection = FirebaseFirestore.instance.collection('recipes');
  late String? imageUrl;
  late String userName;
  bool _isLoadingRecipe = false;
  bool isDarkMode = false;

  List<Step> steps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text(
            "Let's Talk About Ingredients!",
            style: TextStyleConstants.stepTitle,
          ),
          content:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: getImage,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, top: 12, bottom: 8, right: 10),
                      child: Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Show me pictures of your ingredients',
                                style: TextStyleConstants.medium,
                              ),
                              const UISpace(height: 10),
                              Row(
                                children: [
                                  Container(
                                    height: (MediaQuery.of(context).size.width -
                                            120) /
                                        3,
                                    width: (MediaQuery.of(context).size.width -
                                            120) /
                                        3,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Transform.scale(
                                        scale: 1.8,
                                        child:
                                            const Icon(Icons.image_outlined)),
                                  ),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width -
                                                120) *
                                            2 /
                                            3 +
                                        16,
                                    height: (MediaQuery.of(context).size.width -
                                            120) /
                                        3,
                                    child: (imgData.image?.isNotEmpty ?? false)
                                        ? ListView.builder(
                                            padding:
                                                const EdgeInsets.only(right: 4),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, idx) => Row(
                                              children: [
                                                const SizedBox(width: 4),
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(12)),
                                                  child: Stack(children: [
                                                    Image(
                                                      image: imgData
                                                          .image![idx].image,
                                                      height: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              120) /
                                                          3,
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              120) /
                                                          3,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          imgData.image!
                                                              .removeAt(idx);
                                                          imgData.imageData!
                                                              .removeAt(idx);
                                                        });
                                                      },
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 2,
                                                                left: 76),
                                                        child: Icon(
                                                            Icons
                                                                .remove_circle_outline,
                                                            color: ColorConstants
                                                                .removeButtonColor),
                                                      ),
                                                    )
                                                  ]),
                                                ),
                                              ],
                                            ),
                                            itemCount: imgData.image!.length,
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
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 12, bottom: 8),
                    child: Container(
                        alignment: Alignment.topLeft,
                        child: Text('Share your marinade with me!',
                            style: TextStyleConstants.medium)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 12),
                    child: InlineChoice.multiple(
                        itemCount: ingredients.length,
                        itemBuilder: (context, idx) =>
                            BlocBuilder<ChooseScreenBloc, ChooseScreenState>(
                              builder: (context, state) {
                                return ChoiceChip(
                                  label: Text(
                                    ingredients[idx],
                                    style: TextStyleConstants.semiMedium,
                                  ),
                                  selected: state.isIngredientsSelected[idx],
                                  onSelected: (bool value) {
                                    //New list
                                    List<bool> list =
                                        List.from(state.isIngredientsSelected);
                                    list[idx] = value;
                                    //New ingredient
                                    String tempIngredients = '';
                                    for (var i = 0; i < list.length; i++) {
                                      if (list[i] == true) {
                                        tempIngredients +=
                                            '${ingredients[i]}, ';
                                      }
                                    }
                                    //
                                    context.read<ChooseScreenBloc>().add(
                                        TapIngredientChip(
                                            isIngredientsSelected: list,
                                            ingredientsPrompt: PromptObject(
                                                cuisines: state.prompt.cuisines,
                                                dietaryRestrictions: state
                                                    .prompt.dietaryRestrictions,
                                                meal: state.prompt.meal,
                                                ingredients: tempIngredients)));
                                  },
                                );
                              },
                            )),
                  )
                ],
              ),
            ),
          ]),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text('What kind of cuisines are you craving?',
              style: TextStyleConstants.stepTitle),
          content: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 12, top: 12),
                  child: InlineChoice.multiple(
                      itemCount: cuisines.length,
                      itemBuilder: (context, idx) =>
                          BlocBuilder<ChooseScreenBloc, ChooseScreenState>(
                            builder: (context, state) {
                              return ChoiceChip(
                                label: Text(
                                  cuisines[idx],
                                  style: TextStyleConstants.semiMedium,
                                ),
                                selected: state.isCuisinesSelected[idx],
                                onSelected: (bool value) {
                                  List<bool> list =
                                      List.from(state.isCuisinesSelected);
                                  list[idx] = value;
                                  String tempCuisines = '';
                                  for (var i = 0; i < list.length; i++) {
                                    if (list[i] == true) {
                                      tempCuisines += '${cuisines[i]}, ';
                                    }
                                  }
                                  context.read<ChooseScreenBloc>().add(
                                      TapCuisineChip(
                                          isCuisineSelected: list,
                                          cuisinesPrompt: PromptObject(
                                              ingredients:
                                                  state.prompt.ingredients,
                                              dietaryRestrictions: state
                                                  .prompt.dietaryRestrictions,
                                              meal: state.prompt.meal,
                                              cuisines: tempCuisines)));
                                },
                              );
                            },
                          )),
                )
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text('What are we cooking today?',
              style: TextStyleConstants.stepTitle),
          content: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 8, bottom: 12),
                  child: InlineChoice.multiple(
                      itemCount: meal.length,
                      itemBuilder: (context, idx) =>
                          BlocBuilder<ChooseScreenBloc, ChooseScreenState>(
                            builder: (context, state) {
                              return ChoiceChip(
                                label: Text(
                                  meal[idx],
                                  style: TextStyleConstants.semiMedium,
                                ),
                                selected: state.isMealSelected[idx],
                                onSelected: (bool value) {
                                  //New list
                                  List<bool> list =
                                      List.from(state.isMealSelected);
                                  list[idx] = value;
                                  //New ingredient
                                  String tempMeal = '';
                                  for (var i = 0; i < list.length; i++) {
                                    if (list[i] == true) {
                                      tempMeal += '${meal[i]}, ';
                                    }
                                  }
                                  //
                                  context.read<ChooseScreenBloc>().add(
                                      TapMealChip(
                                          isMealSelected: list,
                                          mealPrompt: PromptObject(
                                              cuisines: state.prompt.cuisines,
                                              dietaryRestrictions: state
                                                  .prompt.dietaryRestrictions,
                                              ingredients:
                                                  state.prompt.ingredients,
                                              meal: tempMeal)));
                                },
                              );
                            },
                          )),
                )
              ],
            ),
          ),
        ),
        Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: Text('Any allergies or dietary needs I know about?',
              style: TextStyleConstants.stepTitle),
          content: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 12, top: 12),
                  child: InlineChoice.multiple(
                      itemCount: dietaryRestrictions.length,
                      itemBuilder: (context, idx) =>
                          BlocBuilder<ChooseScreenBloc, ChooseScreenState>(
                            builder: (context, state) {
                              return ChoiceChip(
                                label: Text(
                                  dietaryRestrictions[idx],
                                  style: TextStyleConstants.semiMedium,
                                ),
                                selected:
                                    state.isDietaryRestrictionsSelected[idx],
                                onSelected: (bool value) {
                                  List<bool> list = List.from(
                                      state.isDietaryRestrictionsSelected);
                                  list[idx] = value;
                                  String tempDietaryRestrictions = '';
                                  for (var i = 0; i < list.length; i++) {
                                    if (list[i] == true) {
                                      tempDietaryRestrictions +=
                                          '${dietaryRestrictions[i]}, ';
                                    }
                                  }
                                  context.read<ChooseScreenBloc>().add(
                                      TapDietaryRestrictionChip(
                                          isDietaryRestrictionSelected: list,
                                          dietaryRestrictionPrompt: PromptObject(
                                              ingredients:
                                                  state.prompt.ingredients,
                                              cuisines: state.prompt.cuisines,
                                              meal: state.prompt.meal,
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
        ),
        Step(
            state: currentStep > 4 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 4,
            title: Text(
                "Anything else you'd like to add? (ingredients, desired dish, etc.)",
                style: TextStyleConstants.stepTitle),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: BlocBuilder<ChooseScreenBloc, ChooseScreenState>(
                    builder: (context, state) {
                      return TextField(
                        style: TextStyleConstants.semiMedium,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8, right: 8),
                            hintText: 'Additional information...'),
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
              ],
            )),
        Step(
            state: currentStep > 5 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 5,
            title: Text("Let's Find Your Perfect Recipe!",
                style: TextStyleConstants.stepTitle),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BlocBuilder<ChooseScreenBloc, ChooseScreenState>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () async {
                              showDialog<String>(
                                  builder: (context) => Dialog(
                                        child: SingleChildScrollView(
                                            child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12,
                                              top: 16,
                                              bottom: 16,
                                              right: 12),
                                          child: Text(
                                            "${state.prompt.prompt} \n\nAlso include these following information if these information related to food or ingredients: ${textEditingController.value.text}",
                                            style: TextStyleConstants.normal,
                                          ),
                                        )),
                                      ),
                                  context: context);
                            },
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.info_outline_rounded),
                                  const SizedBox(width: 6),
                                  Text('Full Prompt',
                                      style: TextStyleConstants.medium),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 7.4,
                      ),
                      Expanded(
                        child: BlocBuilder<MyUserBloc, MyUserState>(
                          builder: (context, userState) {
                            return BlocBuilder<ChooseScreenBloc,
                                ChooseScreenState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () async {
                                    try {
                                      String filteredText;
                                      try {
                                        filteredText = SafeText.filterText(
                                          text: textEditingController.value.text,
                                          extraWords: Constants.extraBadWords,
                                          useDefaultWords: true,
                                          fullMode: true,
                                          obscureSymbol: "",
                                        );
                                      } on FormatException {
                                        // Handle specific exception for text formatting
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.blueGrey,
                                            content: Text(
                                              'Format Error: Please avoid using Special Characters !, #, [, +, ...',
                                              style:
                                                  TextStyleConstants.semiNormal,
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
                                        'Additional information is: $filteredText',
                                        imgData.imageData,
                                      );
                        
                                      final Map<String, dynamic> jsonMap =
                                          json.decode(res.text.toString());
                                      final PromptResponse response =
                                          PromptResponse.fromJson(jsonMap);
                                      imgData.resetData();
                                      textEditingController.clear();
                                      final res1 = await getYoutubeResponse(
                                          'How to make ${response.title}', 5);
                        
                                      final YoutubeResponse response1 =
                                          YoutubeResponse.fromJson(res1);
                        
                                      _context!
                                          .read<ChooseScreenBloc>()
                                          .add(TapResetPromptEvent());
                                      currentStep = 0;
                        
                                      final savedCheck = await recipeCollection
                                          .where('ownerId',
                                              isEqualTo: userState.user!.userId)
                                          .where('title',
                                              isEqualTo: response.title)
                                          .get();
                                      setState(() {
                                        _isLoadingRecipe = false;
                                      });
                                      Navigator.of(_context!).push(
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) => SaveRecipeBloc(
                                                userRepository: context
                                                    .read<AuthenticationBloc>()
                                                    .userRepository),
                                            child: RecipeScreen(
                                              userId: userState.user!.userId,
                                              promptResponse: response,
                                              youtubeResponse: response1,
                                              savedCheck: savedCheck.size >= 1
                                                  ? true
                                                  : false,
                                            ),
                                          ),
                                        ),
                                      );
                                    } on HttpException {
                                      // Handle network-related exceptions
                                      ScaffoldMessenger.of(_context!)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.blueGrey,
                                          content: Text(
                                            'Network Error: Unable to submit your request.',
                                            style: TextStyleConstants.semiNormal,
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        _isLoadingRecipe = false;
                                      });
                                    } catch (e) {
                                      // Handle any other exceptions that weren't caught by the specific catches
                                      log(e.toString());
                                      ScaffoldMessenger.of(_context!)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.blueGrey,
                                          content: Text(
                                            'An unexpected error occurred. Please try again.',
                                            style: TextStyleConstants.semiNormal,
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        _isLoadingRecipe = false;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: 48,
                                    padding:
                                        const EdgeInsets.only(left: 4, right: 4),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.send_sharp),
                                        const SizedBox(width: 4),
                                        Text('Submit Prompt',
                                            style: TextStyleConstants.medium),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const UISpace(height: 20),
                BlocBuilder<ChooseScreenBloc, ChooseScreenState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        currentStep = 0;
                        imgData.resetData();
                        textEditingController.clear();
                        context
                            .read<ChooseScreenBloc>()
                            .add(TapResetPromptEvent());
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.restart_alt),
                              const SizedBox(width: 8),
                              Text('Reset Prompt',
                                  style: TextStyleConstants.medium),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            )),
      ];

  @override
  void initState() {
    _model = GenerativeModel(
      safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high)
      ],
      model: "gemini-1.5-flash",
      apiKey: _apiKey,
    );
    textEditingController = TextEditingController();
    textFieldFocus = FocusNode();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    isDarkMode = (Theme.of(context).brightness == Brightness.dark);
    _context = context;
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
    return BlocListener<UpdateUserProfileBloc, UpdateUserProfileState>(
      listener: (context, state) {
        if (state is UploadPictureSuccess || state is UploadUsernameSuccess) {
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
              height: MediaQuery.of(context).size.width * 0.2,
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
          GestureDetector(
            onTap: () {
              textFieldFocus.unfocus();
            },
            child: SafeArea(
              child: Scaffold(
                  body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12))),
                          width: 42,
                          height: 42,
                          child: const Icon(Icons.chevron_left, size: 26)),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    expandedHeight: MediaQuery.of(context).size.height * 0.28,
                    stretchTriggerOffset:
                        MediaQuery.of(context).size.height * 0.28,
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
                              padding:
                                  const EdgeInsets.only(left: 42, right: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child:
                                          BlocBuilder<MyUserBloc, MyUserState>(
                                        builder: (context, state) {
                                          return Text(
                                            "Hey ${state.user?.name ?? ''}!",
                                            style: TextStyleConstants.title,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
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
                                              Navigator.of(_context!).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ProfileScreen()));
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
                                                      child: CachedNetworkImage(
                                                        imageUrl:
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
                                      "Tell me what ingredients you have and I'll create a recipe for you!",
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
                                child: GradientText(
                                  'Create a recipe',
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
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(50))),
                      child: Stepper(
                          physics: const NeverScrollableScrollPhysics(),
                          steps: steps(),
                          currentStep: currentStep,
                          onStepTapped: (step) => setState(() {
                                currentStep = step;
                              }),
                          onStepContinue: () {
                            if (isLastStep) {
                            } else {
                              setState(() {
                                currentStep = currentStep + 1;
                              });
                            }
                          },
                          onStepCancel: isFirstStep
                              ? null
                              : () =>
                                  setState(() => currentStep = currentStep - 1),
                          controlsBuilder: (context, details) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: isLastStep
                                  ? null
                                  : Row(children: [
                                      Expanded(
                                          child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)))),
                                        onPressed: details.onStepContinue,
                                        child: GradientText(
                                          'Next step',
                                          style: TextStyleConstants.headline2,
                                          gradient: LinearGradient(colors: [
                                            Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                          ]),
                                        ),
                                      )),
                                      if (!isFirstStep) ...[
                                        const SizedBox(width: 16),
                                        Expanded(
                                            child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4)))),
                                          onPressed: details.onStepCancel,
                                          child: Text('Back',
                                              style:
                                                  TextStyleConstants.headline2),
                                        )),
                                      ]
                                    ]),
                            );
                          }),
                    ),
                  ),
                ],
              )),
            ),
          ),
          _isLoadingRecipe == true
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.withOpacity(0.4),
                  child: Center(
                    child: Lottie.asset(LottieConstants.cookingAnimation,
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.4),
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
      _isLoadingRecipe = true;
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

  @override
  void dispose() {
    _context = null;
    super.dispose();
  }
}
