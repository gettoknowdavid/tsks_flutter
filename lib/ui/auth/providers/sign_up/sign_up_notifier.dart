import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/data/repositories/auth/auth_repository.dart';
import 'package:tsks_flutter/ui/core/models/models.dart';

part 'sign_up_notifier.g.dart';
part 'sign_up_state.dart';

@riverpod
class SignUpNotifier extends _$SignUpNotifier {
  @override
  SignUpState build() => const SignUpState();

  void fullNameChanged(String fullName) => state = state.withFullName(fullName);

  void emailChanged(String email) => state = state.withEmail(email);

  void passwordChanged(String password) => state = state.withPassword(password);

  Future<void> signUp() async {
    if (state.isNotValid) return;

    state = state.withSubmissionInProgress();

    final repository = ref.read(authRepositoryProvider);
    final response = await repository.signUp(
      fullName: state.fullName.value,
      email: state.email.value,
      password: state.password.value,
    );

    state = response.fold(
      state.withSubmissionFailure,
      state.withSubmissionSuccess,
    );
  }
}
