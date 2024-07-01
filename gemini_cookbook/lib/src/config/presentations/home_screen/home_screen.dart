import 'dart:convert';
import 'dart:io';

import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/components/ui_space.dart';
import 'package:gemini_cookbook/src/config/constants/constants.dart';
import 'package:gemini_cookbook/src/config/models/objects/image_object.dart';
import 'package:gemini_cookbook/src/config/models/objects/prompt_object.dart';
import 'package:gemini_cookbook/src/config/models/objects/prompt_response_object.dart';
import 'package:gemini_cookbook/src/config/models/services/gemini.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/home_screen_event.dart';
import 'package:gemini_cookbook/src/config/presentations/recipe_screen/recipe_screen.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';


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
    'Moroccan',
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
  @override
  void initState() {
    _model = GenerativeModel(
      safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.low),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.low),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.low),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.low)
      ],
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
    textEditingController = TextEditingController();
    textFieldFocus = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                background: Column(children: [
                  UISpace(height: MediaQuery.of(context).size.height * 0.015),
                  Row(
                    children: [
                      const Icon(Icons.account_circle_outlined),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Meowdy! Let's get cooking!",
                            style: TextStyleConstants.headline1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  UISpace(height: MediaQuery.of(context).size.height * 0.048),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Tell me what ingredients you have and what you're feelin, and I'll create a recipe for you!",
                            style: TextStyleConstants.medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ColoredBox(
                    color: Theme.of(context).colorScheme.background,
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(50)),
                        child: ColoredBox(
                            color: Theme.of(context).colorScheme.primary,
                            child: UISpace(
                                height: MediaQuery.of(context).size.height *
                                    0.048))),
                  ),
                ]),
                title: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(50))),
                  child: Row(
                    children: [
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.013, left: 8,bottom:MediaQuery.of(context).size.height * 0.013),
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
                    borderRadius:
                        const BorderRadius.only(topRight: Radius.circular(50))),
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
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      'Create a recipe:',
                                      style: TextStyleConstants.semiMedium,
                                    ),
                                  ))),
                          const UISpace(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).colorScheme.background,
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
                                              style: TextStyleConstants.medium,
                                            ),
                                            const UISpace(height: 10),
                                            Row(
                                              children: [
                                                Container(
                                                  height:
                                                      (MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              52) /
                                                          3,
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          52) /
                                                      3,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
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
                                                  width: (MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              52) *
                                                          2 /
                                                          3 +
                                                      16,
                                                  height:
                                                      (MediaQuery.of(context)
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
                                                                  right: 4),
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemBuilder:
                                                              (context, idx) =>
                                                                  Row(
                                                            children: [
                                                              const SizedBox(
                                                                  width: 4),
                                                              ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            12)),
                                                                child: Stack(
                                                                    children: [
                                                                      Image(
                                                                        image: imgData
                                                                            .image![idx]
                                                                            .image,
                                                                        height:
                                                                            (MediaQuery.of(context).size.width - 52) /
                                                                                3,
                                                                        width:
                                                                            (MediaQuery.of(context).size.width - 52) /
                                                                                3,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            imgData.image!.removeAt(idx);
                                                                            imgData.imageData!.removeAt(idx);
                                                                          });
                                                                        },
                                                                        child:
                                                                            const Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top: 2,
                                                                              left: 76),
                                                                          child: Icon(
                                                                              Icons.remove_circle_outline,
                                                                              color: ColorConstants.removeButtonColor),
                                                                        ),
                                                                      )
                                                                    ]),
                                                              ),
                                                            ],
                                                          ),
                                                          itemCount: imgData
                                                              .image!.length,
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
                            color: Theme.of(context).colorScheme.background,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 12, bottom: 8),
                                  child: Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          'I also have these staple ingredients:',
                                          style: TextStyleConstants.medium)),
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
                                                  style: TextStyleConstants
                                                      .semiMedium,
                                                ),
                                                selected: state
                                                    .isIngredientsSelected[idx],
                                                onSelected: (bool value) {
                                                  //New list
                                                  List<bool> list = List.from(
                                                      state
                                                          .isIngredientsSelected);
                                                  list[idx] = value;
                                                  //New ingredient
                                                  String tempIngredients = '';
                                                  for (var i = 0;
                                                      i < list.length;
                                                      i++) {
                                                    if (list[i] == true) {
                                                      tempIngredients +=
                                                          '${ingredients[i]}, ';
                                                    }
                                                  }
                                                  //
                                                  context
                                                      .read<HomeScreenBloc>()
                                                      .add(TapIngredientChip(
                                                          isIngredientsSelected:
                                                              list,
                                                          ingredientsPrompt: PromptObject(
                                                              cuisines: state
                                                                  .prompt
                                                                  .cuisines,
                                                              dietaryRestrictions:
                                                                  state.prompt
                                                                      .dietaryRestrictions,
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
                            color: Theme.of(context).colorScheme.background,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 12, bottom: 8),
                                  child: Container(
                                      alignment: Alignment.topLeft,
                                      child: Text("I'm in the mood for:",
                                          style: TextStyleConstants.medium)),
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
                                                  style: TextStyleConstants
                                                      .semiMedium,
                                                ),
                                                selected: state
                                                    .isCuisinesSelected[idx],
                                                onSelected: (bool value) {
                                                  List<bool> list = List.from(
                                                      state.isCuisinesSelected);
                                                  list[idx] = value;
                                                  String tempCuisines = '';
                                                  for (var i = 0;
                                                      i < list.length;
                                                      i++) {
                                                    if (list[i] == true) {
                                                      tempCuisines +=
                                                          '${cuisines[i]}, ';
                                                    }
                                                  }
                                                  context
                                                      .read<HomeScreenBloc>()
                                                      .add(TapCuisineChip(
                                                          isCuisineSelected:
                                                              list,
                                                          cuisinesPrompt: PromptObject(
                                                              ingredients: state
                                                                  .prompt
                                                                  .ingredients,
                                                              dietaryRestrictions:
                                                                  state.prompt
                                                                      .dietaryRestrictions,
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
                            color: Theme.of(context).colorScheme.background,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 12, bottom: 8),
                                  child: Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          "I have the following dietary restrictions:",
                                          style: TextStyleConstants.medium)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, bottom: 12),
                                  child: InlineChoice.multiple(
                                      itemCount: dietaryRestrictions.length,
                                      itemBuilder: (context, idx) =>
                                          BlocBuilder<HomeScreenBloc,
                                              HomeScreenState>(
                                            builder: (context, state) {
                                              return ChoiceChip(
                                                label: Text(
                                                  dietaryRestrictions[idx],
                                                  style: TextStyleConstants
                                                      .semiMedium,
                                                ),
                                                selected: state
                                                        .isDietaryRestrictionsSelected[
                                                    idx],
                                                onSelected: (bool value) {
                                                  List<bool> list = List.from(state
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
                                                  context.read<HomeScreenBloc>().add(
                                                      TapDietaryRestrictionChip(
                                                          isDietaryRestrictionSelected:
                                                              list,
                                                          dietaryRestrictionPrompt: PromptObject(
                                                              ingredients: state
                                                                  .prompt
                                                                  .ingredients,
                                                              cuisines: state
                                                                  .prompt
                                                                  .cuisines,
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
                            color: Theme.of(context).colorScheme.background,
                            child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
                              builder: (context, state) {
                                return TextField(
                                  style: TextStyleConstants.semiMedium,
                                  decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 8, right: 8),
                                      hintText:
                                          'Enter additional information...'),
                                  controller: textEditingController,
                                  focusNode: textFieldFocus,
                                );
                              },
                            ),
                          ),
                          const UISpace(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                BlocBuilder<HomeScreenBloc, HomeScreenState>(
                                  builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog<String>(
                                            builder: (context) => Dialog(
                                                  child: SingleChildScrollView(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12,
                                                            top: 16,
                                                            bottom: 16,
                                                            right: 12),
                                                    child: Text(
                                                      '${state.prompt.prompt} \n\nLast but not least, also include the followings additional information: ${textEditingController.value.text}',
                                                      style: TextStyleConstants
                                                          .normal,
                                                    ),
                                                  )),
                                                ),
                                            context: context);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                            const Icon(
                                                Icons.info_outline_rounded),
                                            const SizedBox(width: 8),
                                            Text('Full Prompt',
                                                style:
                                                    TextStyleConstants.medium),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                BlocBuilder<HomeScreenBloc, HomeScreenState>(
                                  builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () async {
                                        final res = await _submitPrompt(
                                          _model,
                                          state.prompt,
                                          textEditingController.value.text,
                                          imgData.imageData,
                                        );
                                        final response=PromptResponse.fromJson(json.decode(res.text.toString()));
                                        imgData.resetData();
                                        textEditingController.clear();
                                        // ignore: use_build_context_synchronously
                                        context
                                            .read<HomeScreenBloc>()
                                            .add(TapResetPromptEvent());
                                        setState(() {});
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => RecipeScreen(
                                            promptResponse: response,
                                          ),
                                        ));

                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                                style:
                                                    TextStyleConstants.medium),
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
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    height: 48,
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                          const UISpace(height: 48),
                        ])),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Future<GenerateContentResponse> _submitPrompt(
      GenerativeModel model,
      PromptObject prompt,
      String additionalInformation,
      List<DataPart>? images) async {
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
}
