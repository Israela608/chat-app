import 'dart:developer';

import 'package:blanq_invoice/data/models/response.dart';
import 'package:blanq_invoice/data/models/signup.dart';
import 'package:blanq_invoice/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  SignUpViewModel({required this.authViewModel});

  AuthViewModel authViewModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late String fullName, email, password = '', confirmPassword;
  late bool _isCompleted;

  //IS_VALIDATED
  late bool isFullNameValidated,
      isEmailValidated,
      isPasswordValidated,
      isConfirmPasswordValidated;

  initialize() {
    _isLoading = false;

    isFullNameValidated = false;
    isEmailValidated = false;
    isPasswordValidated = false;
    isConfirmPasswordValidated = false;

    _isCompleted = false;
  }

  bool get isCompleted => _isCompleted;

  void updateButton() {
    if (isFullNameValidated &&
        isEmailValidated &&
        isPasswordValidated &&
        isConfirmPasswordValidated) {
      _isCompleted = true;
    } else {
      _isCompleted = false;
    }

    //Calls notify listener when the validating process is complete to prevent errors or interference
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<ResponseModel> signUp() async {
    _isLoading = true;
    notifyListeners();
    log('Signing Up');

    SignUpModel signUpBody = SignUpModel(
      fullName: fullName.trim(),
      email: email.toLowerCase().trim(),
      password: password.trim(),
    );

    ResponseModel response = await authViewModel.signUp(signUpBody);

    _isLoading = false;
    notifyListeners();
    return response;
  }
}
