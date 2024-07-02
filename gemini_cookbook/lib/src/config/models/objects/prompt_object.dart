import 'package:equatable/equatable.dart';

class PromptObject extends Equatable {
  final String cuisines;
  final String dietaryRestrictions;
  final String ingredients;
  final String prompt;

  const PromptObject({
    this.cuisines = '',
    this.dietaryRestrictions = '',
    this.ingredients = '',
  }) :
        prompt = '''You are a Cat who's a chef that travels around the world a lot and your travel inspired recipe.

Recommend a recipe for me based on the provided image.
The recipe should only contain real, edible ingredients.
If the image or images attached don't contain any food items, response using others information.
Adhere to food safety and handling best practices like ensuring that poultry is fully cooked.

I'm in the mood for the following types of cuisine: $cuisines

I have the following dietary restrictions: $dietaryRestrictions

Optionally also include the following ingredients: $ingredients
  


After providing the recipe, explaining creatively why the recipe is good.
List out any ingredients that are potential allergens.
Provide a summary of how many people the recipe will serve and the nutritional information per serving.

If the prompt and additional information does not provide any information about food and instead contains unrelated information, please provide answers based on RANDOM Vietnamese Recipe.

Note: ${PromptObject.formatting}''';

  static const formatting = """Return the recipe in JSON using the following structure:
{
  'title': \$recipeTitle,
  'ingredients': \$ingredients,
  'instructions: \$instructions,
  'id': \$uniqueId,
  'cuisine': \$cuisineType,
  'description': \$description,
  'allergens': \$allergens,
  'servings': \$servings,
  'nutritionInformation': {
    'calories': \$calories,
    'fat': \$fat,
    'saturatedFat': \$saturatedFat,
    'cholesterol': \$cholesterol,
    'sodium': \$sodium,
    'carbohydrates': \$carbohydrates,
    'fiber': \$fiber,
    'sugar': \$sugar,
    'protein': \$protein,
  }
}
uniqueId should be unique and of type String.
title, description, cuisine, allergens, and servings should be of String type.
ingredients and instructions should be of type List<String>.
calories, fat, saturatedFat, cholesterol, sodium, carbohydrates, fiber, sugar, protein should be of String type""";


  @override
  List<Object?> get props => [cuisines, dietaryRestrictions, ingredients,  prompt];
}