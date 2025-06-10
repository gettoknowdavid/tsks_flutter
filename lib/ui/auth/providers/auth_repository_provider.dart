import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/auth/auth.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final firebaseAuth = firebase_auth.FirebaseAuth.instance;
  return AuthRepositoryImpl(firebaseAuth: firebaseAuth);
}

@Riverpod(keepAlive: true)
Stream<User> userChanges(Ref ref) {
  return ref.watch(authRepositoryProvider).userChanges;
}
