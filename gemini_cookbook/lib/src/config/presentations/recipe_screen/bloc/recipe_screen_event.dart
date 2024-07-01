import 'package:equatable/equatable.dart';

abstract class RecipeScreenEvent extends Equatable {
  const RecipeScreenEvent();
  @override
  List<Object?> get props => [];
}

class TapChefNoodlesButtonEvent extends RecipeScreenEvent{}