//The Message Stream class

import 'package:chat_app/components/widgets/loader/loading_overlay.dart';
import 'package:chat_app/features/chat/model/message.dart';
import 'package:chat_app/features/chat/widgets/message_bubble.dart';
import 'package:chat_app/firebase_ref/references.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageStream extends StatelessWidget {
  const MessageStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: chatsByTimeRF.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //If no data has being returned yet
            return const LoadingOverlay(isLoading: true);
          }

          return Expanded(
            //Very important, so that our ListView will not take up the entire screen, but only the empty space available
            child: ListView(
              reverse:
                  true, //Makes the bottom of the ListView stick to the top of the keyboard
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children:
                  snapshot.data!.docs.reversed.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                Message item = Message(
                  sender: data['sender'],
                  message: data['message'],
                  time: data['time'],
                );

                return MessageBubble(item: item);
              }).toList(),
            ),
          );
        });
  }
}
