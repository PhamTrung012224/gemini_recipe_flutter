import 'package:equatable/equatable.dart';

abstract class UpdateUserProfileEvent extends Equatable {
  const UpdateUserProfileEvent();
}

class UpdateProfileImage extends UpdateUserProfileEvent {
  final String path;
  final String userId;
  const UpdateProfileImage({required this.userId, required this.path});

  @override
  List<Object> get props => [userId, path];
}

class UpdateProfileName extends UpdateUserProfileEvent {
  final String userId;
  final String userName;
  const UpdateProfileName({required this.userId, required this.userName});

  @override
  List<Object> get props => [userId, userName];
}

// class UpdateRecipeImage extends UpdateUserImageEvent {
//   final String path;
//   final String userId;
//   const UpdateRecipeImage({required this.userId, required this.path});
//
//   @override
//   List<Object> get props => [userId, path];
// }
