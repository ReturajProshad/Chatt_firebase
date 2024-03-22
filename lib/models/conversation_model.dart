import 'package:cloud_firestore/cloud_firestore.dart';

class Conversations {
  final String id;
  final String conversationID;
  final String image;
  final String lastmessage;
  final String name;
  final Timestamp timestamp;
  final int unseenCount;
  Conversations({
    required this.id,
    required this.conversationID,
    required this.image,
    required this.lastmessage,
    required this.name,
    required this.timestamp,
    required this.unseenCount,
  });
  factory Conversations.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data() as Map<String, dynamic>;
    return Conversations(
        id: _snapshot.id,
        conversationID: _data["conversationID"],
        image: _data["image"],
        lastmessage: _data["lastmessage"],
        name: _data["name"],
        timestamp: _data["timestamp"],
        unseenCount: _data["unseenCount"]);
  }
}
