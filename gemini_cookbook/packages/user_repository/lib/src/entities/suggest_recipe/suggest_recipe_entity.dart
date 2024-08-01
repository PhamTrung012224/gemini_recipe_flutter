import 'package:equatable/equatable.dart';

class MySuggestRecipeEntity extends Equatable {
  final String userId;
  final Map<String, dynamic> recipeJson;
  final String picture;
  final String title;

  const MySuggestRecipeEntity(
      {required this.userId,
      required this.recipeJson,
      required this.picture,
      required this.title});

  MySuggestRecipeEntity copyWith(
      {String? userId,
      String? ownerId,
      Map<String, dynamic>? recipeJson,
      String? picture,
      String? title}) {
    return MySuggestRecipeEntity(
        userId: userId ?? this.userId,
        recipeJson: recipeJson ?? this.recipeJson,
        picture: picture ?? this.picture,
        title: title ?? this.title);
  }

  Map<String, Object?> toSuggestRecipeDocuments() {
    return {
      'userId': userId,
      'recipeJson': recipeJson,
      'picture': picture,
      'title': title
    };
  }

  static MySuggestRecipeEntity fromSuggestRecipeDocuments(
      Map<String, dynamic> doc) {
    return MySuggestRecipeEntity(
        userId: doc['userId'],
        recipeJson: doc['recipeJson'],
        picture: doc['picture'],
        title: doc['title']);
  }

  @override
  List<Object?> get props => [userId, recipeJson, picture, title];
}
