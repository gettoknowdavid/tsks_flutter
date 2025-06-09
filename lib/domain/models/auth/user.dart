import 'package:equatable/equatable.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';

final class User with EquatableMixin {
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    this.imageUrl,
    this.isEmailVerified = false,
  });

  final Id id;
  final SingleLineString fullName;
  final Email email;
  final String? imageUrl;
  final bool isEmailVerified;

  @override
  List<Object?> get props => [id, fullName, email, imageUrl, isEmailVerified];
}
