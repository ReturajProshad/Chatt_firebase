import 'package:chatt/ui/pages/conversation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

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

class conversationMessage {
  final String id;
  final List<String> members;
  final List<message> messages;
  final String OwnerId;
  conversationMessage(
      {required this.id,
      required this.members,
      required this.OwnerId,
      required this.messages});
  // factory conversationMessage.fromFirestore(DocumentSnapshot snapshot) {
  //   var data = snapshot.data()  as Map<String, dynamic>;
  //   List _messageList=data["messages"];
  //   // if(_messageList!=null)
  //   // {
  //   //   _messageList=_messageList.map((_m){
  //   //     var _messageType=_m["type"]=="text" ? messageType.text :messageType.media;
  //   //     return message(_message:_m["message"], _senderId:_m["senderId"], _timestamp, _type)
  //   //   }).toList();
  //   // }
  //   return conversationMessage(id:snapshot.id, members:data["members"], OwnerId:data["owner"], messages:_messageList,)
  // }
}
