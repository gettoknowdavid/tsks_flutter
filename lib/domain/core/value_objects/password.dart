import 'package:fpdart/fpdart.dart';
import 'package:tsks_flutter/domain/core/exceptions/value_exception.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_object.dart';

final class Password extends ValueObject<String> {
  /// Default class for use with Sign In form
  static Password emptySignIn = Password('', PasswordMode.signIn);

  /// Default class for use with Sign Up form
  static Password emptySignUp = Password('', PasswordMode.signUp);

  final PasswordMode mode;

  factory Password(String input, [PasswordMode mode = PasswordMode.signIn]) {
    final sanitizedInput = input.trim();
    final validationResult = _validatePassword(sanitizedInput, mode: mode);
    return Password._(validationResult, mode);
  }

  const Password._(super.value, this.mode);

  static Either<ValueException<String>, String> _validatePassword(
    String input, {
    required PasswordMode mode,
  }) {
    if (mode == PasswordMode.signIn) {
      if (input.isEmpty) return const Left(RequiredValueException());
      return Right(input);
    } else {
      if (input.length < 8) return const Left(PasswordTooShort());
      return Right(input);
    }
  }
}

/// Enum to distinguish between sign-in and sign-up modes
enum PasswordMode { signIn, signUp }
