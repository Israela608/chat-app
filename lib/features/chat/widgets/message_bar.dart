import 'dart:developer';

import 'package:chat_app/common/utils/app_colors.dart';
import 'package:chat_app/common/utils/app_styles.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/features/chat/viewmodel/chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MessageBar extends HookWidget {
  const MessageBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();

    return Consumer<ChatViewmodel>(
      builder: (context, model, child) {
        return Container(
          margin: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            bottom: 23.w,
          ),
          padding: EdgeInsets.only(
            right: 16.w,
          ),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withOpacity(0.13),
                blurRadius: 20.r,
                offset: Offset(5.w, 4.h),
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  maxLines: 4,
                  minLines: 1,
                  controller: textEditingController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      // Process the submitted comment
                      log('Sending a message: $value');

                      model.sendMessage();
                      textEditingController.clear();

                      model.resetCurrentMessage();
                    }
                  },
                  style: poppinsStyle(
                    color: AppColor.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    // Remove Underline
                    decorationThickness: 0.0,
                  ),
                  cursorColor: AppColor.textAsh3,
                  onChanged: (value) {
                    model.updateCurrentMessage(message: value);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 22.w,
                      vertical: 20.h,
                    ),
                    hintText: 'Write your message',
                    hintMaxLines: 1,
                    hintStyle: poppinsStyle(
                      color: AppColor.textAsh3,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: (model.currentMessage.message != null &&
                        model.currentMessage.message!.isNotEmpty)
                    ? () {
                        log('Sending a message');

                        model.sendMessage();
                        textEditingController.clear();

                        model.resetCurrentMessage();
                      }
                    : null,
                child: Padding(
                  padding: EdgeInsets.all(4.h),
                  child: getImage(
                    image: 'send',
                    height: 30,
                    width: 30,
                    color: AppColor.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
