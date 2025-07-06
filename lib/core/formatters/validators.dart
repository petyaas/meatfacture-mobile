import 'package:email_validator/email_validator.dart';

class AppValidators {
  static String emptyValidator(String val, String errorText) {
    if (val == null || val.isEmpty) {
      return errorText;
    }
    return null;
  }

  static String emailValidator(String email) {
    return EmailValidator.validate(email) ? null : 'Неправильный формат почты';
  }
}
