import 'package:equatable/equatable.dart';

abstract class MyUserEvent extends Equatable {
  const MyUserEvent();

  @override
  List<Object?> get props => [];
}

class GetUserData extends MyUserEvent {
  final String userId;
  const GetUserData({required this.userId});
  @override
  List<Object> get props => [userId];
}
