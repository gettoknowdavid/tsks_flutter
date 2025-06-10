import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/domain/core/exceptions/exceptions.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/ui/auth/providers/auth_repository_provider.dart';

part 'sign_up_notifier.g.dart';
part 'sign_up_state.dart';

@riverpod
class SignUpNotifier extends _$SignUpNotifier {
  @override
  SignUpState build() => SignUpState();

  void fullNameChanged(String fullName) => state = state.withFullName(fullName);

  void emailChanged(String email) => state = state.withEmail(email);

  void passwordChanged(String password) => state = state.withPassword(password);

  Future<void> signUp() async {
    if (!state.isFormValid) return;

    state = state.withLoading();

    final repository = ref.read(authRepositoryProvider);
    final response = await repository.signUp(
      fullName: state.fullName,
      email: state.email,
      password: state.password,
    );

    state = response.fold(state.withFailure, state.withSuccess);
  }
}
