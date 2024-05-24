import 'dart:developer';

import 'package:chat_app/common/helper/navigation.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/common/utils/validators.dart';
import 'package:chat_app/components/buttons/wide_button.dart';
import 'package:chat_app/components/others/spacer.dart';
import 'package:chat_app/components/text_fields/password_text_field.dart';
import 'package:chat_app/components/text_fields/plain_text_field.dart';
import 'package:chat_app/components/widgets/loader/loading_overlay.dart';
import 'package:chat_app/components/widgets/loader/loading_stack.dart';
import 'package:chat_app/components/widgets/show_custom_snackbar.dart';
import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/features/auth/viewmodels/registration_viewmodel.dart';
import 'package:chat_app/features/auth/widgets/components/google_button.dart';
import 'package:chat_app/features/chat/screens/chat_screen.dart';
import 'package:chat_app/features/chat/viewmodel/notification_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends HookWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    useEffect(() {
      Provider.of<RegistrationViewModel>(context, listen: false).initialize();
      return;
    });

    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingStack(
          loader: Consumer<AuthViewmodel>(
            builder: (context, model, child) {
              return LoadingOverlay(isLoading: model.showSpinner);
            },
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: Hero(
                      tag: 'logo',
                      child: getImage(
                        image: 'logo',
                        height: 132,
                        width: 202,
                      ),
                    ),
                  ),
                  const HeightSpacer(height: 48),
                  const EmailBox(),
                  const HeightSpacer(height: 10),
                  const PasswordBox(),
                  const HeightSpacer(height: 10),
                  const ConfirmPasswordBox(),
                  const HeightSpacer(height: 20),
                  CreateAccountButton(formKey: formKey),
                  const HeightSpacer(height: 20),
                  const GoogleButton(),
                  const HeightSpacer(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmailBox extends HookWidget {
  const EmailBox({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();

    return Consumer<RegistrationViewModel>(builder: (context, model, child) {
      return PlainTextField(
        labelText: 'Email Address',
        textController: textController,
        hintText: 'Enter Email Address',
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        validatorCallback: Validators.validateEmail(
          isValidated: (value) {
            model.isEmailValidated = value;
          },
          function: model.updateButton,
        ),
        onChangedCallback: (value) {
          model.email = value;
        },
        onSavedCallback: (value) {
          model.email = value ?? '';
        },
      );
    });
  }
}

class PasswordBox extends HookWidget {
  const PasswordBox({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final isObscure = useState(true);

    return Consumer<RegistrationViewModel>(builder: (context, model, child) {
      return PasswordTextField(
        labelText: 'Password',
        textController: textController,
        hintText: 'Enter Password',
        isObscure: isObscure.value,
        onObscurePressedCallback: () {
          isObscure.value = !isObscure.value;
        },
        textInputAction: TextInputAction.done,
        validatorCallback: Validators.validatePassword(
          isValidated: (value) {
            model.isPasswordValidated = value;
          },
          function: model.updateButton,
        ),
        onChangedCallback: (value) {
          model.password = value;
        },
        onSavedCallback: (value) {
          model.password = value ?? '';
        },
      );
    });
  }
}

class ConfirmPasswordBox extends HookWidget {
  const ConfirmPasswordBox({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final isObscure = useState(true);

    return Consumer<RegistrationViewModel>(builder: (context, model, child) {
      return PasswordTextField(
        labelText: 'Confirm Password',
        textController: textController,
        hintText: 'Enter Password',
        isObscure: isObscure.value,
        onObscurePressedCallback: () {
          isObscure.value = !isObscure.value;
        },
        textInputAction: TextInputAction.done,
        validatorCallback: Validators.validateConfirmPassword(
          password: model.password,
          isValidated: (value) {
            model.isConfirmPasswordValidated = value;
          },
          function: model.updateButton,
        ),
        onChangedCallback: (value) {
          model.confirmPassword = value;
        },
        onSavedCallback: (value) {
          model.confirmPassword = value ?? '';
        },
      );
    });
  }
}

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Consumer<RegistrationViewModel>(
      builder: (context, model, child) {
        return WideButton(
          text: 'Create an Account',
          isEnabled: model.isCompleted,
          onPressed: () {
            final authProvider =
                Provider.of<AuthViewmodel>(context, listen: false);


            authProvider
                .signInWithEmailAndPassword(
              email: model.email,
              password: model.password,
            )
                .then((value) {
              if (value.isSuccess) {
                showCustomSnackBar(
                  context,
                  message: value.message!,
                  isError: !value.isSuccess,
                );

                final notificationProvider =
                Provider.of<NotificationViewmodel>(context, listen: false);

                notificationProvider.initializeNotifications(context);


                Navigation.gotoWidget(
                  context,
                  clearStack: true,
                  const ChatScreen(),
                );

                log('Successful Registration');
              } else {
                log('Unsuccessful Registration');
                showCustomSnackBar(context, message: value.message!);
              }
            });
          },
        );
      },
    );
  }
}
