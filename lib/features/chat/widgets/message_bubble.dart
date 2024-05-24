//The Message bubble class
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Oathlify/common/utils/app_colors.dart';
import 'package:Oathlify/common/utils/app_styles.dart';
import 'package:Oathlify/components/others/spacer.dart';
import 'package:Oathlify/features/account/contact/model/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.item,
  });

  final Message item;

  @override
  Widget build(BuildContext context) {
    //If the sender field is same as the current user, i.e if i am the one sending, then isMe is true, else false
    final bool isMe = item.sender == 'You';

    return Padding(
      //Padding between each messages
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 39.h,
      ),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          // crossAxisAlignment:
          //     isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children:
              isMe ? _messageRow(isMe).reversed.toList() : _messageRow(isMe),
        ),
      ),
    );
  }

  List<Widget> _messageRow(bool isMe) => [
        // Message
        Expanded(
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              color: isMe ? AppColor.primaryBlue : AppColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.r),
                topRight: Radius.circular(isMe ? 0 : 25.r),
                bottomLeft: Radius.circular(isMe ? 25.r : 0),
                bottomRight: Radius.circular(25.r),
              ),
            ),
            child: Text(
              item.message ?? '',
              style: isMe
                  ? nunitoStyle(
                      color: AppColor.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    )
                  : workSansStyle(
                      color: AppColor.textAsh3,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
            ),
          ),
        ),
        const WidthSpacer(width: 68),
      ];
}
