import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../../core/constants/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../repository/auth_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        authRepository: RepositoryProvider.of<AuthRepository>(context),
      ),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Sign In',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Email field
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return TextField(
                    key: const Key('login_email_field'),
                    onChanged: (email) => context.read<AuthBloc>().add(
                      AuthEmailChanged(email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      errorText: state.emailInput.error != null
                          ? 'Please enter a valid email'
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Password field
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return TextField(
                    key: const Key('login_password_field'),
                    onChanged: (password) => context.read<AuthBloc>().add(
                      AuthPasswordChanged(password),
                    ),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      errorText: state.passwordInput.error != null
                          ? 'Password must be at least 6 characters'
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Sign In button
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state.authStatus == AuthStatus.success) {
                    // Navigate to home screen
                    Navigator.pushReplacementNamed(context, '/home');
                  } else if (state.authStatus == AuthStatus.failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage ?? 'Login failed'),
                        backgroundColor: AppColors.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed:
                        state.formStatus == FormzStatus.valid &&
                            state.authStatus != AuthStatus.loading
                        ? () => context.read<AuthBloc>().add(
                            const AuthSignInSubmitted(),
                          )
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: state.authStatus == AuthStatus.loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Link to sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
