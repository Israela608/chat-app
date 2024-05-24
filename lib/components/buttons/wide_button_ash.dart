import 'package:chat_app/common/utils/app_colors.dart';
import 'package:chat_app/common/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WideButtonAsh extends StatelessWidget {
  const WideButtonAsh({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.fillAsh2,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            text.toUpperCase(),
            style: poppinsStyle(
              color: AppColor.textDark,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
