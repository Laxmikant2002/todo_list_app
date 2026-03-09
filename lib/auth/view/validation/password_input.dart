import 'package:formz/formz.dart';

enum PasswordValidationError { tooShort, invalid }

/// Form input for a password field.
class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([String value = '']) : super.dirty(value);

  static const minLength = 6;

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.tooShort;
    if (value.length < minLength) return PasswordValidationError.tooShort;
    // You can add more rules (uppercase, numbers, etc.) if desired
    return null;
  }
}
