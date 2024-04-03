import 'package:cloud_firestore/cloud_firestore.dart';

enum messageType { text, media }

class message {
  final String content;
  final String senderId;
  final Timestamp timestamp;
  final messageType type;
  message(
      {required this.content,
      required this.senderId,
      required this.timestamp,
      required this.type});
}
