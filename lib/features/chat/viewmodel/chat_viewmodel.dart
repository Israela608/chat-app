import 'dart:developer';
import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/features/chat/model/message.dart';
import 'package:chat_app/features/chat/viewmodel/notification_viewmodel.dart';
import 'package:chat_app/firebase_ref/references.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ChatViewmodel extends ChangeNotifier {
  ChatViewmodel({
    required this.authViewModel,
    required this.notificationViewmodel,
  });

  AuthViewmodel authViewModel;
  NotificationViewmodel notificationViewmodel;

  Message _currentMessage = Message(message: '');

  Message get currentMessage => _currentMessage;

  updateCurrentMessage({
    String? message,
    //String? time,
    //File? photo,
  }) {
    _currentMessage.message = message ?? _currentMessage.message;
    //_currentMessage.photo = photo ?? _currentMessage.photo;

    //log(jsonEncode(_currentMessage.toString()));
    notifyListeners();
  }

  resetCurrentMessage() {
    _currentMessage = Message(message: '');
    notifyListeners();
  }

  /*removeAttachedPhoto() {
    _currentMessage.photo = null;
    notifyListeners();
  }*/

  /*selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      File selectedImage = File(result.files.single.path ?? '');

      updateCurrentMessage(photo: selectedImage);

      String fileName = result.files.first.name;
      log('Selected file: $fileName');

      notifyListeners();
    }
  }*/

  void sendMessage() {
    log('Sending a Message');

    //Implement send functionality, i.e Send message
    chatsRF.add({
      'sender': authViewModel.user?.email,
      'message': _currentMessage.message,
      //'photo': _currentMessage.photo,
      'time': DateTime.now(), //Store the device time in the 'time' field
    });

    _currentMessage = Message();
    sendPushNotification(
      authViewModel.user?.email ?? '',
      _currentMessage.message ?? '',
    );
    notifyListeners();
  }

  void sendPushNotification(
    String titleText,
    String bodyText,
  ) async {
    //Get/Query the information of the specific user in the collection.
    DocumentSnapshot snap =
        await currentUserRF(userEmail: authViewModel.email.toString()).get();

    //Get the token field of the user information
    String token = snap['token'];
    log(token);

    //All we need to send the push notification is the token of the receiver, the title and body.
    notificationViewmodel.sendPushMessage(token, titleText, bodyText);
  }
}
