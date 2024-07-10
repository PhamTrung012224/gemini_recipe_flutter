import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpRequired extends SignUpEvent {
  final MyUser myUser;
  final String password;
  const SignUpRequired({required this.myUser, required this.password});
}

