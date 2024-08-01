import 'package:json_annotation/json_annotation.dart';

part 'suggest_response_object.g.dart';

@JsonSerializable(explicitToJson: true)
class SuggestResponse {
  final String title;
  final String category;
  final String meal;
  final List<String> ingredients;
  final List<Instructions> instructions;
  final String id;
  final String cuisine;
  final String description;
  final String allergens;
  final String servings;
  final String totalRecipeTime;
  final String level;
  final String calories;
  final NutritionInformation nutritionInformation;

  SuggestResponse({
    required this.title,
    required this.category,
    required this.meal,
    required this.ingredients,
    required this.instructions,
    required this.id,
    required this.cuisine,
    required this.description,
    required this.allergens,
    required this.servings,
    required this.totalRecipeTime,
    required this.level,
    required this.calories,
    required this.nutritionInformation,
  });

  factory SuggestResponse.fromJson(Map<String, dynamic> json) =>
      _$SuggestResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SuggestResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Instructions {
  final String stepTitle;
  final String detailInstructions;

  Instructions({required this.stepTitle, required this.detailInstructions});

  factory Instructions.fromJson(Map<String, dynamic> json) =>
      _$InstructionsFromJson(json);
  Map<String, dynamic> toJson() => _$InstructionsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NutritionInformation {
  final String fat;
  final String saturatedFat;
  final String cholesterol;
  final String sodium;
  final String carbohydrates;
  final String fiber;
  final String sugar;
  final String protein;

  NutritionInformation({
    required this.fat,
    required this.saturatedFat,
    required this.cholesterol,
    required this.sodium,
    required this.carbohydrates,
    required this.fiber,
    required this.sugar,
    required this.protein,
  });

  factory NutritionInformation.fromJson(Map<String, dynamic> json) =>
      _$NutritionInformationFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionInformationToJson(this);
}
