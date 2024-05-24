import 'package:chat_app/common/utils/app_colors.dart';
import 'package:chat_app/common/utils/app_styles.dart';
import 'package:chat_app/components/buttons/back.dart';
import 'package:chat_app/components/others/spacer.dart';
import 'package:chat_app/features/chat/widgets/logout_button.dart';
import 'package:chat_app/features/chat/widgets/message_bar.dart';
import 'package:chat_app/features/chat/widgets/message_stream.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Back(),
        actions: const [
          LogoutButton(),
          WidthSpacer(width: 8),
        ],
        centerTitle: true,
        title: Text(
          '️Chat App',
          style: poppinsStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColor.primaryGreen,
      ),
      body: const SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStream(), //Get the stream of messages
            MessageBar(),
          ],
        ),
      ),
    );
  }
}
