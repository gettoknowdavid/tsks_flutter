import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/data/repositories/auth/auth_repository.dart';
import 'package:tsks_flutter/data/services/cloud_firestore.dart';
import 'package:tsks_flutter/models/auth/user.dart';

part 'session.g.dart';

@Riverpod(keepAlive: true)
class Session extends _$Session {
  @override
  AsyncValue<User> build() {
    state = const AsyncLoading();

    ref.listen(userChangesProvider, (_, next) {
      state = next;
    }, fireImmediately: true);

    final initialUser = ref.read(authRepositoryProvider).user;
    return state = AsyncData(initialUser);
  }

  Future<void> signOut() => ref.read(authRepositoryProvider).signOut();
}

@riverpod
DocumentReference<User> userDocumentReference(Ref ref) {
  final user = ref.watch(sessionProvider).valueOrNull;
  if (user == null || user == User.empty) throw const NoUserException();
  final firestore = ref.read(firestoreProvider);
  return firestore.collection('users').userConverter.doc(user.id);
}

extension UsersCollectionReferenceX on CollectionReference {
  CollectionReference<User> get userConverter {
    return withConverter<User>(
      fromFirestore: (snapshot, _) => User.fromFirestore(snapshot),
      toFirestore: (model, _) => model.toFirestore(),
    );
  }
}
