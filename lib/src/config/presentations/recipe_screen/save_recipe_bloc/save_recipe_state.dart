import 'package:equatable/equatable.dart';

abstract class SaveRecipeState extends Equatable {
  const SaveRecipeState();
  @override
  List<Object> get props => [];
}

final class SavingRecipeInitial extends SaveRecipeState {}

class SavingSuccess extends SaveRecipeState {}

class SavingFailure extends SaveRecipeState {
  final String error;
  const SavingFailure({required this.error});
}

class SavingProcess extends SaveRecipeState {}
