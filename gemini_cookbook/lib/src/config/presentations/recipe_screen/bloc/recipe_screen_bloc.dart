import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/recipe_screen/bloc/recipe_screen_event.dart';
import 'package:gemini_cookbook/src/config/presentations/recipe_screen/bloc/recipe_screen_state.dart';

class RecipeScreenBloc extends Bloc<RecipeScreenEvent, RecipeScreenState> {
  RecipeScreenBloc() : super(const RecipeScreenState()) {
    on<TapChefNoodlesButtonEvent>(_onTapChefNoodlesButton);
  }
  void _onTapChefNoodlesButton(TapChefNoodlesButtonEvent event,Emitter<RecipeScreenState> emit){}
}
