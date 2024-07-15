import 'package:flutter/material.dart';
import 'package:gemini_cookbook/src/config/components/ui_icon.dart';
import 'package:gemini_cookbook/src/config/components/ui_space.dart';
import 'package:gemini_cookbook/src/config/constants/constants.dart';
import 'package:gemini_cookbook/src/config/models/objects/prompt_response_object.dart';
import 'package:gemini_cookbook/src/config/models/objects/youtube_response_object.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/gradient_text.dart';

class RecipeScreen extends StatefulWidget {
  final PromptResponse promptResponse;
  final YoutubeResponse youtubeResponse;
  const RecipeScreen(
      {super.key, required this.promptResponse, required this.youtubeResponse});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late final String allergens;
  late final String servings;
  late final NutritionInformation nutritionInformation;
  late final List<String> ingredients;
  late final List<Instructions> instructions;
  late final List<YoutubeItem> youtubeResults;
  late List<bool> isOnSwitch;
  bool isDarkMode = false;

  @override
  void initState() {
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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: isDarkMode
                    ? const AssetImage(ImageConstants.recipeDarkBackground)
                    : const AssetImage(ImageConstants.recipeBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
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
                                        Theme.of(context).colorScheme.onPrimary,
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
                                            left: 12,
                                            top: 16,
                                            bottom: 16,
                                            right: 12),
                                        child: Text(
                                          widget.promptResponse.description,
                                          style: TextStyleConstants.semiMedium,
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
                                        Theme.of(context).colorScheme.onPrimary,
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
                  expandedHeight: MediaQuery.of(context).size.height * 0.3,
                  backgroundColor: Colors.transparent,
                ),
                SliverToBoxAdapter(
                    child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40))),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 32,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 18, bottom: 18, left: 20, right: 20),
                                child: Text(
                                  widget.promptResponse.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyleConstants
                                      .title, // Handle text overflow with ellipsis
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width - 32,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16))),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(top: 20),
                                width:
                                    (MediaQuery.of(context).size.width - 32) /
                                        3,
                                height:
                                    (MediaQuery.of(context).size.width - 32) /
                                        3,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: UIIcon(
                                          size: 48,
                                          icon: IconConstants.clockIcon,
                                          color: Colors.green.shade400),
                                    ),
                                    Text(
                                      widget.promptResponse.totalRecipeTime,
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyleConstants.recipeContentBold,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(top: 20),
                                width:
                                    (MediaQuery.of(context).size.width - 32) /
                                        3,
                                height:
                                    (MediaQuery.of(context).size.width - 32) /
                                        3,
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 4.0),
                                      child: UIIcon(
                                          size: 48,
                                          icon: IconConstants.caloriesIcon,
                                          color: Colors.red),
                                    ),
                                    Text(
                                      widget.promptResponse.calories,
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyleConstants.recipeContentBold,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(top: 20),
                                width:
                                    (MediaQuery.of(context).size.width - 32) /
                                        3,
                                height:
                                    (MediaQuery.of(context).size.width - 32) /
                                        3,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: UIIcon(
                                          size: 48,
                                          icon: IconConstants.chefHatIcon,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                    Text(
                                      widget.promptResponse.level,
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyleConstants.recipeContentBold,
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                      const UISpace(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width - 32,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16))),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface))),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      allergens,
                                      style: TextStyleConstants.recipeContent,
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16))),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface))),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      servings,
                                      style: TextStyleConstants.recipeContent,
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16))),
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '- Carbohydrates: ${nutritionInformation.carbohydrates}',
                                        style:
                                            TextStyleConstants.recipeContent),
                                    Text(
                                        '- Cholesterol: ${nutritionInformation.cholesterol}',
                                        style:
                                            TextStyleConstants.recipeContent),
                                    Text('- Fat: ${nutritionInformation.fat}',
                                        style:
                                            TextStyleConstants.recipeContent),
                                    Text(
                                        '- Fiber: ${nutritionInformation.fiber}',
                                        style:
                                            TextStyleConstants.recipeContent),
                                    Text(
                                        '- Protein: ${nutritionInformation.protein}',
                                        style:
                                            TextStyleConstants.recipeContent),
                                    Text(
                                        '- Saturated Fat: ${nutritionInformation.saturatedFat}',
                                        style:
                                            TextStyleConstants.recipeContent),
                                    Text(
                                        '- Sodium: ${nutritionInformation.sodium}',
                                        style:
                                            TextStyleConstants.recipeContent),
                                    Text(
                                        '- Sugar: ${nutritionInformation.sugar}',
                                        style:
                                            TextStyleConstants.recipeContent),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16))),
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface))),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
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
                                  color: Theme.of(context).colorScheme.primary),
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
                      const UISpace(height: 4),
                      Container(
                        width: MediaQuery.of(context).size.width - 32,
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 16, left: 16, right: 16),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, idx) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              color: Theme.of(context).colorScheme.background,
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
                                          Theme.of(context).colorScheme.primary,
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
                                            isOnSwitch[idx] = !isOnSwitch[idx];
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
                                        instructions[idx].detailInstructions,
                                        style: TextStyleConstants.recipeContent,
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
                      Container(
                        width: MediaQuery.of(context).size.width - 32,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
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
                                  colors: [Colors.red, Colors.red]),
                            ),
                          ],
                        ),
                      ),
                      const UISpace(height: 4),
                      Container(
                        width: MediaQuery.of(context).size.width - 32,
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 16, left: 16, right: 16),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, idx) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              color: Theme.of(context).colorScheme.background,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final url = Uri.parse(
                                        'https://www.youtube.com/watch?v=${youtubeResults[idx].id.videoId}');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url,
                                          webViewConfiguration:
                                              const WebViewConfiguration());
                                    }
                                  },
                                  child: Image.network(youtubeResults[idx]
                                      .snippet
                                      .thumbnails
                                      .high
                                      .url),
                                ),
                                Text(
                                  youtubeResults[idx].snippet.title,
                                  style: TextStyleConstants.recipeContentBold,
                                ),
                                Text(
                                  'Channel: ${youtubeResults[idx].snippet.channelTitle}',
                                  style: TextStyleConstants.normal,
                                ),
                              ],
                            ),
                          ),
                          itemCount: youtubeResults.length,
                        ),
                      ),
                      const UISpace(height: 48),
                    ],
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
