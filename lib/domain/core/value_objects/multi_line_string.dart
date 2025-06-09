import 'package:fpdart/fpdart.dart';
import 'package:tsks_flutter/domain/core/exceptions/value_exception.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_object.dart';

class MultiLineString extends ValueObject<String> {
  static MultiLineString empty = MultiLineString('');

  factory MultiLineString(String input) {
    final validationResult = _validateString(input);
    return MultiLineString._(validationResult);
  }

  const MultiLineString._(super.input);

  static Either<ValueException<String>, String> _validateString(String input) {
    if (input.isEmpty) return const Left(RequiredValueException());
    if (input.length > 244) return Left(LengthExceededValueException(input));
    return Right(input);
  }
}
