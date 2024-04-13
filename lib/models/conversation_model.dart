import 'package:chatt/ui/pages/conversation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class Conversations {
  final String id;
  final String conversationID;
  final String image;
  final String lastmessage;
  final String name;
  final String type;
  final Timestamp timestamp;
  final int unseenCount;
  Conversations(
      {required this.id,
      required this.conversationID,
      required this.image,
      required this.lastmessage,
      required this.name,
      required this.timestamp,
      required this.unseenCount,
      required this.type});
  factory Conversations.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data() as Map<String, dynamic>;
    String _type = _data["type"] == "text" ? "text" : "media";
    return Conversations(
        id: _snapshot.id,
        conversationID: _data["conversationID"],
        image: _data["image"],
        lastmessage: _data["lastmessage"],
        name: _data["name"],
        timestamp: _data["timestamp"],
        unseenCount: _data["unseenCount"],
        type: _type);
  }
}

class conversationMessage {
  final String id;
  final List<String> members;
  final List? messages;
  final String OwnerId;
  conversationMessage({
    required this.id,
    required this.members,
    required this.OwnerId,
    required this.messages,
  });
  factory conversationMessage.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    // Handling members array
    List<String> members = List<String>.from(data["members"]);

    // Handling messages array
    List<Map<String, dynamic>>? _messageList =
        List<Map<String, dynamic>>.from(data["messages"]);
    List<message>? messages;
    if (_messageList != null) {
      messages = _messageList.map((_m) {
        var _messageType =
            _m["type"] == "text" ? messageType.text : messageType.media;
        return message(
            content: _m["message"],
            senderId: _m["senderId"],
            timestamp: _m["timestamp"],
            type: _messageType);
      }).toList();
    }

    return conversationMessage(
      id: snapshot.id,
      members: members,
      OwnerId: data["owner"],
      messages: messages,
    );
  }
}
