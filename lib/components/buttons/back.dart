import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Back extends StatelessWidget {
  const Back({
    super.key,
    this.onPress,
  });

  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress ?? () => Navigator.pop(context),
      child: SizedBox(
        height: 25.h,
        width: 25.w,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Icon(
            Icons.arrow_back_ios,
            size: 25.h,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
