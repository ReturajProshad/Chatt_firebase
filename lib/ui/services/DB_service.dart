import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/contact_model.dart';
import '../../models/conversation_model.dart';

class dbService {
  static dbService instance = dbService();
  FirebaseFirestore? _db;
  dbService() {
    _db = FirebaseFirestore.instance;
  }
  String userCollection = "Users";
  String _convCollection = "Conversations";
  Future<void> createUser(
      String _uId, String _userName, String _image, String _uEmail) async {
    try {
      return await _db?.collection(userCollection).doc(_uId).set({
        "name": _userName,
        "email": _uEmail,
        "lastseen": DateTime.now().toUtc(),
        "image": _image
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<Contact> getuserdata(String _uId) {
    var ref = _db?.collection(userCollection).doc(_uId);
    return ref!.get().asStream().map((_snapshot) {
      return Contact.fromFirestore(_snapshot);
    });
  }

  Stream<List<Conversations>> getConversations(String uId) {
    var ref =
        _db?.collection(userCollection).doc(uId).collection(_convCollection);
    return ref!.snapshots().map((_snapshot) {
      return _snapshot.docs.map((_doc) {
        return Conversations.fromFirestore(_doc);
      }).toList(); // Return a list of mapped Conversations
    });
  }
}
