import 'package:cloud_firestore/cloud_firestore.dart';

class MessageCreateService {
  static MessageCreateService instance = MessageCreateService();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<String> CheckConvIdAvailableorNot(List<String> members) async {
    try {
      if (members.isNotEmpty) {
        DocumentSnapshot conversationDoc = await _db
            .collection("Users")
            .doc(members[0])
            .collection("Conversations")
            .doc(members[1])
            .get();
        if (conversationDoc.exists) return conversationDoc["conversationID"];
        return "Null";
      }
    } catch (e) {
      print(e);
      return "Null";
    }
    return "Null";
  }

  Future<String> onConversationCreated(
      List<String> members, String typeOfMessage, String sms) async {
    try {
      if (members.isNotEmpty) {
        DocumentSnapshot conversationDoc = await _db
            .collection("Users")
            .doc(members[0])
            .collection("Conversations")
            .doc(members[1])
            .get();
        // Generate an auto-generated conversation ID
        //  if (!conversationDoc.exists)
        {
          DocumentReference conversationRef =
              _db.collection("Conversations").doc();
          String conversationID = conversationRef.id;

          cCollectionCreate(
              members[0], members[1], typeOfMessage, sms, conversationID);
          for (int i = 0; i < members.length; i++) {
            String currentUserID = members[i];
            List<String> remainingUserIDs =
                members.where((u) => u != currentUserID).toList();
            for (String m in remainingUserIDs) {
              DocumentSnapshot doc = await _db.collection("Users").doc(m).get();
              if (doc.exists) {
                Map<String, dynamic> userData =
                    doc.data() as Map<String, dynamic>;
                await _db
                    .collection("Users")
                    .doc(currentUserID)
                    .collection("Conversations")
                    .doc(m)
                    .set({
                  "conversationID": conversationID,
                  "image": userData["image"],
                  "name": userData["name"],
                  "unseenCount": 0,
                  "timestamp": DateTime.now().toUtc(),
                  "lastmessage": sms
                });
              }
            }
          }
          return conversationID;
        }
      }
      return "Null";
    } catch (e) {
      print(e);
      return "Null";
    }
  }

  Future<void> cCollectionCreate(
    String ownerId,
    String receiverId,
    String messageType,
    String message,
    String cId /*,String _lastseen*/,
  ) async {
    try {
      Map<String, dynamic> data = {
        "members": [ownerId, receiverId],
        "messages": [
          {
            "message": message,
            "type": messageType,
            "timestamp": DateTime.now().toUtc(),
            "senderId": ownerId,
          }
        ],
        "owner": ownerId
      };

      await _db.collection("Conversations").doc(cId).set(data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> onMessageUpdate(String senderId, String reciverId,
      String messageType, String message) async {
    try {
      DocumentSnapshot conversationDoc = await _db
          .collection("Users")
          .doc(senderId)
          .collection("Conversations")
          .doc(reciverId)
          .get();

      if (conversationDoc.exists) {
        String conversationID = conversationDoc['conversationID'];
        // DocumentSnapshot ownerId =
        //     await _db.collection("Conversations").doc(conversationID).get();
        //print(conversationID);
        // Append the new message to the existing array of messages
        Map<String, dynamic> newMessage = {
          "message": message,
          "senderId": senderId,
          "timestamp": DateTime.now().toUtc(),
          "type": messageType,
        };

        ///updating the value in conversation id
        await _db.collection("Conversations").doc(conversationID).update({
          // "members": [senderId, reciverId],
          "messages": FieldValue.arrayUnion([newMessage]),
          // "owner": ownerId["owner"]
        });

        ///updating the value in sender id
        await _db
            .collection("Users")
            .doc(senderId)
            .collection("Conversations")
            .doc(reciverId)
            .update({
          "lastmessage": message,
          "timestamp": DateTime.now().toUtc(),
          "type": messageType
        });

        ///updating the value in receiver id
        await _db
            .collection("Users")
            .doc(reciverId)
            .collection("Conversations")
            .doc(senderId)
            .update({
          "lastmessage": message,
          "timestamp": DateTime.now().toUtc(),
          "unseenCount": FieldValue.increment(1),
          "type": messageType
        });
      }
    } catch (e) {
      print("Error is: $e");
    }
  }
}
