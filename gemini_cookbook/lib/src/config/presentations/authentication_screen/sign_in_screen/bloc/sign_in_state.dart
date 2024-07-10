import 'package:equatable/equatable.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

final class SignInInitial extends SignInState {}

class SignInProcess extends SignInState {}

class SignInSuccess extends SignInState {}

class SignInFailure extends SignInState {
  final String errorMessage;

  const SignInFailure({required this.errorMessage});
}
