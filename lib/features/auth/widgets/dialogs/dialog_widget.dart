import 'package:chat_app/common/utils/app_styles.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static final Dialogs _singleton = Dialogs._internal();
  Dialogs._internal();

  factory Dialogs() {
    return _singleton;
  }

  static Widget logoutDialog({required VoidCallback onTap}) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Logout',
            style: poppinsStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Do you want to Logout',
            style: poppinsStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: onTap,
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
