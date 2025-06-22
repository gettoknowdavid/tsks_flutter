part of 'sign_up_notifier.dart';

final class SignUpState with FormzMixin, EquatableMixin {
  const SignUpState() : this._();

  const SignUpState._({
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(PasswordMode.signUp),
    this.status = Status.initial,
    this.exception,
  });

  final FullName fullName;
  final Email email;
  final Password password;
  final Status status;
  final TsksException? exception;

  SignUpState withFullName(String fullName) {
    return SignUpState._(
      fullName: FullName.dirty(fullName),
      email: email,
      password: password,
    );
  }

  SignUpState withEmail(String email) {
    return SignUpState._(
      fullName: fullName,
      email: Email.dirty(email),
      password: password,
    );
  }

  SignUpState withPassword(String password) {
    return SignUpState._(
      fullName: fullName,
      email: email,
      password: Password.dirty(password, PasswordMode.signUp),
    );
  }

  SignUpState withSubmissionInProgress() {
    return SignUpState._(
      fullName: fullName,
      email: email,
      password: password,
      status: Status.inProgress,
    );
  }

  SignUpState withSubmissionSuccess(dynamic unit) {
    return SignUpState._(
      fullName: fullName,
      email: email,
      password: password,
      status: Status.success,
    );
  }

  SignUpState withSubmissionFailure(TsksException exception) {
    return SignUpState._(
      fullName: fullName,
      email: email,
      password: password,
      status: Status.failure,
      exception: exception,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [fullName, email, password];

  @override
  List<Object?> get props => [fullName, email, password, status, exception];
}
