import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationUserChanged extends AuthenticationEvent{
  final User? user;
  const AuthenticationUserChanged(this.user);
}
