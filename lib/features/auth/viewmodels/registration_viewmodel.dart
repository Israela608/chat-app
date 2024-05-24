import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';

class RegistrationViewModel extends ChangeNotifier {
  RegistrationViewModel({required this.authViewModel});

  AuthViewmodel authViewModel;

  late String email, password = '', confirmPassword;
  late bool _isCompleted;

  //IS_VALIDATED
  late bool isEmailValidated, isPasswordValidated, isConfirmPasswordValidated;

  initialize() {
    _isCompleted = false;
    isEmailValidated = false;
    isPasswordValidated = false;
    isConfirmPasswordValidated = false;
  }

  bool get isCompleted => _isCompleted;

  void updateButton() {
    if (isEmailValidated && isPasswordValidated && isConfirmPasswordValidated) {
      _isCompleted = true;
    } else {
      _isCompleted = false;
    }

    //Calls notify listener when the validating process is complete to prevent errors or interference
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
