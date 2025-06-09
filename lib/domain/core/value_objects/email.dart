import 'package:fpdart/fpdart.dart';
import 'package:tsks_flutter/domain/core/exceptions/value_exception.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_object.dart';

// final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
// This one is often cited as a good balance for practical use
final _emailRegExp = RegExp(
  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
);

class Email extends ValueObject<String> {

  factory Email(String input) {
    final sanitizedInput = input.trim();
    return Email._(_validateEmail(sanitizedInput));
  }

  const Email._(super.value);
  static Email empty = Email('');

  static Either<ValueException<String>, String> _validateEmail(String input) {
    if (input.isEmpty) {
      return const Left(RequiredValueException(message: 'Email is required'));
    }

    if (!_emailRegExp.hasMatch(input)) {
      return Left(InvalidValueException(input, message: 'Invalid email'));
    }

    return Right(input);
  }
}
