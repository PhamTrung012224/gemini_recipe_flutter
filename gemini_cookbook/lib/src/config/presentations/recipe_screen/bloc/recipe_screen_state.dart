part of 'recipe_screen_bloc.dart';

sealed class RecipeScreenState extends Equatable {
  const RecipeScreenState();
}

final class RecipeScreenInitial extends RecipeScreenState {
  @override
  List<Object> get props => [];
}
