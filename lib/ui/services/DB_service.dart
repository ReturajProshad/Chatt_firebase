import 'package:cloud_firestore/cloud_firestore.dart';

class dbService {
  static dbService instance = dbService();

  FirebaseFirestore? _db;
  dbService() {
    _db = FirebaseFirestore.instance;
  }
  String userCollection = "Users";
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
}
