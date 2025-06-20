import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:json_annotation/json_annotation.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';

part 'user_dto.g.dart';

@JsonSerializable()
final class UserDto with EquatableMixin {
  const UserDto({
    required this.uid,
    required this.fullName,
    required this.email,
    this.photoURL,
    this.emailVerified = false,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  factory UserDto.fromFirebaseUser(firebase_auth.User user) {
    return UserDto(
      uid: user.uid,
      fullName: user.displayName!,
      email: user.email!,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
    );
  }

  factory UserDto.fromDomain(User user) {
    return UserDto(
      uid: user.uid.getOrCrash,
      fullName: user.fullName.getOrCrash,
      email: user.email.getOrCrash,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
    );
  }

  static UserDto empty = const UserDto(uid: '', fullName: '', email: '');

  final String uid;
  final String fullName;
  final String email;
  final String? photoURL;
  final bool emailVerified;

  @override
  List<Object?> get props => [uid, fullName, email, photoURL, emailVerified];

  User toDomain() {
    return User(
      uid: Uid(uid),
      fullName: SingleLineString(fullName),
      email: Email(email),
      photoURL: photoURL,
      emailVerified: emailVerified,
    );
  }

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
