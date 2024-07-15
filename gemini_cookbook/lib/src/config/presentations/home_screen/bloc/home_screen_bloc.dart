import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/home_screen_event.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(const HomeScreenState()) {
    on<TapFullPromptEvent>(_onTapFullPrompt);
    on<TapResetPromptEvent>(_onTapResetPrompt);
    on<TapSubmitPromptEvent>(_onTapSubmitPrompt);
    on<TapCuisineChip>(_onTapCuisineChip);
    on<TapIngredientChip>(_onTapIngredientChip);
    on<TapDietaryRestrictionChip>(_onTapDietaryRestrictionChip);
  }

  // Chip
  void _onTapCuisineChip(TapCuisineChip event, Emitter<HomeScreenState> emit) {
    // Implement logic here
    emit(state.copyWith(
        isCuisinesSelected: event.isCuisineSelected,
        prompt: event.cuisinesPrompt));
  }

  void _onTapIngredientChip(
      TapIngredientChip event, Emitter<HomeScreenState> emit) {
    // Implement logic here
    emit(state.copyWith(
        isIngredientsSelected: event.isIngredientsSelected,
        prompt: event.ingredientsPrompt));
  }

  void _onTapDietaryRestrictionChip(
      TapDietaryRestrictionChip event, Emitter<HomeScreenState> emit) {
    // Implement logic here
    emit(state.copyWith(
        isDietaryRestrictionsSelected: event.isDietaryRestrictionSelected,
        prompt: event.dietaryRestrictionPrompt));
  }

  // Prompt Button
  void _onTapFullPrompt(
      TapFullPromptEvent event, Emitter<HomeScreenState> emit) {
    // Implement logic here
  }

  void _onTapResetPrompt(
      TapResetPromptEvent event, Emitter<HomeScreenState> emit) {
    // Implement logic here
    emit(state.copyWith(
        isIngredientsSelected: event.isIngredientsSelected,
        isDietaryRestrictionsSelected: event.isDietaryRestrictionSelected,
        isCuisinesSelected: event.isCuisineSelected,
        prompt: event.promptObject));
  }

  void _onTapSubmitPrompt(
      TapSubmitPromptEvent event, Emitter<HomeScreenState> emit) {
    // Implement logic here
  }
}
