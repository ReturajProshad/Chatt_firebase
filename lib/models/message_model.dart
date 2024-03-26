import 'package:cloud_firestore/cloud_firestore.dart';

enum messageType { text, media }

class message {
  final String _message;
  final String _senderId;
  final Timestamp _timestamp;
  final messageType _type;
  message(this._message, this._senderId, this._timestamp, this._type);
}
