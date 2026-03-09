import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../repository/auth_repository.dart';
import '../view/validation/email_input.dart';
import '../view/validation/password_input.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository}) : super(const AuthState()) {
    on<AuthEmailChanged>(_onEmailChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthSignUpSubmitted>(_onSignUpSubmitted);
    on<AuthSignInSubmitted>(_onSignInSubmitted);
  }

  final AuthRepository authRepository;

  void _onEmailChanged(AuthEmailChanged event, Emitter<AuthState> emit) {
    final emailInput = EmailInput.dirty(event.email);
    final formStatus = Formz.validate([emailInput, state.passwordInput]);
    String? errorMessage;
    if (emailInput.error != null) {
      errorMessage = 'Please enter a valid email.';
    } else if (state.passwordInput.error != null) {
      errorMessage = 'Please enter a valid password.';
    }
    emit(
      state.copyWith(
        emailInput: emailInput,
        formStatus: formStatus,
        authStatus: AuthStatus.initial,
        errorMessage: errorMessage,
      ),
    );
  }

  void _onPasswordChanged(AuthPasswordChanged event, Emitter<AuthState> emit) {
    final passwordInput = PasswordInput.dirty(event.password);
    final formStatus = Formz.validate([state.emailInput, passwordInput]);
    String? errorMessage;
    if (state.emailInput.error != null) {
      errorMessage = 'Please enter a valid email.';
    } else if (passwordInput.error != null) {
      errorMessage = 'Please enter a valid password.';
    }
    emit(
      state.copyWith(
        passwordInput: passwordInput,
        formStatus: formStatus,
        authStatus: AuthStatus.initial,
        errorMessage: errorMessage,
      ),
    );
  }

  Future<void> _onSignUpSubmitted(
    AuthSignUpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (state.formStatus != FormzStatus.valid) {
      String? errorMessage;
      if (state.emailInput.error != null) {
        errorMessage = 'Please enter a valid email.';
      } else if (state.passwordInput.error != null) {
        errorMessage = 'Please enter a valid password.';
      } else {
        errorMessage = 'Please enter valid email and password.';
      }
      emit(
        state.copyWith(
          authStatus: AuthStatus.failure,
          errorMessage: errorMessage,
        ),
      );
      return;
    }

    emit(state.copyWith(authStatus: AuthStatus.loading, errorMessage: null));

    try {
      await authRepository.signUpWithEmailAndPassword(
        email: state.emailInput.value,
        password: state.passwordInput.value,
      );
      emit(state.copyWith(authStatus: AuthStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          authStatus: AuthStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSignInSubmitted(
    AuthSignInSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (state.formStatus != FormzStatus.valid) {
      String? errorMessage;
      if (state.emailInput.error != null) {
        errorMessage = 'Please enter a valid email.';
      } else if (state.passwordInput.error != null) {
        errorMessage = 'Please enter a valid password.';
      } else {
        errorMessage = 'Please enter valid email and password.';
      }
      emit(
        state.copyWith(
          authStatus: AuthStatus.failure,
          errorMessage: errorMessage,
        ),
      );
      return;
    }

    emit(state.copyWith(authStatus: AuthStatus.loading, errorMessage: null));

    try {
      await authRepository.signInWithEmailAndPassword(
        email: state.emailInput.value,
        password: state.passwordInput.value,
      );
      emit(state.copyWith(authStatus: AuthStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          authStatus: AuthStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
