import 'package:cloud_firestore/cloud_firestore.dart';

class MessageEntity {
  String userId;
  String userName;
  String text;
  Timestamp createdAt;

  MessageEntity({
    required this.userId,
    required this.userName,
    required this.text,
    required this.createdAt,
  });

  factory MessageEntity.fromMap(Map<String, dynamic> map) {
    return MessageEntity(
      userId: map["userId"],
      userName: map["userName"],
      text: map["text"],
      createdAt: map["createdAt"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'text': text,
      'createdAt': createdAt,
    };
  }
}
