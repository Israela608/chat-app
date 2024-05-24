import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? id;
  String? sender;
  Timestamp? time;
  String? message;
  File? photo;
  //final File? document;

  Message({
    this.id,
    this.sender,
    this.time,
    this.message,
    this.photo,
  });
}
