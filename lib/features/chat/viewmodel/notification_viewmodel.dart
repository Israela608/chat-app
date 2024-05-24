import 'dart:convert';
import 'dart:developer';
import 'package:chat_app/common/helper/navigation.dart';
import 'package:chat_app/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:chat_app/features/chat/screens/chat_screen.dart';
import 'package:chat_app/firebase_ref/references.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationViewmodel extends ChangeNotifier {
  NotificationViewmodel({required this.authViewModel});

  AuthViewmodel authViewModel;

  String? mtoken = '';
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initializeNotifications(BuildContext context) {
    requestPermission();
    getToken();
    initInfo(context);
  }

  void requestPermission() async {
    //We create a firebase messaging object
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    //Request permission for the parameters that are true
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('PERMISSION: User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('PERMISSION: User granted provisional permission');
    } else {
      log('PERMISSION: User declined or has not accepted permission');
    }
  }

  //Connect with firebase and get a token for this specific device
  //Each device has it's specific special token for accessing firebase
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      mtoken = token;
      notifyListeners();
      log('My token is   $mtoken');
      saveToken(token!);
    });
  }

  //Method that saves the user token to firebase
  void saveToken(String token) async {
    await currentUserRF(userEmail: authViewModel.email.toString()).set({
      'token': token,
    });
  }

  //Initialize our flutter notification values
  initInfo(BuildContext context) {
    //Initialize the android settings
    var androidInitialize =
        const AndroidInitializationSettings('@drawable/logo');
    //Initialize the IOS settings
    var iOSInitialize = const DarwinInitializationSettings();
    //The new settings function with both android and IOS settings
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    //We call/initialize it in our flutter local notification plugin function
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        //This is the callback function for sending payload in the foreground.
        //This will redirect you to a new page from the foreground
        onDidReceiveNotificationResponse:
            (NotificationResponse? payload) async {
      try {
        if (payload != null) {
          Navigation.gotoWidget(
            context,
            const ChatScreen(),
          );
        } else {}
      } catch (e) {}
      return;
    });

    //Method that listen to messages coming from firebase
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('....................onMessage...................');
      log('onMessage: ${message.notification?.title}/${message.notification?.body}');

      //Notification plugin settings
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      //Android platform specific settings
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'ChatApp',
        'ChatApp',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
        //Play this sound when the user gets a notification.
        //The sound is in android-> app-> src-> main-> res-> raw folder
        sound: const RawResourceAndroidNotificationSound('angelina'),
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(),
      );

      //Show the message on device
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: message.data['body'],
      );
    });
  }

  //Method that sends push notification a user, by using the user's token
  /*void sendPushMessage(String token, String body, String title) async {
    try {
      //This is the post method to post messages to the firebase console
      await http.post(
        //This is the firebase post uri
        //Uri.parse('https://fcm.googleapis.com/fcm/send'),
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          */ /*'Authorization':
              'key=AAAAsJglAgM:APA91bFAm0sQEYDJ3h2eSkHxEH0XZT9DCgzqjTAX-l_eXTbU4_LvCDeuKSevtBt-I45umU3jpt1iDkOBguUUwrHfvo2IzNxf0u1trjblm1aroMYe7i9Gu9O6FN8L0W5B0V5chBYE9ll9'
        */ /*
          'Authorization': 'Bearer 07eb6dc687dac7ec468ffc515b6eeccd0ea87967',
        },
        body: jsonEncode(
          //If you only want notification, then you don't need the 'data' parameter below. You need just this 'notification parameter
          // But if you want the notification to be clickable so you can go to a new page, then you also need the 'data' parameter
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
              'android_channel_id': 'ChatApp'
            },
            'to': token,
          },
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        log('error push notification');
      }
    }
  }*/

  void sendPushMessage(String token, String body, String title) async {
    try {
      // Get all user tokens from Firestore
      QuerySnapshot snapshot = await userRF.get();

      // Filter out the token you want to exclude
      List<String> tokens = snapshot.docs
          .map((doc) => doc['token'] as String)
          .where((t) => t != token)
          .toList();

      // Send notification to all remaining tokens
      for (String t in tokens) {
        await http.post(
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer 07eb6dc687dac7ec468ffc515b6eeccd0ea87967',
          },
          body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'body': body,
                'title': title,
              },
              'notification': <String, dynamic>{
                'title': title,
                'body': body,
                'android_channel_id': 'ChatApp'
              },
              'to': t,
            },
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        log('error push notification');
      }
    }
  }

/*
  void sendNotificationToAll(String title, String body) async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    try {
      await _firebaseMessaging.subscribeToTopic('all');

      await _firebaseMessaging.send(
        RemoteMessage(
          data: {
            'title': title,
            'body': body,
          },
          notification: Notification(
            title: title,
            body: body,
          ),
        ),
      );
    } catch (e) {
      print('Error sending notification: $e');
    }
  }*/
}
