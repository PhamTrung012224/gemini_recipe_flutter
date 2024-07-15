import 'package:equatable/equatable.dart';

abstract class UpdateUserImageState extends Equatable {
  const UpdateUserImageState();

  @override
  List<Object> get props => [];
}

class UpdateUserImageInitial extends UpdateUserImageState {}

class UploadPictureFailure extends UpdateUserImageState {}

class UploadPictureLoading extends UpdateUserImageState {}

class UploadPictureSuccess extends UpdateUserImageState {
  final String userImage;

  const UploadPictureSuccess(this.userImage);

  @override
  List<Object> get props => [userImage];
}
