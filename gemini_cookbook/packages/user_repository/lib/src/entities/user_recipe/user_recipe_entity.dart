import 'package:equatable/equatable.dart';

class MyUserRecipeEntity extends Equatable {
  final String userId;
  final String ownerId;
  final Map<String, dynamic> recipeJson;
  final Map<String, dynamic> youtubeJson;
  final String title;

  const MyUserRecipeEntity(
      {required this.userId,
      required this.ownerId,
      required this.recipeJson,
      required this.youtubeJson,
      required this.title});

  MyUserRecipeEntity copyWith(
      {String? userId,
      String? ownerId,
      Map<String, dynamic>? recipeJson,
      Map<String, dynamic>? youtubeJson,
      String? title}) {
    return MyUserRecipeEntity(
        userId: userId ?? this.userId,
        ownerId: ownerId ?? this.ownerId,
        recipeJson: recipeJson ?? this.recipeJson,
        youtubeJson: youtubeJson ?? this.youtubeJson,
        title: title ?? this.title);
  }

  Map<String, Object?> toRecipeDocuments() {
    return {
      'userId': userId,
      'ownerId': ownerId,
      'recipeJson': recipeJson,
      'youtubeJson': youtubeJson,
      'title': title
    };
  }

  static MyUserRecipeEntity fromRecipeDocuments(Map<String, dynamic> doc) {
    return MyUserRecipeEntity(
        userId: doc['userId'],
        ownerId: doc['ownerId'],
        recipeJson: doc['recipeJson'],
        youtubeJson: doc['youtubeJson'],
        title: doc['title']);
  }

  @override
  List<Object?> get props => [userId, ownerId, recipeJson, youtubeJson, title];
}
