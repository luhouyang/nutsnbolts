import 'package:cloud_firestore/cloud_firestore.dart';

class MessageEntity {
  String userName;
  String text;
  Timestamp createdAt;

  MessageEntity({required this.userName, required this.text, required this.createdAt});

  factory MessageEntity.fromMap(Map<String, dynamic> map) {
    return MessageEntity(userName: map["userName"], text: map["text"], createdAt: map["createdAt"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'text': text,
      'createdAt': createdAt,
    };
  }
}
