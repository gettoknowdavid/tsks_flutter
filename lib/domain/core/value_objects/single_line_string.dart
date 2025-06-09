import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:tsks_flutter/domain/core/exceptions/value_exception.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_object.dart';

class SingleLineString extends ValueObject<String> {

  factory SingleLineString(String input) {
    final sanitizedInput = toBeginningOfSentenceCase(input.trim());
    final validationResult = _validateString(sanitizedInput);
    return SingleLineString._(validationResult);
  }

  const SingleLineString._(super.value);
  static SingleLineString empty = SingleLineString('');

  static Either<ValueException<String>, String> _validateString(String input) {
    if (input.isEmpty) return const Left(RequiredValueException());

    if (input.contains('\n')) {
      return Left(MaxLinesExceededValueException(input, 1));
    }

    return Right(input);
  }
}
