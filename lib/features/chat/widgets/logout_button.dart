import 'dart:developer';

import 'package:chat_app/common/helper/navigation.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/components/widgets/show_custom_snackbar.dart';
import 'package:chat_app/features/auth/screens/welcome_screen.dart';
import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return getSvg(
        svg: 'logout',
        height: 24,
        width: 24,
        color: Colors.white,
        onPressed: () {
          Provider.of<AuthViewmodel>(context, listen: false)
              .signOut()
              .then((value) {
            if (value.isSuccess) {
              showCustomSnackBar(
                context,
                message: value.message!,
                isError: !value.isSuccess,
              );

              Navigation.gotoWidget(
                context,
                clearStack: true,
                const WelcomeScreen(),
              );

              log('Logged Out Successfully');
            } else {
              log('Unable to Log out');
              showCustomSnackBar(context, message: value.message!);
            }
          });
        });
  }
}
