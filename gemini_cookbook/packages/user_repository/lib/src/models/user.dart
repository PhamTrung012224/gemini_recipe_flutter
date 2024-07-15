import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class MyUser extends Equatable {
  final String userId;
  final String email;
  final String name;
  final String picture;

  const MyUser(
      {required this.userId,
      required this.email,
      required this.name,
      required this.picture});


  static const empty = MyUser(userId: '', email: '', name: '', picture: '');

  MyUser copyWith(
      {String? userId, String? email, String? name, String? picture}) {
    return MyUser(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        name: name ?? this.name,
        picture: picture ?? this.picture);
  }

  MyUserEntity toEntity() {
    return MyUserEntity(
        userId: userId, email: email, name: name, picture: picture);
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
        userId: entity.userId,
        email: entity.email,
        name: entity.name,
        picture: entity.picture);
  }

  @override
  List<Object?> get props => [userId, email, name, picture];
}
