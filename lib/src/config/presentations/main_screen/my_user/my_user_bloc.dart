import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/main_screen/my_user/my_user_state.dart';
import 'package:user_repository/user_repository.dart';

import 'my_user_event.dart';


class MyUserBloc extends Bloc<MyUserEvent, MyUserState> {
  final UserRepository _userRepository;

  MyUserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const MyUserState.loading()) {
    on<GetUserData>((event, emit) async {
      try {
        MyUser user = await _userRepository.getUserData(event.userId);
        emit(MyUserState.success(user));
      } catch (e) {
        emit(const MyUserState.failure());
      }
    });
  }
}
