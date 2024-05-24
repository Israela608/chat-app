import 'package:flutter/widgets.dart';

typedef ValidateFunction = String? Function(String? value);

/// A form validator handler class
class Validators {
  /// validates users input to alphabets
  static String? Function(String?)? validateAlpha({
    String? error,
    required ValueChanged<bool>? isValidated,
    Function? function,
  }) {
    return (String? value) {
      isValidated!(false);

      if (value!.isEmpty) {
        return error ?? 'Field is required.';
      }
      final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
      if (!nameExp.hasMatch(value)) {
        return error ?? 'Please enter only alphabetical characters.';
      }

      isValidated(true);
      function?.call();

      return null;
    };
  }

  /// validates users input to double
  static String? Function(String?)? validateDouble({
    String? error,
    required ValueChanged<bool>? isValidated,
    Function? function,
  }) {
    return (String? value) {
      isValidated!(false);

      // ignore: unnecessary_null_comparison
      if (value == null || value.isEmpty) {
        return error ?? 'Field is required.';
      }
      if ((double.tryParse(value) ?? 0.0) <= 0.0) {
        return error ?? 'Not a valid number.';
      }

      isValidated(true);
      function?.call();
      return null;
    };
  }

  /// validates users input to int
  static String? Function(String?)? validateInt({
    String? error,
    required ValueChanged<bool>? isValidated,
    Function? function,
  }) {
    return (String? value) {
      isValidated!(false);

      if (value == null || value.isEmpty) {
        return error ?? 'Field is required.';
      }
      if ((int.tryParse(value) ?? 0.0) <= 0) {
        return error ?? 'Not a valid number.';
      }
      isValidated(true);
      function?.call();

      return null;
    };
  }

  /// validates users input is not empty
  static String? Function(String?)? validateText({
    String? error,
    required ValueChanged<bool>? isValidated,
    Function? function,
  }) {
    return (String? value) {
      isValidated!(false);

      if (value!.isEmpty) {
        return error ?? 'Field is required.';
      }

      isValidated(true);
      function?.call();

      return null;
    };
  }

  static String? Function(String?)? validateEmail({
    required ValueChanged<bool> isValidated,
    Function? function,
  }) {
    return (String? value) {
      isValidated(false);

      if (value!.isEmpty) {
        return 'Please Enter an Email';
      }
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
        return 'Please enter a valid Email';
      }

      isValidated(true);
      // Call the function if it's not null
      function?.call();

      return null;
    };
  }

  /// validates users input to a valid phone number
  static String? Function(String?)? validatePhone({
    required ValueChanged<bool> isValidated,
    Function? function,
  }) {
    return (String? value) {
      isValidated(false);

      if (value!.isEmpty) {
        return 'Enter a valid phone number';
      }
      if (!RegExp(r'^\d+?$').hasMatch(value) ||
          !value.startsWith(RegExp("0[1789]")) ||
          // Land lines eg 01
          (value.startsWith("01") && value.length != 9) ||
          // Land lines eg 080
          (value.startsWith(RegExp("0[789]")) && value.length != 11)) {
        return 'Not a valid phone number.';
      }

      isValidated(true);
      // Call the function if it's not null
      function?.call();

      return null;
    };
  }

  static String? Function(String?)? validatePassword({
    required ValueChanged<bool> isValidated,
    Function? function,
  }) {
    return (String? value) {
      isValidated(false);

      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return 'Password is required';
      }
      if (value.length < 6) {
        return 'Please Should not be less than 6 characters';
      }
      if (value.length > 255) {
        return 'Please Should not be more than 255 characters';
      }

      isValidated(true);
      // Call the function if it's not null
      function?.call();

      return null;
    };
  }

  /// validates users input to password ensuring the use
  /// of special characters
  static String? Function(String?)? validatePasswordWithSpecialCharacters({
    required ValueChanged<bool> isValidated,
    Function? function,
  }) {
    return (String? value) {
      isValidated(false);

      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return 'Password is required';
      }
      if (value.length < 6) {
        return 'Please Should not be less than 6 characters';
      }
      if (value.length > 255) {
        return 'Please Should not be more than 255 characters';
      }

      if (!_hasSpecialCharacter(value)) {
        return 'Password must contain special character';
      }

      isValidated(true);
      // Call the function if it's not null
      function?.call();

      return null;
    };
  }

  static String? Function(String?)? validateConfirmPassword({
    required String password,
    required ValueChanged<bool> isValidated,
    Function? function,
  }) {
    return (String? value) {
      isValidated(false);

      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return 'Password is required';
      }
      if (value != password) {
        return "Password does not match";
      }

      isValidated(true);
      function?.call();

      return null;
    };
  }

  /// checks and returns a true or false value depending on
  /// if there is a special value or not
  static bool _hasSpecialCharacter(String value) {
    var specialChars = "<>@!#\$%^&*()_+[]{}?:;|'\"\\,./~`-=";
    for (int i = 0; i < specialChars.length; i++) {
      if (value.contains(specialChars[i])) {
        return true;
      }
    }
    return false;
  }
}
