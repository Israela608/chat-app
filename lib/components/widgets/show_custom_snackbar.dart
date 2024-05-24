import 'package:chat_app/common/utils/app_colors.dart';
import 'package:chat_app/common/utils/app_styles.dart';
import 'package:chat_app/data/model/response.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String message,
  bool isError = true,
  String title = 'Error',
}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: poppinsStyle(
        fontSize: 12,
        color: AppColor.white,
        fontWeight: FontWeight.w400,
      ),
    ),
    backgroundColor: isError ? Colors.redAccent : AppColor.primaryGreen,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void responseSnackBar({
  required BuildContext context,
  required ResponseModel value,
  required String successMessage,
  String errorMessage = '',
}) {
  if (value.isSuccess) {
    showCustomSnackBar(
      context,
      message: successMessage,
      isError: false,
    );
  } else {
    showCustomSnackBar(
      context,
      message: errorMessage.isNotEmpty ? errorMessage : value.message ?? '',
    );
  }
}
