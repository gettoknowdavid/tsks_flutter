import 'package:equatable/equatable.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';

final class User with EquatableMixin {
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    this.photoURL,
    this.emailVerified = false,
  });

  final Id id;
  final SingleLineString fullName;
  final Email email;
  final String? photoURL;
  final bool emailVerified;

  @override
  List<Object?> get props => [id, fullName, email, photoURL, emailVerified];
}
