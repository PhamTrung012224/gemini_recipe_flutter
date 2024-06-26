import 'package:equatable/equatable.dart';

abstract class HomeScreenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TapIngredientChip extends HomeScreenEvent {
  final List<bool> isIngredientsSelected;
  TapIngredientChip({required this.isIngredientsSelected});
}

class TapCuisineChip extends HomeScreenEvent {
  final List<bool> isCuisineSelected;
  TapCuisineChip({required this.isCuisineSelected});
}

class TapDietaryRestrictionChip extends HomeScreenEvent {
  final List<bool> isDietaryRestrictionSelected;
  TapDietaryRestrictionChip({required this.isDietaryRestrictionSelected});
}

class TapFullPromptEvent extends HomeScreenEvent {}

class TapSubmitPromptEvent extends HomeScreenEvent {}

class TapResetPromptEvent extends HomeScreenEvent {}
