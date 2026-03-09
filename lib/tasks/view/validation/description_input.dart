import 'package:formz/formz.dart';

enum DescriptionValidationError { none }

class DescriptionInput extends FormzInput<String, DescriptionValidationError> {
  const DescriptionInput.pure() : super.pure('');
  const DescriptionInput.dirty([String value = '']) : super.dirty(value);

  @override
  DescriptionValidationError? validator(String value) {
    // No validation for description, always valid
    return null;
  }
}
