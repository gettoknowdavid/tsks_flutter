import 'package:fpdart/fpdart.dart';
import 'package:tsks_flutter/domain/core/exceptions/value_exception.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_object.dart';

final class Uid extends ValueObject<String> {
  factory Uid(String input) {
    final validatedResult = _validate(input);
    return Uid._(validatedResult);
  }

  const Uid._(super.value);
  static Uid empty = Uid('');

  static Either<ValueException<String>, String> _validate(String input) {
    final sanitizedInput = input.trim();

    if (sanitizedInput.isEmpty) {
      return const Left(RequiredValueException(message: 'ID cannot be empty'));
    }

    return Right(sanitizedInput);
  }
}
