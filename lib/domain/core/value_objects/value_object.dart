import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tsks_flutter/domain/core/exceptions/value_exception.dart';

abstract class IValueObject {
  bool get isValid;
}

@immutable
abstract class ValueObject<T> with EquatableMixin implements IValueObject {

  /// Base constructor takes the pre-validated Either result.
  /// Can be const, allowing subclasses to define const constructors.
  const ValueObject(this.value);
  /// The core state: the result of validation, stored immutably.
  final Either<ValueException<T>, T> value;

  /// Returns the failure object [ValueException] if validation failed
  /// (isLeft), otherwise null.
  ValueException<T>? get failureOrNull {
    return value.fold((failure) => failure, (_) => null);
  }

  /// Returns the validated value if successful (isRight), otherwise throws
  /// the [ValueException].
  T get getOrCrash {
    return value.fold((failure) => throw failure, (success) => success);
  }

  /// Returns the validated value if successful (isRight), otherwise
  /// returns null.
  T? get getOrNull => value.fold((_) => null, (success) => success);

  /// Returns `true` if the validation was successful (result is Right).
  @override
  bool get isValid => value.isRight();

  @override
  List<Object?> get props => [value];

  @override
  bool? get stringify => true;
}
