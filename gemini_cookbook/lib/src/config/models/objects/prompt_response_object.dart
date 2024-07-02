import 'package:json_annotation/json_annotation.dart';

part 'prompt_response_object.g.dart';

@JsonSerializable(explicitToJson: true)
class PromptResponse {
  final String title;
  final List<String> ingredients;
  final List<String> instructions;
  final String id;
  final String cuisine;
  final String description;
  final String allergens;
  final String servings;
  NutritionInformation nutritionInformation;

  PromptResponse(
      {required this.title,
      required this.ingredients,
      required this.instructions,
      required this.id,
      required this.cuisine,
      required this.description,
      required this.allergens,
      required this.servings,
      required this.nutritionInformation});
  factory PromptResponse.fromJson(Map<String, dynamic> json) =>
      _$PromptResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PromptResponseToJson(this);
}

@JsonSerializable()
class NutritionInformation {
  final String calories;
  final String fat;
  final String saturatedFat;
  final String cholesterol;
  final String sodium;
  final String carbohydrates;
  final String fiber;
  final String sugar;
  final String protein;

  NutritionInformation(
      {required this.calories,
      required this.fat,
      required this.saturatedFat,
      required this.cholesterol,
      required this.sodium,
      required this.carbohydrates,
      required this.fiber,
      required this.sugar,
      required this.protein});

  factory NutritionInformation.fromJson(Map<String, String> json) =>
      _$NutritionInformationFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionInformationToJson(this);
}
