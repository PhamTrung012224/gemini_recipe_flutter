// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_response_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromptResponse _$PromptResponseFromJson(Map<String, dynamic> json) =>
    PromptResponse(
      title: json['title'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      id: json['id'] as String,
      cuisine: json['cuisine'] as String,
      description: json['description'] as String,
      allergens: json['allergens'] as String,
      servings: json['servings'] as String,
      nutritionInformation: NutritionInformation.fromJson(
          Map<String, String>.from(json['nutritionInformation'] as Map)),
    );

Map<String, dynamic> _$PromptResponseToJson(PromptResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'ingredients': instance.ingredients,
      'instructions': instance.instructions,
      'id': instance.id,
      'cuisine': instance.cuisine,
      'description': instance.description,
      'allergens': instance.allergens,
      'servings': instance.servings,
      'nutritionInformation': instance.nutritionInformation.toJson(),
    };

NutritionInformation _$NutritionInformationFromJson(
        Map<String, dynamic> json) =>
    NutritionInformation(
      calories: json['calories'] as String,
      fat: json['fat'] as String,
      saturatedFat: json['saturatedFat'] as String,
      cholesterol: json['cholesterol'] as String,
      sodium: json['sodium'] as String,
      carbohydrates: json['carbohydrates'] as String,
      fiber: json['fiber'] as String,
      sugar: json['sugar'] as String,
      protein: json['protein'] as String,
    );

Map<String, dynamic> _$NutritionInformationToJson(
        NutritionInformation instance) =>
    <String, dynamic>{
      'calories': instance.calories,
      'fat': instance.fat,
      'saturatedFat': instance.saturatedFat,
      'cholesterol': instance.cholesterol,
      'sodium': instance.sodium,
      'carbohydrates': instance.carbohydrates,
      'fiber': instance.fiber,
      'sugar': instance.sugar,
      'protein': instance.protein,
    };
