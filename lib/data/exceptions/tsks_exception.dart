import 'package:equatable/equatable.dart';

final class TsksException with EquatableMixin implements Exception {
  const TsksException(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class EmailAlreadyInUseException extends TsksException {
  const EmailAlreadyInUseException([
    super.message =
        'The email address is already in use. Please try signing in.',
  ]);
}

final class NoUserException extends TsksException {
  const NoUserException([
    super.message = 'No user found. Please try signing in.',
  ]);
}

final class InvalidEmailOrPasswordException extends TsksException {
  const InvalidEmailOrPasswordException([
    super.message = 'Invalid email address or password.',
  ]);
}

final class TsksTimeoutException extends TsksException {
  const TsksTimeoutException([
    super.message = 'The operation timed out. Please try again.',
  ]);
}

final class TsksUnknownException extends TsksException {
  const TsksUnknownException([super.message = 'Unknown exception']);
}

final class NoCollectionFoundException extends TsksException {
  const NoCollectionFoundException([super.message = 'No collection found']);
}

final class NoTaskFoundException extends TsksException {
  const NoTaskFoundException([super.message = 'No task found']);
}
