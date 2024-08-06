import 'package:equatable/equatable.dart';

import '../../entities/suggest_recipe/suggest_recipe_entities.dart';

class MySuggestRecipe extends Equatable {
  final String userId;
  final Map<String, dynamic> recipeJson;
  final String picture;
  final String title;

  const MySuggestRecipe(
      {required this.userId,
      required this.recipeJson,
      required this.picture,
      required this.title});

  static const empty =
      MySuggestRecipe(userId: '', recipeJson: {}, picture: '', title: '');

  MySuggestRecipe copyWith(
      {String? userId,
      String? ownerId,
      Map<String, dynamic>? recipeJson,
      String? picture,
      String? title}) {
    return MySuggestRecipe(
        userId: userId ?? this.userId,
        recipeJson: recipeJson ?? this.recipeJson,
        picture: picture ?? this.picture,
        title: title ?? this.title);
  }

  MySuggestRecipeEntity toSuggestRecipeEntity() {
    return MySuggestRecipeEntity(
        userId: userId, recipeJson: recipeJson, picture: picture, title: title);
  }

  static MySuggestRecipe fromSuggestRecipeEntity(MySuggestRecipeEntity entity) {
    return MySuggestRecipe(
        userId: entity.userId,
        recipeJson: entity.recipeJson,
        picture: entity.picture,
        title: entity.title);
  }

  @override
  List<Object?> get props => [userId, recipeJson, picture, title];
}
