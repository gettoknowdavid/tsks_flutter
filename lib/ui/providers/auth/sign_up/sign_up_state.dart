part of 'sign_up_notifier.dart';

final class SignUpState with EquatableMixin {
  SignUpState()
    : this._(
        fullName: SingleLineString(''),
        email: Email(''),
        password: Password(''),
      );

  const SignUpState._({
    required this.fullName,
    required this.email,
    required this.password,
    this.status = SignInStatus.initial,
    this.exception,
  });

  final SingleLineString fullName;
  final Email email;
  final Password password;
  final SignInStatus status;
  final TsksException? exception;

  @override
  List<Object?> get props => [fullName, email, password, status, exception];

  SignUpState withFullName(String fullName) {
    return SignUpState._(
      fullName: SingleLineString(fullName),
      email: email,
      password: password,
    );
  }

  SignUpState withEmail(String email) {
    return SignUpState._(
      fullName: fullName,
      email: Email(email),
      password: password,
    );
  }

  SignUpState withPassword(String password) {
    return SignUpState._(
      fullName: fullName,
      email: email,
      password: Password(password),
    );
  }

  SignUpState withLoading() {
    return SignUpState._(
      fullName: fullName,
      email: email,
      password: password,
      status: SignInStatus.loading,
    );
  }

  SignUpState withSuccess(dynamic unit) {
    return SignUpState._(
      fullName: fullName,
      email: email,
      password: password,
      status: SignInStatus.success,
    );
  }

  SignUpState withFailure(TsksException exception) {
    return SignUpState._(
      fullName: fullName,
      email: email,
      password: password,
      status: SignInStatus.failure,
      exception: exception,
    );
  }

  bool get isFormValid => email.isValid && password.isValid;
}

enum SignInStatus { initial, loading, success, failure }
