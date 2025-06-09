import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';
import 'package:tsks_flutter/ui/providers/providers.dart';

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
