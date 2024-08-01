
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/recipe_screen/save_recipe_bloc/save_recipe_event.dart';
import 'package:gemini_cookbook/src/config/presentations/recipe_screen/save_recipe_bloc/save_recipe_state.dart';
import 'package:user_repository/user_repository.dart';

class SaveRecipeBloc extends Bloc<SaveRecipeEvent, SaveRecipeState> {
  final UserRepository _userRepository;
  SaveRecipeBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SavingRecipeInitial()) {
    on<SaveRecipeRequired>((event, emit) async {
      emit(SavingProcess());
      try {
        await _userRepository.setUserRecipeData(event.myUserRecipe);
        emit(SavingSuccess());
      } catch (e) {
        emit(SavingFailure(error: e.toString()));
        rethrow;
      }
    });
    on<SaveSuggestRecipeRequired>((event, emit) async {
      emit(SavingProcess());
      try {
        await _userRepository.setSuggestRecipeData(event.mySuggestRecipe);
        emit(SavingSuccess());
      } catch (e) {
        emit(SavingFailure(error: e.toString()));
        rethrow;
      }
    });
    on<RemoveRecipeRequired>((event, emit) {
      _userRepository.deleteUserRecipe(event.userId,event.recipeTitle);
    });
  }
}
