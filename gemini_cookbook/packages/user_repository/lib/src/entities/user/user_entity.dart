import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String userId;
  final String email;
  final String name;
  final String picture;

  const MyUserEntity(
      {required this.userId,
      required this.email,
      required this.name,
      required this.picture});

  Map<String, Object?> toDocuments() {
    return {'userId': userId, 'email': email, 'name': name, 'picture': picture};
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
        userId: doc['userId'],
        email: doc['email'],
        name: doc['name'],
        picture: doc['picture']);
  }

  @override
  List<Object?> get props => [userId, email, name, picture];
}
