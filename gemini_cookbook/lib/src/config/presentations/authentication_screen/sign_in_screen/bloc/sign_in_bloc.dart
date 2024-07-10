import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_in_screen/bloc/sign_in_event.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/sign_in_screen/bloc/sign_in_state.dart';
import 'package:user_repository/user_repository.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignInInitial()) {
    on<SignInRequired>((event, emit) async {
      emit(SignInProcess());
      try {
        await _userRepository.signIn(event.email, event.password);
        emit(SignInSuccess());
      } catch (e) {
        emit(SignInFailure(errorMessage: e.toString()));
      }
    });
    on<SignOutRequired>((event, emit) async {
      await _userRepository.logOut();
    });
  }
}
