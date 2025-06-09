import 'package:fpdart/fpdart.dart';
import 'package:tsks_flutter/domain/core/exceptions/value_exception.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_object.dart';
import 'package:uuid/uuid.dart';

final class Id extends ValueObject<String> {
  static Id empty = Id.fromString('');

  factory Id() {
    final uuidString = const Uuid().v4();
    return Id._(_validate(uuidString));
  }

  factory Id.fromString(String input) {
    final validatedResult = _validate(input);
    return Id._(validatedResult);
  }

  const Id._(super.value);

  static Either<ValueException<String>, String> _validate(String input) {
    final sanitizedInput = input.trim();

    if (sanitizedInput.isEmpty) {
      return const Left(RequiredValueException(message: 'ID cannot be empty'));
    }

    if (!Uuid.isValidUUID(fromString: sanitizedInput)) {
      return Left(InvalidValueException(sanitizedInput, message: 'Invalid ID'));
    }

    return Right(sanitizedInput);
  }
}
