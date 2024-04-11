import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class CloudStorageService {
  static CloudStorageService instance = CloudStorageService();
  FirebaseStorage? _storage;
  Reference? _baseRef;
  String _profileImages = "Profile_images";
  String _messages = "messages";
  String _images = "images";
  CloudStorageService() {
    _storage = FirebaseStorage.instance;
    _baseRef = _storage!.ref();
  }

  Future<TaskSnapshot?> uploadUserImage(String _uId, File _image) async {
    try {
      // Get the file extension
      String fileExtension = _image.path.split('.').last;

      // Generate a unique filename for the image
      String filename = '$_uId.$fileExtension';

      // Upload the image to Firebase Storage
      return await _baseRef!
          .child(_profileImages)
          .child(filename)
          .putFile(_image);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<TaskSnapshot>? uploadMediaMessage(String uId, File _image) {
    var _timeStamp = DateTime.now();
    try {
      //String fileExtension = _image.path.split('.').last;
      String filename = basename(_image.path);
      filename += _timeStamp.toString();
      return _baseRef!
          .child(_messages)
          .child(uId)
          .child(_images)
          .child(filename)
          .putFile(_image);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
