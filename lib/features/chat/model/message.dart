import 'dart:io';

class Message {
  String? id;
  String? sender;
  String? time;
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
