import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/choose_screen/bloc/choose_screen_event.dart';
import 'package:gemini_cookbook/src/config/presentations/choose_screen/bloc/choose_screen_state.dart';

class ChooseScreenBloc extends Bloc<ChooseScreenEvent, ChooseScreenState> {
  ChooseScreenBloc() : super(const ChooseScreenState()) {
    on<TapFullPromptEvent>(_onTapFullPrompt);
    on<TapResetPromptEvent>(_onTapResetPrompt);
    on<TapCuisineChip>(_onTapCuisineChip);
    on<TapIngredientChip>(_onTapIngredientChip);
    on<TapDietaryRestrictionChip>(_onTapDietaryRestrictionChip);
    on<TapMealChip>(_onTapMealChip);
  }

  // Chip
  void _onTapCuisineChip(
      TapCuisineChip event, Emitter<ChooseScreenState> emit) {
    // Implement logic here
    emit(state.copyWith(
        isCuisinesSelected: event.isCuisineSelected,
        prompt: event.cuisinesPrompt));
  }

  void _onTapIngredientChip(
      TapIngredientChip event, Emitter<ChooseScreenState> emit) {
    // Implement logic here
    emit(state.copyWith(
        isIngredientsSelected: event.isIngredientsSelected,
        prompt: event.ingredientsPrompt));
  }

  void _onTapDietaryRestrictionChip(
      TapDietaryRestrictionChip event, Emitter<ChooseScreenState> emit) {
    // Implement logic here
    emit(state.copyWith(
        isDietaryRestrictionsSelected: event.isDietaryRestrictionSelected,
        prompt: event.dietaryRestrictionPrompt));
  }

  void _onTapMealChip(TapMealChip event, Emitter<ChooseScreenState> emit) {
    // Implement logic here
    emit(state.copyWith(
        isMealSelected: event.isMealSelected, prompt: event.mealPrompt));
  }

  // Prompt Button
  void _onTapFullPrompt(
      TapFullPromptEvent event, Emitter<ChooseScreenState> emit) {
    // Implement logic here
  }

  void _onTapResetPrompt(
      TapResetPromptEvent event, Emitter<ChooseScreenState> emit) {
    // Implement logic here
    emit(state.copyWith(
        isIngredientsSelected: event.isIngredientsSelected,
        isDietaryRestrictionsSelected: event.isDietaryRestrictionSelected,
        isCuisinesSelected: event.isCuisineSelected,
        isMealSelected: event.isMealSelected,
        prompt: event.promptObject));
  }
}
