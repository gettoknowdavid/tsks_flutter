part of 'sign_in_notifier.dart';

final class SignInState with FormzMixin, EquatableMixin {
  const SignInState() : this._();

  const SignInState._({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = Status.initial,
    this.exception,
  });

  final Email email;
  final Password password;
  final Status status;
  final TsksException? exception;

  SignInState withEmail(String email) {
    return SignInState._(email: Email.dirty(email), password: password);
  }

  SignInState withPassword(String password) {
    return SignInState._(email: email, password: Password.dirty(password));
  }

  SignInState withSubmissionInProgress() {
    return SignInState._(
      email: email,
      password: password,
      status: Status.inProgress,
    );
  }

  SignInState withSubmissionFailure(TsksException exception) {
    return SignInState._(
      email: email,
      password: password,
      status: Status.failure,
      exception: exception,
    );
  }

  SignInState withSubmissionSuccess(dynamic unit) {
    return SignInState._(
      email: email,
      password: password,
      status: Status.success,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [email, password];

  @override
  List<Object?> get props => [email, password, status, exception];
}
