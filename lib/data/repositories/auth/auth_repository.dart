import 'package:fpdart/fpdart.dart';
import 'package:tsks_flutter/domain/core/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';

abstract class AuthRepository {
  User get user;

  Stream<User> get userChanges;

  Future<Either<TsksException, Unit>> signIn({
    required Email email,
    required Password password,
  });

  Future<void> signOut();

  Future<Either<TsksException, Unit>> signUp({
    required SingleLineString fullName,
    required Email email,
    required Password password,
  });
}
