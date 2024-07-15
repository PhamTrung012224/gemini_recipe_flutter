import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/my_user/update_user_image/update_user_image_event.dart';
import 'package:gemini_cookbook/src/config/presentations/home_screen/bloc/my_user/update_user_image/update_user_image_state.dart';
import 'package:user_repository/user_repository.dart';

class UpdateUserImageBloc
    extends Bloc<UpdateUserImageEvent, UpdateUserImageState> {
  final UserRepository _userRepository;

  UpdateUserImageBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UpdateUserImageInitial()) {
    on<UpdateProfileImage>((event, emit) async {
      emit(UploadPictureLoading());
      try {
        final userImage =
            await _userRepository.uploadPicture(event.path, event.userId);
        emit(UploadPictureSuccess(userImage));
      } catch (e) {
        emit(UploadPictureFailure());
        log(e.toString());
      }
    });
  }
}



