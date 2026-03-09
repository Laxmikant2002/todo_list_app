part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, success, failure }

final class AuthState extends Equatable {
  const AuthState({
    this.emailInput = const EmailInput.pure(),
    this.passwordInput = const PasswordInput.pure(),
    this.formStatus = FormzStatus.pure,
    this.authStatus = AuthStatus.initial,
    this.errorMessage,
  });

  final EmailInput emailInput;
  final PasswordInput passwordInput;
  final FormzStatus formStatus;
  final AuthStatus authStatus;
  final String? errorMessage;

  AuthState copyWith({
    EmailInput? emailInput,
    PasswordInput? passwordInput,
    FormzStatus? formStatus,
    AuthStatus? authStatus,
    String? errorMessage,
  }) {
    return AuthState(
      emailInput: emailInput ?? this.emailInput,
      passwordInput: passwordInput ?? this.passwordInput,
      formStatus: formStatus ?? this.formStatus,
      authStatus: authStatus ?? this.authStatus,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    emailInput,
    passwordInput,
    formStatus,
    authStatus,
    errorMessage,
  ];
}
