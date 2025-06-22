import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

final class User with EquatableMixin {
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    this.photoURL,
    this.emailVerified = false,
  });

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final json = doc.data()!;
    return User(
      id: doc.id,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      photoURL: json['photoURL'] as String,
      emailVerified: json['emailVerified'] as bool? ?? false,
    );
  }

  factory User.fromFirease(firebase_auth.User user) {
    return User(
      id: user.uid,
      fullName: user.displayName!,
      email: user.email!,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
    };
  }

  static User empty = const User(id: '', fullName: '', email: '');

  /// ID of the user
  final String id;

  /// The full name of the user
  final String fullName;

  /// The user's email address
  final String email;

  /// The user's display image or photo
  final String? photoURL;

  /// Whether the user's email address is verified or not.
  ///
  /// Defaults to true.
  final bool emailVerified;

  @override
  List<Object?> get props => [id, fullName, email, photoURL, emailVerified];
}

extension FullNameX on User {
  /// Used to get the initials of the user's full name
  String get nameInitials {
    // 1. Trim leading/trailing whitespace
    // 2. Split by one or more whitespace characters (RegExp(r'\s+'))
    //    This correctly handles "John  Doe" or "Jane   Maria"
    // 3. Filter out any empty strings that might result from multiple spaces
    final effectiveNames = fullName
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
