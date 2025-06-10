import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/domain/core/exceptions/exceptions.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/ui/auth/providers/auth_repository_provider.dart';

part 'sign_in_notifier.g.dart';
part 'sign_in_state.dart';

@riverpod
class SignInNotifier extends _$SignInNotifier {
  @override
  SignInState build() => SignInState();

  void emailChanged(String email) => state = state.withEmail(email);

  void passwordChanged(String password) => state = state.withPassword(password);

  Future<void> signIn() async {
    if (!state.isFormValid) return;

    state = state.withLoading();

    final email = state.email;
    final password = state.password;
    final repository = ref.read(authRepositoryProvider);
    final response = await repository.signIn(email: email, password: password);

    state = response.fold(state.withFailure, state.withSuccess);
  }
}
