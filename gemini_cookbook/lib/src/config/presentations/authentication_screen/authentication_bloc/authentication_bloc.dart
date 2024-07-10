import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/authentication_bloc/authentication_event.dart';
import 'package:gemini_cookbook/src/config/presentations/authentication_screen/authentication_bloc/authentication_state.dart';
import 'package:user_repository/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  late final StreamSubscription<User?> _userSubscription;

  AuthenticationBloc({required this.userRepository})
      : super(const AuthenticationState.unknown()) {
    _userSubscription = userRepository.user.listen((user) {
      add(AuthenticationUserChanged(user));
    });
    on<AuthenticationUserChanged>((event, emit) {
      if (event.user != null) {
        emit(AuthenticationState.authenticated(event.user!));
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
