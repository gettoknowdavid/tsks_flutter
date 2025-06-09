import 'package:equatable/equatable.dart';

sealed class ValueException<T> with EquatableMixin implements Exception {
  const ValueException({required this.code, required this.message});
  final String code;
  final String message;

  @override
  List<Object?> get props => [];
}

final class InvalidFileFormatException<T> extends ValueException<T> {

  const InvalidFileFormatException(
    this.value, {
    super.code = 'invalid-format',
    super.message = 'The file format selected is invalid.',
  });
  final T value;
}

final class InvalidValueException<T> extends ValueException<T> {

  const InvalidValueException(
    this.value, {
    super.code = 'invalid-value',
    super.message = 'Invalid value.',
  });
  final T value;
}

final class LengthExceededValueException<T> extends ValueException<T> {
  const LengthExceededValueException(
    this.value, {
    this.maxLength = 244,
    super.code = 'length-exceeded',
    super.message = 'Value length exceeded.',
  });
  final T value;

  final int maxLength;
}

final class MaxLinesExceededValueException<T> extends ValueException<T> {
  const MaxLinesExceededValueException(
    this.value,
    this.maxLines, {
    super.code = 'max-lines-exceeded',
    super.message = 'Number of valid lines has been exceeded.',
  });
  final T value;

  final int maxLines;
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
