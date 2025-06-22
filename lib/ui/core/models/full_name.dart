import 'package:formz/formz.dart';

/// {@template full_name}
/// Form input for a full_name input.
/// {@endtemplate}
class FullName extends FormzInput<String, FullNameValidationError> {
  /// {@macro full_name}
  const FullName.pure() : super.pure('');

  /// {@macro full_name}
  const FullName.dirty([super.value = '']) : super.dirty();

  @override
  FullNameValidationError? validator(String? value) {
    if (value == null || value.isEmpty) return FullNameValidationError.empty;
    if (value.contains('\n')) return FullNameValidationError.invalid;
    if (value.length > 70) return FullNameValidationError.maxCharactersExceeded;
    return null;
  }
}

/// Validation errors for the [FullName] [FormzInput].
enum FullNameValidationError {
  /// Empty
  empty,

  /// Generic invalid error.
  invalid,

  /// Max characters
  maxCharactersExceeded,
}

extension FullNameValidationErrorX on FullNameValidationError {
  String get message => switch (this) {
    FullNameValidationError.empty => 'Full name is required',
    FullNameValidationError.invalid => 'Full name must on a single line',
    FullNameValidationError.maxCharactersExceeded => 'Max characters of 70',
  };
}
