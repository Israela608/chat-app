import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle poppinsStyle({
  required double fontSize,
  required Color color,
  required FontWeight fontWeight,
  double? height,
  TextDecoration? decoration,
  Color? decorationColor,
  double? decorationThickness,
}) {
  return TextStyle(
    fontFamily: 'Poppins',
    fontSize: fontSize.sp,
    color: color,
    fontWeight: fontWeight,
    height: height?.h,
    decoration: decoration,
    decorationColor: decorationColor ?? color,
    decorationThickness: decorationThickness,
  );
}
