import 'package:equatable/equatable.dart';
import 'package:gemini_cookbook/src/config/models/objects/prompt_object.dart';

abstract class HomeScreenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TapIngredientChip extends HomeScreenEvent {
  final List<bool> isIngredientsSelected;
  final PromptObject ingredientsPrompt;
  TapIngredientChip(
      {required this.isIngredientsSelected, required this.ingredientsPrompt});
}

class TapCuisineChip extends HomeScreenEvent {
  final List<bool> isCuisineSelected;
  final PromptObject cuisinesPrompt;
  TapCuisineChip(
      {required this.isCuisineSelected, required this.cuisinesPrompt});
}

class TapDietaryRestrictionChip extends HomeScreenEvent {
  final List<bool> isDietaryRestrictionSelected;
  final PromptObject dietaryRestrictionPrompt;
  TapDietaryRestrictionChip(
      {required this.isDietaryRestrictionSelected,
      required this.dietaryRestrictionPrompt});
}

class TapMealChip extends HomeScreenEvent {
  final List<bool> isMealSelected;
  final PromptObject mealPrompt;
  TapMealChip({required this.isMealSelected, required this.mealPrompt});
}

class TapFullPromptEvent extends HomeScreenEvent {}


class TapResetPromptEvent extends HomeScreenEvent {
  final List<bool> isMealSelected = const [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  final List<bool> isIngredientsSelected = const [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  final List<bool> isCuisineSelected = const [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  final List<bool> isDietaryRestrictionSelected = const [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  final PromptObject promptObject = const PromptObject();
}
