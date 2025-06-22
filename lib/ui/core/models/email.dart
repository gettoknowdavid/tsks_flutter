import 'package:formz/formz.dart';

// final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
// This one is often cited as a good balance for practical use
final _emailRegExp = RegExp(
  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
);

/// {@template email}
/// Form input for an email input.
/// {@endtemplate}
class Email extends FormzInput<String, EmailValidationError> {
  /// {@macro email}
  const Email.pure() : super.pure('');

  /// {@macro email}
  const Email.dirty([super.value = '']) : super.dirty();

  @override
  EmailValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return EmailValidationError.empty;
    if (!_emailRegExp.hasMatch(value)) return EmailValidationError.invalid;
    return null;
  }
}

/// Validation errors for the [Email] [FormzInput].
enum EmailValidationError {
  /// Empty
  empty,

  /// Generic invalid error.
  invalid,
}

extension EmailValidationErrorX on EmailValidationError {
  String get message => switch (this) {
    EmailValidationError.empty => 'Email is required',
    EmailValidationError.invalid => 'Email is invalid. Provide a valid email',
  };
}
