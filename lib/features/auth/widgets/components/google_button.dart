import 'package:chat_app/common/helper/navigation.dart';
import 'package:chat_app/common/utils/app_colors.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/components/widgets/show_custom_snackbar.dart';
import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/features/chat/screens/chat_screen.dart';
import 'package:chat_app/features/chat/viewmodel/notification_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        height: 65.h,
        child: InkWell(
          onTap: () {
            final authProvider =
                Provider.of<AuthViewmodel>(context, listen: false);

            authProvider.signInWithGoogle().then((value) {
              if (value.isSuccess) {
                final notificationProvider =
                    Provider.of<NotificationViewmodel>(context, listen: false);

                notificationProvider.initializeNotifications(context);

                Navigation.gotoWidget(
                  context,
                  const ChatScreen(),
                );
              }

              return showCustomSnackBar(
                context,
                message: value.message ?? '',
                isError: !value.isSuccess,
              );
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: AppColor.fillAsh2,
            ),
            width: double.maxFinite,
            child: Padding(
              padding: EdgeInsets.all(10.h),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 20.w,
                    child: getSvg(
                      svg: 'google',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Sign in with Google',
                      style: TextStyle(
                        color: AppColor.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
