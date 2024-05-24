import 'dart:developer';

import 'package:chat_app/common/helper/navigation.dart';
import 'package:chat_app/components/widgets/loader/loading_overlay.dart';
import 'package:chat_app/components/widgets/loader/loading_stack.dart';
import 'package:chat_app/features/auth/screens/welcome_screen.dart';
import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/features/chat/screens/chat_screen.dart';
import 'package:chat_app/features/chat/viewmodel/notification_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransitionScreen extends StatefulWidget {
  const TransitionScreen({super.key});

  @override
  State<TransitionScreen> createState() => _TransitionScreenState();
}

class _TransitionScreenState extends State<TransitionScreen> {
  @override
  void initState() {
    super.initState();

    getCurrentUser(); //Trigger this method when our state is initialized
  }

  //Check if there is a current user who signed in
  void getCurrentUser() {
    final authProvider = Provider.of<AuthViewmodel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (authProvider.isAlreadyLoggedIn) {
          log(authProvider.email.toString());

          final notificationProvider =
              Provider.of<NotificationViewmodel>(context, listen: false);

          notificationProvider.initializeNotifications(context);

          Navigation.gotoWidget(
            context,
            clearStack: true,
            const ChatScreen(),
          );
        } else {
          log("You're not Logged in");
          Navigation.gotoWidget(
            context,
            clearStack: true,
            const WelcomeScreen(),
          );
        }
      } catch (e) {
        log(e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: LoadingStack(
        loader: LoadingOverlay(isLoading: true),
        child: SizedBox.expand(),
      ),
    );
  }
}
