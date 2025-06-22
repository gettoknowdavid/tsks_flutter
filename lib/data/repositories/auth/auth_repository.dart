import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/models/auth/user.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final firebaseAuth = firebase_auth.FirebaseAuth.instance;
  return AuthRepository(firebaseAuth: firebaseAuth);
}

@Riverpod(keepAlive: true)
Stream<User> userChanges(Ref ref) {
  return ref.watch(authRepositoryProvider).userChanges;
}

final class AuthRepository {
  const AuthRepository({required firebase_auth.FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  User get user {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return User.empty;
    return User.fromFirease(firebaseUser);
  }

  Stream<User> get userChanges {
    final stream = _firebaseAuth.userChanges().map((firebaseUser) {
      if (firebaseUser == null) return User.empty;
      return User.fromFirease(firebaseUser);
    });
    return stream;
  }

  Future<Either<TsksException, Unit>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return const Right(unit);
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

  Future<void> signOut() => _firebaseAuth.signOut();

  Future<Either<TsksException, Unit>> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final createUserTask = TaskEither.tryCatch(
      () => _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ),
      (error, stackTrace) {
        if (error is firebase_auth.FirebaseAuthException) {
          switch (error.code) {
            case 'email-already-in-use':
            case 'invalid-email':
              return const EmailAlreadyInUseException();
            case 'weak-password':
              return const TsksException('Password is too weak.');
            default:
              return TsksException(error.message ?? 'Unknown Firebase error');
          }
        }
        return TsksException(error.toString());
      },
    );

    final resultTask = createUserTask.flatMap<Unit>((
      credential,
    ) {
      final newUser = credential.user;
      if (newUser == null) return TaskEither.left(const NoUserException());

      final reloadUserTask = TaskEither.tryCatch(
        () => newUser.reload().then((_) => unit),
        (error, stackTrace) => TsksException(error.toString()),
      );

      final updateUserDisplayName = TaskEither.tryCatch(
        () => newUser.updateDisplayName(fullName).then((_) => unit),
        (error, stackTrace) => TsksException(error.toString()),
      );

      return reloadUserTask.flatMap((_) => updateUserDisplayName);
    });

    return resultTask.run();
  }
}
