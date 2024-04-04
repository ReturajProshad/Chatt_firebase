import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class IamActive {
  static IamActive instance = IamActive();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  //uId updated from gotohome function in auth provider
  late String userId;

  Future<void> updateLastSeen(String uId) async {
    await _db.collection("Users").doc(uId).update({
      "lastseen": DateTime.now().toUtc(),
    });
  }

  Timer? _timer;
  void startSendingData() {
    sendData();

    // Schedule last seen data every 5 minutes
    _timer = Timer.periodic(Duration(minutes: 5), (timer) {
      sendData();
    });
  }

  void stopSendingData() {
    _timer?.cancel();
  }

  Future<void> sendData() async {
    try {
      updateLastSeen(userId);
    } catch (e) {
      print('Error while sending data: $e');
    }
  }
}
