part of 'sign_in_notifier.dart';

final class SignInState with EquatableMixin {
  SignInState() : this._(email: Email(''), password: Password(''));

  const SignInState._({
    required this.email,
    required this.password,
    this.status = SignInStatus.initial,
    this.exception,
  });

  final Email email;
  final Password password;
  final SignInStatus status;
  final TsksException? exception;

  @override
  List<Object?> get props => [email, password, status, exception];

  SignInState withEmail(String email) {
    return SignInState._(email: Email(email), password: password);
  }

  SignInState withFailure(TsksException exception) {
    return SignInState._(
      email: email,
      password: password,
      status: SignInStatus.failure,
      exception: exception,
    );
  }

  SignInState withLoading() {
    return SignInState._(
      email: email,
      password: password,
      status: SignInStatus.loading,
    );
  }

  SignInState withPassword(String password) {
    return SignInState._(email: email, password: Password(password));
  }

  SignInState withSuccess(dynamic unit) {
    return SignInState._(
      email: email,
      password: password,
      status: SignInStatus.success,
    );
  }

  bool get isFormValid => email.isValid && password.isValid;
}

enum SignInStatus { initial, loading, success, failure }
