import 'package:chat_app/common/utils/app_colors.dart';
import 'package:chat_app/common/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WideButton extends StatelessWidget {
  const WideButton({
    super.key,
    required this.text,
    this.isBlack = false,
    this.backgroundColor = AppColor.primaryGreen,
    this.isEnabled = true,
    this.isNoTextScale = false,
    required this.onPressed,
  });

  final String text;
  final bool isBlack;
  final Color backgroundColor;
  final bool isEnabled;
  final bool isNoTextScale;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isEnabled
              ? isBlack
                  ? AppColor.black
                  : backgroundColor
              : AppColor.borderAsh,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            text.toUpperCase(),
            textScaler: isNoTextScale ? TextScaler.noScaling : null,
            style: poppinsStyle(
              color: AppColor.background,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
