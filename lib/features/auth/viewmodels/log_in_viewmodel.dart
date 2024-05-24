import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';

class LogInViewModel extends ChangeNotifier {
  LogInViewModel({required this.authViewModel});

  AuthViewmodel authViewModel;

  late String email, password;
  late bool _isCompleted, _rememberMe;

  //IS_VALIDATED
  late bool isEmailValidated, isPasswordValidated;

  initialize() {
    isEmailValidated = false;
    isPasswordValidated = false;

    _isCompleted = false;
    _rememberMe = false;
  }

  bool get isCompleted => _isCompleted;
  bool get rememberMe => _rememberMe;

  void toggleRememberMeCheck() {
    _rememberMe = !_rememberMe;
    updateButton();
    //notifyListeners();
  }

  void updateButton() {
    if (isEmailValidated && isPasswordValidated) {
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
