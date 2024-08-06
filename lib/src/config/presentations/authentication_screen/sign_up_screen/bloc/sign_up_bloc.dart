import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_up_screen/bloc/sign_up_event.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_up_screen/bloc/sign_up_state.dart';
import 'package:user_repository/user_repository.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async {
      emit(SignUpProcess());
      try {
        final newUser =
            await _userRepository.signUp(event.myUser, event.password);
        await _userRepository.setUserData(newUser);
        emit(SignUpSuccess());
      } catch (e) {
        emit(SignUpFailure(errorMessage: e.toString()));
      }
    });
  }
}
