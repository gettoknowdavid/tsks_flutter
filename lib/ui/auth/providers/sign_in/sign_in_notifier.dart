import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/data/repositories/auth/auth_repository.dart';
import 'package:tsks_flutter/ui/core/models/models.dart';

part 'sign_in_notifier.g.dart';
part 'sign_in_state.dart';

@riverpod
class SignInNotifier extends _$SignInNotifier {
  @override
  SignInState build() => const SignInState();

  void emailChanged(String email) => state = state.withEmail(email);

  void passwordChanged(String password) => state = state.withPassword(password);

  Future<void> signIn() async {
    if (state.isNotValid) return;

    state = state.withSubmissionInProgress();

    final repository = ref.read(authRepositoryProvider);
    final response = await repository.signIn(
      email: state.email.value,
      password: state.password.value,
    );

    state = response.fold(
      state.withSubmissionFailure,
      state.withSubmissionSuccess,
    );
  }
}
