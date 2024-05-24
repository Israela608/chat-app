import 'package:chat_app/common/utils/app_colors.dart';
import 'package:chat_app/common/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlainTextField extends StatefulWidget {
  const PlainTextField({
    super.key,
    required this.textController,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    required this.textInputAction,
    this.inputFormatters,
    this.validatorCallback,
    this.onChangedCallback,
    this.onSavedCallback,
  });

  final TextEditingController textController;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validatorCallback;
  final Function(String)? onChangedCallback;
  final Function(String?)? onSavedCallback;

  @override
  State<PlainTextField> createState() => _PlainTextFieldState();
}

class _PlainTextFieldState extends State<PlainTextField>
    with WidgetsBindingObserver {
  bool isKeyboardVisible = false;
  bool isTextFieldEmpty = true;
  bool isTextFieldValid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final keyboardHeight = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      isKeyboardVisible = keyboardHeight > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      validator: widget.validatorCallback,
      onChanged: (text) {
        if (widget.onChangedCallback != null) {
          widget.onChangedCallback!(text);
        }
        setState(() {
          isTextFieldEmpty = text.isEmpty;
          isTextFieldValid = widget.validatorCallback?.call(text) == null;
        });
      },
      onSaved: widget.onSavedCallback,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: widget.inputFormatters,
      style: poppinsStyle(
        color: AppColor.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        decorationThickness: 0,
      ),
      cursorColor: AppColor.textAsh,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: poppinsStyle(
          color: AppColor.textAsh2,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelText: !isKeyboardVisible && isTextFieldEmpty
            ? widget.hintText
            : widget.labelText,
        labelStyle: poppinsStyle(
          color: (isKeyboardVisible && !isTextFieldValid) ||
                  (!isKeyboardVisible && !isTextFieldEmpty && !isTextFieldValid)
              ? AppColor.black
              : AppColor.textAsh2,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 20.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            width: 1.h,
            color: AppColor.fillAsh,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            width: 1.h,
            color: AppColor.primaryGreen,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            width: 1.h,
            color: !isTextFieldEmpty ? AppColor.primaryGreen : AppColor.fillAsh,
          ),
        ),
        fillColor: !isKeyboardVisible && isTextFieldEmpty
            ? AppColor
                .fillAsh // Set the fill color to yellow when text is empty
            : Colors
                .transparent, // Set to null to use the default background color
        filled: true,
      ),
    );
  }
}
