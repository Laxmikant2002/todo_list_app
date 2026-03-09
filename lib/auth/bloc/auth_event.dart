part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthEmailChanged extends AuthEvent {
  const AuthEmailChanged(this.email);
  final String email;

  @override
  List<Object> get props => [email];
}

final class AuthPasswordChanged extends AuthEvent {
  const AuthPasswordChanged(this.password);
  final String password;

  @override
  List<Object> get props => [password];
}

final class AuthSignUpSubmitted extends AuthEvent {
  const AuthSignUpSubmitted();
}

final class AuthSignInSubmitted extends AuthEvent {
  const AuthSignInSubmitted();
}
