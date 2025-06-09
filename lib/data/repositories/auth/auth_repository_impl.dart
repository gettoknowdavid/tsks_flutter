import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:fpdart/fpdart.dart';
import 'package:tsks_flutter/data/dtos/auth/user_dto.dart';
import 'package:tsks_flutter/data/repositories/auth/auth_repository.dart';
import 'package:tsks_flutter/domain/core/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  const AuthRepositoryImpl({required firebase_auth.FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  @override
  User get user {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return User.empty;
    final dto = UserDto.fromFirebaseUser(firebaseUser);
    return dto.toDomain();
  }

  @override
  Stream<User> get userChanges {
    final stream = _firebaseAuth.userChanges().map((firebaseUser) {
      if (firebaseUser == null) return User.empty;
      final dto = UserDto.fromFirebaseUser(firebaseUser);
      return dto.toDomain();
    });
    return stream;
  }

  @override
  Future<Either<TsksException, Unit>> signIn({
    required Email email,
    required Password password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.getOrCrash,
        password: password.getOrCrash,
      );
      return Right(unit);
    } on firebase_auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return const Left(InvalidEmailOrPasswordException());
        default:
          return Left(TsksException(e.message ?? 'Unknown error'));
      }
    } on Exception catch (e) {
      return Left(TsksException(e.toString()));
    }
  }
  
  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  Future<Either<TsksException, Unit>> signUp({
    required SingleLineString fullName,
    required Email email,
    required Password password,
  }) async {
    final fullNameString = fullName.getOrCrash;
    final emailString = email.getOrCrash;
    final passwordString = password.getOrCrash;

    final createUserTask = TaskEither.tryCatch(
      () => _firebaseAuth.createUserWithEmailAndPassword(
        email: emailString,
        password: passwordString,
      ),
      (error, stackTrace) {
        if (error is firebase_auth.FirebaseAuthException) {
          switch (error.code) {
            case 'email-already-in-use':
            case 'invalid-email':
              return const EmailAlreadyInUseException();
            case 'weak-password':
              return TsksException('Password is too weak.');
            default:
              return TsksException(error.message ?? 'Unknown Firebase error');
          }
        }
        return TsksException(error.toString());
      },
    );

    final TaskEither<TsksException, Unit> resultTask = createUserTask.flatMap((
      credential,
    ) {
      final newUser = credential.user;
      if (newUser == null) return TaskEither.left(const NoUserException());

      final reloadUserTask = TaskEither.tryCatch(
        () => newUser.reload().then((_) => unit),
        (error, stackTrace) => TsksException(error.toString()),
      );

      final updateUserDisplayName = TaskEither.tryCatch(
        () => newUser.updateDisplayName(fullNameString).then((_) => unit),
        (error, stackTrace) => TsksException(error.toString()),
      );

      return reloadUserTask.flatMap((_) => updateUserDisplayName);
    });

    return await resultTask.run();
  }
}
