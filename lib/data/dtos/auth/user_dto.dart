import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';

final class UserDto with EquatableMixin {

  const UserDto({
    required this.id,
    required this.fullName,
    required this.email,
    this.photoURL,
    this.emailVerified = false,
  });
  factory UserDto.fromFirebaseUser(firebase_auth.User user) {
    return UserDto(
      id: user.uid,
      fullName: user.displayName!,
      email: user.email!,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
    );
  }

  static UserDto empty = const UserDto(id: '', fullName: '', email: '');

  final String id;
  final String fullName;
  final String email;
  final String? photoURL;
  final bool emailVerified;

  @override
  List<Object?> get props => [id, fullName, email, photoURL, emailVerified];

  User toDomain() {
    return User(
      id: Id.fromString(id),
      fullName: SingleLineString(fullName),
      email: Email(email),
      photoURL: photoURL,
      emailVerified: emailVerified,
    );
  }
}
