import 'package:equatable/equatable.dart';
import 'package:gemini_cookbook/src/config/models/objects/prompt_object.dart';

class ChooseScreenState extends Equatable {
  final PromptObject prompt;
  final List<bool> isCuisinesSelected;
  final List<bool> isDietaryRestrictionsSelected;
  final List<bool> isIngredientsSelected;
  final List<bool> isMealSelected;

  const ChooseScreenState({
    this.prompt = const PromptObject(),
    this.isMealSelected = const [
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ],
    this.isIngredientsSelected = const [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ],
    this.isCuisinesSelected = const [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ],
    this.isDietaryRestrictionsSelected = const [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ],
  });

  ChooseScreenState copyWith(
      {PromptObject? prompt,
      bool? isButtonPressed,
      List<bool>? isCuisinesSelected,
      List<bool>? isDietaryRestrictionsSelected,
      List<bool>? isIngredientsSelected,
      List<bool>? isMealSelected}) {
    return ChooseScreenState(
        prompt: prompt ?? this.prompt,
        isCuisinesSelected: isCuisinesSelected ?? this.isCuisinesSelected,
        isDietaryRestrictionsSelected:
            isDietaryRestrictionsSelected ?? this.isDietaryRestrictionsSelected,
        isIngredientsSelected:
            isIngredientsSelected ?? this.isIngredientsSelected,
        isMealSelected: isMealSelected ?? this.isMealSelected);
  }

  @override
  List<Object?> get props => [
        isCuisinesSelected,
        isDietaryRestrictionsSelected,
        isIngredientsSelected,
        isMealSelected
      ];
}
