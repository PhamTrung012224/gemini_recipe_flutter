import 'package:equatable/equatable.dart';

class PromptObject extends Equatable {
  final String cuisines;
  final String dietaryRestrictions;
  final String ingredients;
  final String meal;
  final String prompt;

  const PromptObject({
    this.meal = 'none',
    this.cuisines = 'none',
    this.dietaryRestrictions = 'none',
    this.ingredients = 'none',
  }) : prompt =
            '''You are a Cat who's a chef that travels around the world a lot and your travel inspired recipe.

Recommend a recipe for me based on the provided image.
The recipe should only contain real, edible ingredients.
If the image or images attached don't contain any food items or don't contain any images, generate recipe using other information.
Adhere to food safety and handling best practices like ensuring that poultry is fully cooked.

I want to make a recipe for: $meal

I'm in the mood for the following types of cuisine: $cuisines

I followed these dietary restrictions: $dietaryRestrictions

I also have the following ingredients: $ingredients
  


After providing the recipe, explaining creatively why the recipe is good.
List out any ingredients that are potential allergens.
Provide a summary of how many people the recipe will serve and the nutritional information per serving.

If none of information are given, provide random recipe from random cuisine.
If additional_information contain food or ingredients, provide recipe base on that information.


No Yapping!

Note: ${PromptObject.formatting}''';

  static const formatting =
      """Return the recipe in JSON using the following structure:
{
  "title": \$recipeTitle,
  "meal": \$meal,
  "ingredients": \$ingredients,
  "instructions": [
     "stepTitle": \$stepTitle,
     "detailInstructions": \$detailInstructions,
  ],
  "id": \$uniqueId,
  "cuisine": \$cuisineType,
  "description": \$description,
  "allergens": \$allergens,
  "servings": \$servings,
  "totalRecipeTime": \$totalRecipeTime,
  "level": \$level,
  "calories": \$calories,
  "nutritionInformation": {
    "fat": \$fat,
    "saturatedFat": \$saturatedFat,
    "cholesterol": \$cholesterol,
    "sodium": \$sodium,
    "carbohydrates": \$carbohydrates,
    "fiber": \$fiber,
    "sugar": \$sugar,
    "protein": \$protein,
  }
}

title length must contain maximum 5 words.
The stepTitle should give a quick idea of each step. 
Important: I prefer having more shorter or medium steps rather than fewer long ones.
meal should be one of these type: Breakfast, Brunch, Elevenses, Lunch, Tea, Supper, Dinner.
calories should have unit kcal
uniqueId should be unique and of type String.
title, meal, description, cuisine, allergens, and servings should be of String type.
ingredients, should be of type List<String>.
calories, fat, saturatedFat, cholesterol, sodium, carbohydrates, fiber, sugar, protein,  stepTitle and detailInstructions  should be of String type

The JSON results must have abbreviation for unit of measured""";

  @override
  List<Object?> get props =>
      [cuisines, dietaryRestrictions, ingredients, meal, prompt];
}
