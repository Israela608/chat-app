import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Navigation {
  static Future<void> gotoWidget(
    BuildContext? context,
    Widget screen, {
    bool replacePreviousScreen = false,
    bool clearStack = false,
    bool rootNavigator = false,
    bool fullScreenDialog = false,
    PageTransitionType animationType = PageTransitionType.fade,
  }) async {
    if (!clearStack) {
      if (!replacePreviousScreen) {
        await Navigator.of(context!, rootNavigator: rootNavigator).push(
          PageTransition(
            type: animationType,
            child: screen,
          ),
        );
      } else {
        await Navigator.of(context!, rootNavigator: rootNavigator)
            .pushReplacement(
          PageTransition(
            type: animationType,
            child: screen,
          ),
        );
      }
    } else {
      await Navigator.of(context!, rootNavigator: rootNavigator)
          .pushAndRemoveUntil(
        PageTransition(
          type: animationType,
          child: screen,
        ),
        (_) => false,
      );
    }
  }

  static Future<void> gotoNamed(
    BuildContext context,
    String route, {
    bool clearStack = false,
    bool rootNavigator = false,
    dynamic args = Object,
  }) async {
    if (!clearStack) {
      await Navigator.of(context, rootNavigator: rootNavigator).pushNamed(
        route,
        arguments: args,
      );
    } else {
      await Navigator.of(context).pushNamedAndRemoveUntil(
        route,
        (_) => false,
        arguments: args,
      );
    }
  }

  static void goBack(
    BuildContext context, {
    bool rootNavigator = false,
  }) {
    Navigator.of(context, rootNavigator: rootNavigator).pop();
  }
}
