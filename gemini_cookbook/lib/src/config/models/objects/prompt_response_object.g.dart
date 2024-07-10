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
          .map((e) => Instructions.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String,
      cuisine: json['cuisine'] as String,
      description: json['description'] as String,
      allergens: json['allergens'] as String,
      servings: json['servings'] as String,
      totalRecipeTime: json['totalRecipeTime'] as String,
      level: json['level'] as String,
      calories: json['calories'] as String,
      nutritionInformation: NutritionInformation.fromJson(
          json['nutritionInformation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PromptResponseToJson(PromptResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'ingredients': instance.ingredients,
      'instructions': instance.instructions.map((e) => e.toJson()).toList(),
      'id': instance.id,
      'cuisine': instance.cuisine,
      'description': instance.description,
      'allergens': instance.allergens,
      'servings': instance.servings,
      'totalRecipeTime': instance.totalRecipeTime,
      'level': instance.level,
      'calories': instance.calories,
      'nutritionInformation': instance.nutritionInformation.toJson(),
    };

Instructions _$InstructionsFromJson(Map<String, dynamic> json) => Instructions(
      stepTitle: json['stepTitle'] as String,
      detailInstructions: json['detailInstructions'] as String,
    );

Map<String, dynamic> _$InstructionsToJson(Instructions instance) =>
    <String, dynamic>{
      'stepTitle': instance.stepTitle,
      'detailInstructions': instance.detailInstructions,
    };

NutritionInformation _$NutritionInformationFromJson(
        Map<String, dynamic> json) =>
    NutritionInformation(
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
      'fat': instance.fat,
      'saturatedFat': instance.saturatedFat,
      'cholesterol': instance.cholesterol,
      'sodium': instance.sodium,
      'carbohydrates': instance.carbohydrates,
      'fiber': instance.fiber,
      'sugar': instance.sugar,
      'protein': instance.protein,
    };
