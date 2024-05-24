import 'package:chat_app/common/helper/navigation.dart';
import 'package:chat_app/common/utils/app_styles.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/components/buttons/wide_button.dart';
import 'package:chat_app/components/others/spacer.dart';
import 'package:chat_app/features/auth/screens/log_in_screen.dart';
import 'package:chat_app/features/auth/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
              //scale: 0.2,
              curve: Curves.easeInOut,
              duration: const Duration(seconds: 5000),
              child: Hero(
                tag: 'logo',
                child: getImage(
                  image: 'logo',
                  height: 160,
                  width: 245,
                ),
              ),
            ),
            const HeightSpacer(height: 30),
            Center(
              child: DefaultTextStyle(
                style: poppinsStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [TypewriterAnimatedText('Chat with Friends')],
                ),
              ),
            ),
            const HeightSpacer(height: 38),
            WideButton(
                text: 'Log In',
                onPressed: () {
                  Navigation.gotoWidget(
                    context,
                    const LoginScreen(),
                  );
                }),
            const HeightSpacer(height: 20),
            WideButton(
                text: 'Register',
                isBlack: true,
                onPressed: () {
                  Navigation.gotoWidget(
                    context,
                    const RegistrationScreen(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
