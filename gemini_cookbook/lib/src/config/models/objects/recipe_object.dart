import 'package:gemini_cookbook/src/config/models/objects/suggest_response_object.dart';

class RecipeList {
  final List<Recipe> suggestRecipes;
  RecipeList({this.suggestRecipes = const []});

  void addRecipe(Recipe recipe) {
    suggestRecipes.add(recipe);
  }

  void removeRecipe(Recipe recipe) {
    suggestRecipes.remove(recipe);
  }
}

class Recipe {
  final String recipeId;
  String recipeImage;
  final SuggestResponse suggestRecipe;

  Recipe(
      {required this.recipeId,
      this.recipeImage = '',
      required this.suggestRecipe});
}
