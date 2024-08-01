import 'package:equatable/equatable.dart';

import '../../entities/user_recipe/recipe_entities.dart';

class MyUserRecipe extends Equatable {
  final String userId;
  final String ownerId;
  final Map<String, dynamic> recipeJson;
  final Map<String, dynamic> youtubeJson;
  final String title;

  const MyUserRecipe(
      {required this.userId,
      required this.ownerId,
      required this.recipeJson,
      required this.youtubeJson,
      required this.title});

  static const empty = MyUserRecipe(
      userId: '', ownerId: '', recipeJson: {}, youtubeJson: {}, title: '');

  MyUserRecipe copyWith(
      {String? userId,
      String? ownerId,
      Map<String, dynamic>? recipeJson,
      Map<String, dynamic>? youtubeJson,
      String? title}) {
    return MyUserRecipe(
        userId: userId ?? this.userId,
        ownerId: ownerId ?? this.ownerId,
        recipeJson: recipeJson ?? this.recipeJson,
        youtubeJson: youtubeJson ?? this.youtubeJson,
        title: title ?? this.title);
  }

  MyUserRecipeEntity toRecipeEntity() {
    return MyUserRecipeEntity(
        userId: userId,
        ownerId: ownerId,
        recipeJson: recipeJson,
        youtubeJson: youtubeJson,
        title: title);
  }

  static MyUserRecipe fromRecipeEntity(MyUserRecipeEntity entity) {
    return MyUserRecipe(
        userId: entity.userId,
        ownerId: entity.ownerId,
        recipeJson: entity.recipeJson,
        youtubeJson: entity.youtubeJson,
        title: entity.title);
  }

  @override
  List<Object?> get props => [userId, ownerId, recipeJson, youtubeJson, title];
}
