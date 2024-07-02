import 'package:equatable/equatable.dart';
import 'package:gemini_cookbook/src/config/models/objects/prompt_object.dart';

class HomeScreenState extends Equatable {
  final PromptObject prompt;
  final List<bool> isCuisinesSelected;
  final List<bool> isDietaryRestrictionsSelected;
  final List<bool> isIngredientsSelected;

  const HomeScreenState({
    this.prompt=const PromptObject(),
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

  HomeScreenState copyWith(
      {PromptObject? prompt,
      bool? isButtonPressed,
      List<bool>? isCuisinesSelected,
      List<bool>? isDietaryRestrictionsSelected,
      List<bool>? isIngredientsSelected}) {
    return HomeScreenState(
        prompt: prompt?? this.prompt,
        isCuisinesSelected: isCuisinesSelected ?? this.isCuisinesSelected,
        isDietaryRestrictionsSelected:
            isDietaryRestrictionsSelected ?? this.isDietaryRestrictionsSelected,
        isIngredientsSelected:
            isIngredientsSelected ?? this.isIngredientsSelected);
  }

  @override
  List<Object?> get props => [
        isCuisinesSelected,
        isDietaryRestrictionsSelected,
        isIngredientsSelected
      ];
}
