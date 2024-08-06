import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

abstract class SaveRecipeEvent extends Equatable {
  const SaveRecipeEvent();

  @override
  List<Object?> get props => [];
}

class SaveRecipeRequired extends SaveRecipeEvent {
  final MyUserRecipe myUserRecipe;

  const SaveRecipeRequired({required this.myUserRecipe});
}

class SaveSuggestRecipeRequired extends SaveRecipeEvent {
  final MySuggestRecipe mySuggestRecipe;

  const SaveSuggestRecipeRequired({required this.mySuggestRecipe});
}

class RemoveRecipeRequired extends SaveRecipeEvent {
  final String userId;
  final String recipeTitle;
  const RemoveRecipeRequired({required this.userId, required this.recipeTitle});
}
