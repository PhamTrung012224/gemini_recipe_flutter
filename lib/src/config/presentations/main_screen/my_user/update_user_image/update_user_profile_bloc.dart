import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_cookbook/src/config/presentations/main_screen/my_user/update_user_image/update_user_profile_event.dart';
import 'package:gemini_cookbook/src/config/presentations/main_screen/my_user/update_user_image/update_user_profile_state.dart';

import 'package:user_repository/user_repository.dart';

class UpdateUserProfileBloc
    extends Bloc<UpdateUserProfileEvent, UpdateUserProfileState> {
  final UserRepository _userRepository;

  UpdateUserProfileBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UpdateUserProfileInitial()) {
    on<UpdateProfileImage>((event, emit) async {
      emit(UploadProfileLoading());
      try {
        final userImage =
            await _userRepository.uploadPicture(event.path, event.userId);
        emit(UploadPictureSuccess(userImage));
      } catch (e) {
        emit(UploadProfileFailure(errorMessage: e.toString()));
        log(e.toString());
      }
    });
    on<UpdateProfileName>((event, emit) async {
      emit(UploadProfileLoading());
      try {
        await _userRepository.editUsername(event.userId, event.userName);
        emit(UploadUsernameSuccess());
      } catch (e) {
        emit(UploadProfileFailure(errorMessage: e.toString()));
        log(e.toString());
      }
    });
  }
}

// on<UpdateRecipeImage>((event, emit) async {
//   emit(UploadPictureLoading());
//   try {
//     final userImage =
//     await _userRepository.uploadRecipePicture(event.path, event.userId);
//     emit(UploadPictureSuccess(userImage));
//   } catch (e) {
//     emit(UploadPictureFailure());
//     log(e.toString());
//   }
// });
