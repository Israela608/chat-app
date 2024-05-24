import 'package:chat_app/common/utils/app_colors.dart';
import 'package:chat_app/common/utils/app_styles.dart';
import 'package:chat_app/common/utils/converters.dart';
import 'package:chat_app/components/others/spacer.dart';
import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/features/chat/model/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.item,
  });

  final Message item;

  @override
  Widget build(BuildContext context) {
    final bool isMe =
        Provider.of<AuthViewmodel>(context, listen: false).user?.email ==
            item.sender;

    return Padding(
      //Padding between each messages
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 4.h,
      ),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children:
              isMe ? _messageRow(isMe).reversed.toList() : _messageRow(isMe),
        ),
      ),
    );
  }

  List<Widget> _messageRow(bool isMe) => [
        // Profile Picture
        // if(!isMe)
        //   CircleAvatar(
        //     radius: 15.r,
        //     child: ,
        //   ),
        // Message
        Flexible(
          child: Container(
            //width: double.maxFinite,
            padding: EdgeInsets.only(
              top: 12.h,
              bottom: 8.h,
              left: 12.w,
              right: 8.w,
            ),
            decoration: BoxDecoration(
              color: isMe ? AppColor.primaryGreen : AppColor.fillAsh2,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(isMe ? 0 : 16.r),
                bottomLeft: Radius.circular(isMe ? 16.r : 0),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMe)
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Text(item.sender ?? '',
                            style: poppinsStyle(
                              color: AppColor.primaryGreen,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    Text(
                      item.message ?? '',
                      style: isMe
                          ? poppinsStyle(
                              color: AppColor.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            )
                          : poppinsStyle(
                              color: AppColor.textDark2,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                    ),
                    const HeightSpacer(height: 6),
                  ],
                ),
                const WidthSpacer(width: 10),
                Text(
                  convertTimeStampToTime(item.time).toString(),
                  style: poppinsStyle(
                    color: isMe ? AppColor.textAsh2 : AppColor.textAsh3,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        const WidthSpacer(width: 68),
      ];
}
