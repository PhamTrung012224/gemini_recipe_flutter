import 'package:equatable/equatable.dart';

abstract class UpdateUserImageEvent extends Equatable {
  const UpdateUserImageEvent();
}

class UpdateProfileImage extends UpdateUserImageEvent {
  final String path;
  final String userId;
  const UpdateProfileImage({required this.userId, required this.path});

  @override
  List<Object> get props => [userId, path];
}
