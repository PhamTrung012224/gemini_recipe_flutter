import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'recipe_screen_event.dart';
part 'recipe_screen_state.dart';

class RecipeScreenBloc extends Bloc<RecipeScreenEvent, RecipeScreenState> {
  RecipeScreenBloc() : super(RecipeScreenInitial()) {
    on<RecipeScreenEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
