import 'package:equatable/equatable.dart';

abstract class UpdateUserProfileState extends Equatable {
  const UpdateUserProfileState();

  @override
  List<Object> get props => [];
}

class UpdateUserProfileInitial extends UpdateUserProfileState {}

class UploadProfileFailure extends UpdateUserProfileState {
  final String errorMessage;
  const UploadProfileFailure({required this.errorMessage});
}

class UploadProfileLoading extends UpdateUserProfileState {}

class UploadPictureSuccess extends UpdateUserProfileState {
  final String userImage;

  const UploadPictureSuccess(this.userImage);

  @override
  List<Object> get props => [userImage];
}

class UploadUsernameSuccess extends UpdateUserProfileState {}
