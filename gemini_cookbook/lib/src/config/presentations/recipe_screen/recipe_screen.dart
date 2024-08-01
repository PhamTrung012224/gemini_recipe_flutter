import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/components/ui_icon.dart';
import 'package:gemini_cookbook/src/config/components/ui_space.dart';
import 'package:gemini_cookbook/src/config/constants/constants.dart';
import 'package:gemini_cookbook/src/config/models/objects/prompt_response_object.dart';
import 'package:gemini_cookbook/src/config/models/objects/youtube_response_object.dart';
import 'package:gemini_cookbook/src/config/presentations/recipe_screen/save_recipe_bloc/save_recipe_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/recipe_screen/save_recipe_bloc/save_recipe_event.dart';
import 'package:gemini_cookbook/src/config/presentations/recipe_screen/save_recipe_bloc/save_recipe_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_repository/user_repository.dart';

import '../../components/gradient_text.dart';

class RecipeScreen extends StatefulWidget {
  final String userId;
  final PromptResponse promptResponse;
  final YoutubeResponse youtubeResponse;
  final bool savedCheck;
  const RecipeScreen(
      {super.key,
      required this.userId,
      required this.promptResponse,
      required this.youtubeResponse,
      required this.savedCheck});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late String userRecipeId;
  late String suggestRecipeId;
  late final String meal;
  late final String allergens;
  late final String servings;
  late final NutritionInformation nutritionInformation;
  late final List<String> ingredients;
  late final List<Instructions> instructions;
  late final List<YoutubeItem> youtubeResults;
  late List<bool> isOnSwitch;
  bool isDarkMode = false;
  late bool isSaving;
  bool isLoading = false;

  @override
  void initState() {
    userRecipeId = FirebaseFirestore.instance.collection("recipes").doc().id;
    suggestRecipeId =
        FirebaseFirestore.instance.collection("suggest_recipes").doc().id;
    isSaving = widget.savedCheck;
    meal = widget.promptResponse.meal;
    allergens = widget.promptResponse.allergens;
    servings = widget.promptResponse.servings;
    nutritionInformation = widget.promptResponse.nutritionInformation;
    ingredients = widget.promptResponse.ingredients;
    instructions = widget.promptResponse.instructions;
    youtubeResults = widget.youtubeResponse.items;

    isOnSwitch = List.filled(instructions.length, false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    isDarkMode = (Theme.of(context).brightness == Brightness.dark);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SaveRecipeBloc, SaveRecipeState>(
      listener: (context, state) {
        if (state is SavingProcess) {
          setState(() {
            isLoading = true;
          });
        } else if (state is SavingSuccess) {
          setState(() {
            isSaving = !isSaving;
            isLoading = false;
          });
        } else if (state is SavingFailure) {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            elevation: 6,
            backgroundColor:
                !isSaving ? Colors.greenAccent.shade700 : Colors.red,
            onPressed: () async {
              if (!isSaving) {
                MyUserRecipe userRecipe = MyUserRecipe.empty;
                userRecipe = userRecipe.copyWith(
                    userId: userRecipeId,
                    ownerId: widget.userId,
                    recipeJson: widget.promptResponse.toJson(),
                    youtubeJson: widget.youtubeResponse.toJson(),
                    title: widget.promptResponse.title);
                setState(() {
                  context
                      .read<SaveRecipeBloc>()
                      .add(SaveRecipeRequired(myUserRecipe: userRecipe));
                });
              } else {
                setState(() {
                  context.read<SaveRecipeBloc>().add(RemoveRecipeRequired(
                      userId: widget.userId,
                      recipeTitle: widget.promptResponse.title));
                  isSaving = !isSaving;
                });
                userRecipeId =
                    FirebaseFirestore.instance.collection("recipes").doc().id;
              }
            },
            label: Text(
              !isSaving ? 'Save' : 'Remove',
              style: TextStyleConstants.headline1,
            ),
            icon: !isSaving
                ? UIIcon(
                    size: 32,
                    icon: IconConstants.unsavedRecipeIcon,
                    color: Theme.of(context).colorScheme.onSurface)
                : !isLoading
                    ? UIIcon(
                        size: 32,
                        icon: IconConstants.savedRecipeIcon,
                        color: Theme.of(context).colorScheme.onSurface)
                    : const CircularProgressIndicator()),
        body: Stack(
          children: [
            (youtubeResults.isNotEmpty)
                ? Image.network(
                    'https://img.youtube.com/vi/${youtubeResults[0].id.videoId}/mqdefault.jpg',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.width * 0.78,
                    width: MediaQuery.of(context).size.width * 0.78 / 9 * 16,
                    filterQuality: FilterQuality.medium,
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: isDarkMode
                            ? const AssetImage(
                                ImageConstants.recipeDarkBackground)
                            : const AssetImage(ImageConstants.recipeBackground),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  toolbarHeight: 84,
                  actions: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 12, bottom: 24, left: 6, right: 6),
                      decoration:
                          const BoxDecoration(color: Colors.transparent),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                width: 48,
                                height: 48,
                                child:
                                    const Icon(Icons.chevron_left, size: 28)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width -
                                48 -
                                12 -
                                32 -
                                MediaQuery.of(context).size.width * 0.16,
                          ),
                          GestureDetector(
                            onTap: () => showDialog<String>(
                                context: context,
                                builder: (context) => Dialog(
                                      child: SingleChildScrollView(
                                          child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24,
                                            top: 24,
                                            bottom: 24,
                                            right: 24),
                                        child: Text(
                                          widget.promptResponse.description,
                                          style: TextStyleConstants.semiMedium,
                                          textAlign: TextAlign.left,
                                        ),
                                      )),
                                    )),
                            child: Container(
                                alignment: Alignment.center,
                                width: 32 +
                                    MediaQuery.of(context).size.width * 0.16,
                                height: 48,
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                child: Text(
                                  'Facts',
                                  style: TextStyleConstants.headline2,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                  expandedHeight: MediaQuery.of(context).size.height * 0.2,
                  backgroundColor: Colors.transparent,
                ),
                SliverToBoxAdapter(
                    child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.04),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(24),
                              topLeft: Radius.circular(24))),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: MediaQuery.of(context).size.height * 0.14),
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 32,
                          ),
                          const UISpace(height: 16),
                          Container(
                            width: MediaQuery.of(context).size.width - 32,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: Constants.borderRadius),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: UIIcon(
                                          size: 26,
                                          icon: IconConstants.mealIcon,
                                          color: Colors.orange),
                                    ),
                                    GradientText(
                                      'Meal',
                                      style: TextStyleConstants.title,
                                      gradient: LinearGradient(colors: [
                                        Colors.orange.shade300,
                                        Colors.orange.shade300
                                      ]),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface))),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          meal,
                                          style:
                                              TextStyleConstants.recipeContent,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const UISpace(height: 16),
                          Container(
                            width: MediaQuery.of(context).size.width - 32,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: Constants.borderRadius),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: UIIcon(
                                          size: 26,
                                          icon: IconConstants.allergensIcon,
                                          color: Colors.red),
                                    ),
                                    GradientText(
                                      'Allergens',
                                      style: TextStyleConstants.title,
                                      gradient: LinearGradient(colors: [
                                        Colors.red.shade300,
                                        Colors.red.shade300
                                      ]),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface))),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          allergens,
                                          style:
                                              TextStyleConstants.recipeContent,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const UISpace(height: 16),
                          Container(
                            width: MediaQuery.of(context).size.width - 32,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: Constants.borderRadius),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: UIIcon(
                                          size: 26,
                                          icon: IconConstants.servingsIcon,
                                          color: Colors.brown.shade700),
                                    ),
                                    GradientText(
                                      'Servings',
                                      style: TextStyleConstants.title,
                                      gradient: LinearGradient(colors: [
                                        Colors.brown.shade300,
                                        Colors.brown.shade300
                                      ]),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface))),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          servings,
                                          style:
                                              TextStyleConstants.recipeContent,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const UISpace(height: 16),
                          Container(
                            width: MediaQuery.of(context).size.width - 32,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: Constants.borderRadius),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: UIIcon(
                                          size: 26,
                                          icon: IconConstants.nutritionIcon,
                                          color: Colors.yellow.shade600),
                                    ),
                                    GradientText(
                                      'Nutrition per serving',
                                      style: TextStyleConstants.title,
                                      gradient: LinearGradient(colors: [
                                        Colors.yellow.shade600,
                                        Colors.yellow.shade600
                                      ]),
                                    ),
                                  ],
                                ),
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '- Carbohydrates: ${nutritionInformation.carbohydrates}',
                                            style: TextStyleConstants
                                                .recipeContent),
                                        Text(
                                            '- Cholesterol: ${nutritionInformation.cholesterol}',
                                            style: TextStyleConstants
                                                .recipeContent),
                                        Text(
                                            '- Fat: ${nutritionInformation.fat}',
                                            style: TextStyleConstants
                                                .recipeContent),
                                        Text(
                                            '- Fiber: ${nutritionInformation.fiber}',
                                            style: TextStyleConstants
                                                .recipeContent),
                                        Text(
                                            '- Protein: ${nutritionInformation.protein}',
                                            style: TextStyleConstants
                                                .recipeContent),
                                        Text(
                                            '- Saturated Fat: ${nutritionInformation.saturatedFat}',
                                            style: TextStyleConstants
                                                .recipeContent),
                                        Text(
                                            '- Sodium: ${nutritionInformation.sodium}',
                                            style: TextStyleConstants
                                                .recipeContent),
                                        Text(
                                            '- Sugar: ${nutritionInformation.sugar}',
                                            style: TextStyleConstants
                                                .recipeContent),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          const UISpace(height: 24),
                          Container(
                            width: MediaQuery.of(context).size.width - 32,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: Constants.borderRadius),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: UIIcon(
                                          size: 26,
                                          icon: IconConstants.ingredientsIcon,
                                          color: Colors.green.shade500),
                                    ),
                                    GradientText(
                                      'Ingredients',
                                      style: TextStyleConstants.title,
                                      gradient: LinearGradient(colors: [
                                        Colors.green.shade300,
                                        Colors.green.shade300
                                      ]),
                                    ),
                                  ],
                                ),
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface))),
                                    child: ListView.builder(
                                      padding: const EdgeInsets.only(top: 0),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, idx) => Text(
                                        '- ${ingredients[idx]}',
                                        style: TextStyleConstants.recipeContent,
                                      ),
                                      itemCount: ingredients.length,
                                    ))
                              ],
                            ),
                          ),
                          const UISpace(height: 24),
                          Container(
                            width: MediaQuery.of(context).size.width - 32,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16))),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: UIIcon(
                                      size: 26,
                                      icon: IconConstants.instructionsIcon,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                GradientText(
                                  'Directions',
                                  style: TextStyleConstants.title,
                                  gradient: LinearGradient(colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.primary
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          const UISpace(height: 2),
                          Container(
                            width: MediaQuery.of(context).size.width - 32,
                            padding: const EdgeInsets.only(
                                top: 12, bottom: 16, left: 16, right: 16),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: Theme.of(context).colorScheme.background,
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 0),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, idx) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GradientText(
                                            'Step ${idx + 1}: ${instructions[idx].stepTitle}',
                                            style: TextStyleConstants.headline1,
                                            gradient: LinearGradient(colors: [
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                            ]),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isOnSwitch[idx] =
                                                    !isOnSwitch[idx];
                                              });
                                            },
                                            child: UIIcon(
                                                size: 24,
                                                icon: isOnSwitch[idx]
                                                    ? IconConstants.upIcon
                                                    : IconConstants.downIcon,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary)),
                                      ],
                                    ),
                                    isOnSwitch[idx]
                                        ? Text(
                                            instructions[idx]
                                                .detailInstructions,
                                            style: TextStyleConstants
                                                .recipeContent,
                                          )
                                        : const SizedBox
                                            .shrink(), // Changed from GestureDetector() to SizedBox.shrink()
                                  ],
                                ),
                              ),
                              itemCount: instructions.length,
                            ),
                          ),
                          const UISpace(height: 24),
                          (youtubeResults.isNotEmpty)
                              ? Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          32,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16))),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: UIIcon(
                                                size: 26,
                                                icon: IconConstants.youtubeIcon,
                                                color: Colors.red),
                                          ),
                                          GradientText(
                                            'Reference Videos',
                                            style: TextStyleConstants.title,
                                            gradient: const LinearGradient(
                                                colors: [
                                                  Colors.red,
                                                  Colors.red
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const UISpace(height: 2),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          32,
                                      padding: const EdgeInsets.only(top: 12),
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                      child: ListView.builder(
                                        padding: const EdgeInsets.only(top: 0),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, idx) =>
                                            Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 16, right: 16),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        width: 2))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    final url = Uri.parse(
                                                        'https://www.youtube.com/watch?v=${youtubeResults[idx].id.videoId}');
                                                    if (await canLaunchUrl(
                                                        url)) {
                                                      await launchUrl(url,
                                                          webViewConfiguration:
                                                              const WebViewConfiguration());
                                                    }
                                                  },
                                                  child: Image.network(
                                                    'https://img.youtube.com/vi/${youtubeResults[idx].id.videoId}/mqdefault.jpg',
                                                    width: MediaQuery.of(context).size.width -
                                                        32,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Text(
                                                  youtubeResults[idx]
                                                      .snippet
                                                      .title,
                                                  style: TextStyleConstants
                                                      .recipeContentBold,
                                                ),
                                                Text(
                                                  'Channel: ${youtubeResults[idx].snippet.channelTitle}',
                                                  style:
                                                      TextStyleConstants.normal,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        itemCount: youtubeResults.length,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          const UISpace(height: 48),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        color: Theme.of(context).colorScheme.surface,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        elevation: 8,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 32,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: Constants.borderRadius),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(
                                          top: 8,
                                          left: 12,
                                          right: 12,
                                          bottom: 8),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                                  width: 2))),
                                      child: Text(
                                        widget.promptResponse.title,
                                        textAlign: TextAlign.center,
                                        style: TextStyleConstants
                                            .headline2, // Handle text overflow with ellipsis
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(top: 10,bottom: 16),
                                    width: (MediaQuery.of(context).size.width -
                                            64) /
                                        3,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 4.0),
                                          child: UIIcon(
                                              size: 40,
                                              icon: IconConstants.clockIcon,
                                              color: Colors.green.shade400),
                                        ),
                                        Text(
                                          widget.promptResponse.totalRecipeTime,
                                          textAlign: TextAlign.center,
                                          style: TextStyleConstants
                                              .recipeContentBold,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(top: 10,bottom: 16),
                                    width: (MediaQuery.of(context).size.width -
                                            64) /
                                        3,
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 4.0),
                                          child: UIIcon(
                                              size: 40,
                                              icon: IconConstants.caloriesIcon,
                                              color: Colors.red),
                                        ),
                                        Text(
                                          widget.promptResponse.calories,
                                          textAlign: TextAlign.center,
                                          style: TextStyleConstants
                                              .recipeContentBold,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(top: 13,bottom: 16),
                                    width: (MediaQuery.of(context).size.width -
                                            64) /
                                        3,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 4.0),
                                          child: UIIcon(
                                              size: 36,
                                              icon: IconConstants.chefHatIcon,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                        Text(
                                          widget.promptResponse.level,
                                          textAlign: TextAlign.center,
                                          style: TextStyleConstants
                                              .recipeContentBold,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
