import 'package:formz/formz.dart';

/// {@template password}
/// Form input for an password input.
/// {@endtemplate}
class Password extends FormzInput<String, PasswordValidationError> {
  /// {@macro password}
  const Password.pure([this.mode = PasswordMode.signIn]) : super.pure('');

  /// {@macro password}
  const Password.dirty([super.value = '', this.mode = PasswordMode.signIn])
    : super.dirty();

  final PasswordMode mode;

  @override
  PasswordValidationError? validator(String? value) {
    if (mode == PasswordMode.signIn) {
      if (value == null || value.isEmpty) return PasswordValidationError.empty;
      return null;
    } else {
      if (value == null || value.isEmpty) return PasswordValidationError.empty;
      if (value.length < 8) return PasswordValidationError.invalid;
      return null;
    }
  }
}

/// Enum to distinguish between sign-in and sign-up modes
enum PasswordMode { signIn, signUp }

/// Validation errors for the [Password] [FormzInput].
enum PasswordValidationError {
  /// Empty
  empty,

  /// Generic invalid error.
  invalid,
}

extension PasswordValidationErrorX on PasswordValidationError {
  String get message => switch (this) {
    PasswordValidationError.empty => 'Password is required',
    PasswordValidationError.invalid => 'Password must be at least 8 characters',
  };
}
