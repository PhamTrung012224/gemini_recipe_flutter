import 'package:flutter/material.dart';
import 'package:gemini_cookbook/src/config/components/ui_space.dart';
import 'package:gemini_cookbook/src/config/constants/constants.dart';
import 'package:gemini_cookbook/src/config/models/objects/prompt_response_object.dart';

class RecipeScreen extends StatefulWidget {
  final PromptResponse promptResponse;
  const RecipeScreen({super.key, required this.promptResponse});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 24, left: 6, right: 6),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32)),
                    color: Theme.of(context).colorScheme.primary),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () => {
                          if (Navigator.canPop(context))
                            {Navigator.pop(context)}
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onPrimary,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12))),
                            width: 48,
                            child: const Icon(size: 28, Icons.chevron_left)),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            widget.promptResponse.title,
                            style: TextStyleConstants
                                .title, // Add this line to handle overflow with ellipsis
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => showDialog<String>(
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
                                ),
                            context: context),
                        child: Container(
                            alignment: Alignment.center,
                            width:
                                32 + MediaQuery.of(context).size.width * 0.16,
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onPrimary,
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
              ),
            ),
            SliverToBoxAdapter(
                child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    child: Row(
                      children: [
                        Text('Allergens', style: TextStyleConstants.headline2),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            widget.promptResponse.allergens,
                          ),
                        )
                      ],
                    ),
                  ),
                  const UISpace(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    child: Row(
                      children: [
                        Text('Servings', style: TextStyleConstants.headline2),
                        const SizedBox(width: 12),
                        Text(widget.promptResponse.servings)
                      ],
                    ),
                  ),
                  const UISpace(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nutrition per serving',
                          style: TextStyleConstants.headline2),
                      const UISpace(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '- Calories: ${widget.promptResponse.nutritionInformation.calories}'),
                          Text(
                              '- Carbohydrates: ${widget.promptResponse.nutritionInformation.carbohydrates}'),
                          Text(
                              '- Cholesterol: ${widget.promptResponse.nutritionInformation.cholesterol}'),
                          Text(
                              '- Fat: ${widget.promptResponse.nutritionInformation.fat}'),
                          Text(
                              '- Fiber: ${widget.promptResponse.nutritionInformation.fiber}'),
                          Text(
                              '- Protein: ${widget.promptResponse.nutritionInformation.protein}'),
                          Text(
                              '- Saturated Fat: ${widget.promptResponse.nutritionInformation.saturatedFat}'),
                          Text(
                              '- Sodium: ${widget.promptResponse.nutritionInformation.sodium}'),
                          Text(
                              '- Sugar: ${widget.promptResponse.nutritionInformation.sugar}'),
                        ],
                      )
                    ],
                  ),
                  const UISpace(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ingredients', style: TextStyleConstants.headline2),
                      const UISpace(height: 8),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, idx) =>
                            Text('- ${widget.promptResponse.ingredients[idx]}'),
                        itemCount: widget.promptResponse.ingredients.length,
                      )
                    ],
                  ),
                  const UISpace(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Instructions', style: TextStyleConstants.headline2),
                      const UISpace(height: 8),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, idx) => Text(
                            '${idx + 1}. ${widget.promptResponse.instructions[idx]}'),
                        itemCount: widget.promptResponse.instructions.length,
                      ),
                      const UISpace(height: 48),
                    ],
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
