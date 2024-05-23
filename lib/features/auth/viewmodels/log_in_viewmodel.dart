import 'dart:developer';

import 'package:blanq_invoice/data/models/login.dart';
import 'package:blanq_invoice/data/models/response.dart';
import 'package:blanq_invoice/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';

class LogInViewModel extends ChangeNotifier {
  LogInViewModel({required this.authViewModel});

  AuthViewModel authViewModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late String email, password;
  late bool _isCompleted, _rememberMe;

  //IS_VALIDATED
  late bool isEmailValidated, isPasswordValidated;

  initialize() {
    _isLoading = false;
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

  Future<ResponseModel> logIn() async {
    _isLoading = true;
    notifyListeners();

    LogInModel logInBody = LogInModel(
      email: email.toLowerCase().trim(),
      password: password.trim(),
    );

    ResponseModel response = await authViewModel.login(
      logInModel: logInBody,
      rememberMe: _rememberMe,
    );

    _isLoading = false;
    notifyListeners();
    return response;
  }

  // Check if the User login was saved before
  Future<bool> checkRememberMe(BuildContext context) async {
    bool rememberMe = await authViewModel.rememberMe();

    if (rememberMe) {
      log('User login available');

      LogInModel? logInModel = await authViewModel.getUserLogin();

      email = logInModel!.email;
      password = logInModel.password;
      _rememberMe = true;
      _isCompleted = true;

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
