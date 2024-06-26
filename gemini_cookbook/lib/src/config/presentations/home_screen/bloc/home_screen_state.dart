import 'package:equatable/equatable.dart';

class HomeScreenState extends Equatable {
  final bool isButtonPressed;
  final List<bool> isCuisinesSelected;
  final List<bool> isDietaryRestrictionsSelected;
  final List<bool> isIngredientsSelected;

  const HomeScreenState({
    this.isButtonPressed = false,
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
      {bool? isButtonPressed,
      List<bool>? isCuisinesSelected,
      List<bool>? isDietaryRestrictionsSelected,
      List<bool>? isIngredientsSelected}) {
    return HomeScreenState(
        isButtonPressed: isButtonPressed ?? this.isButtonPressed,
        isCuisinesSelected: isCuisinesSelected ?? this.isCuisinesSelected,
        isDietaryRestrictionsSelected:
            isDietaryRestrictionsSelected ?? this.isDietaryRestrictionsSelected,
        isIngredientsSelected:
            isIngredientsSelected ?? this.isIngredientsSelected);
  }

  @override
  List<Object?> get props => [
        isButtonPressed,
        isCuisinesSelected,
        isDietaryRestrictionsSelected,
        isIngredientsSelected
      ];
}
