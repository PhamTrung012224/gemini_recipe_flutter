import 'package:equatable/equatable.dart';

class RecipeScreenState extends Equatable {
  final bool isButtonTap;
  final String title;
  final String allergens;
  final String servings;
  final String description;
  final List<String> nutritionPerServing;
  final List<String> ingredients;
  final List<String> instructions;
  const RecipeScreenState(
      {this.isButtonTap = false,
      this.title = 'No Information',
      this.allergens = '',
      this.servings = '',
      this.description = '',
      this.nutritionPerServing = const [],
      this.ingredients = const [],
      this.instructions = const []});

  RecipeScreenState copyWith(
      bool? isButtonTap,
      String? title,
      String? allergens,
      String? servings,
      String? description,
      List<String>? nutritionPerServing,
      List<String>? ingredients,
      List<String>? instructions) {
    return RecipeScreenState(
        isButtonTap: isButtonTap ?? this.isButtonTap,
        title: title ?? this.title,
        allergens: allergens ?? this.allergens,
        servings: servings ?? this.servings,
        description: description ?? this.description,
        nutritionPerServing: nutritionPerServing ?? this.nutritionPerServing,
        ingredients: ingredients ?? this.ingredients,
        instructions: instructions ?? this.instructions);
  }

  @override
  List<Object?> get props => [
        isButtonTap,
        title,
        allergens,
        servings,
        description,
        nutritionPerServing,
        ingredients,
        instructions
      ];
}
