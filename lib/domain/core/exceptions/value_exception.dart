import 'package:equatable/equatable.dart';

sealed class ValueException<T> with EquatableMixin implements Exception {
  final String code;
  final String message;
  const ValueException({required this.code, required this.message});

  @override
  List<Object?> get props => [];
}

final class InvalidFileFormatException<T> extends ValueException<T> {
  final T value;

  const InvalidFileFormatException(
    this.value, {
    super.code = 'invalid-format',
    super.message = 'The file format selected is invalid.',
  });
}

final class InvalidValueException<T> extends ValueException<T> {
  final T value;

  const InvalidValueException(
    this.value, {
    super.code = 'invalid-value',
    super.message = 'Invalid value.',
  });
}

final class LengthExceededValueException<T> extends ValueException<T> {
  final T value;

  final int maxLength;
  const LengthExceededValueException(
    this.value, {
    this.maxLength = 244,
    super.code = 'length-exceeded',
    super.message = 'Value length exceeded.',
  });
}

final class MaxLinesExceededValueException<T> extends ValueException<T> {
  final T value;

  final int maxLines;
  const MaxLinesExceededValueException(
    this.value,
    this.maxLines, {
    super.code = 'max-lines-exceeded',
    super.message = 'Number of valid lines has been exceeded.',
  });
}

final class RequiredValueException<T> extends ValueException<T> {
  const RequiredValueException({
    super.code = 'required-value',
    super.message = 'This value cannot be empty.',
  });
}


final class PasswordTooShort extends ValueException<String> {
  const PasswordTooShort({
    super.code = 'password-too-short',
    super.message = 'Password must be at least 8 characters',
  });
}
