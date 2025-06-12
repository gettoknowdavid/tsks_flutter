import 'package:equatable/equatable.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';

final class User with EquatableMixin {
  const User({
    required this.uid,
    required this.fullName,
    required this.email,
    this.photoURL,
    this.emailVerified = false,
  });

  static User empty = User(
    uid: Uid(''),
    fullName: SingleLineString(''),
    email: Email(''),
  );

  final Uid uid;
  final SingleLineString fullName;
  final Email email;
  final String? photoURL;
  final bool emailVerified;

  @override
  List<Object?> get props => [uid, fullName, email, photoURL, emailVerified];
}

extension FullNameX on User {
  /// Used to get the initials of the user's full name
  String get nameInitials {
    final fullNameStr = fullName.getOrCrash;

    // 1. Trim leading/trailing whitespace
    // 2. Split by one or more whitespace characters (RegExp(r'\s+'))
    //    This correctly handles "John  Doe" or "Jane   Maria"
    // 3. Filter out any empty strings that might result from multiple spaces
    final effectiveNames = fullNameStr
        .trim()
        .split(RegExp(r'\s+'))
        .where((name) => name.isNotEmpty)
        .toList();

    if (effectiveNames.isEmpty) {
      return '';
    } else if (effectiveNames.length == 1) {
      return effectiveNames[0].toUpperCase();
    } else {
      final firstInitial = effectiveNames.first[0].toUpperCase();
      final lastInitial = effectiveNames.last[0].toUpperCase();
      return '$firstInitial$lastInitial';
    }
  }
}
