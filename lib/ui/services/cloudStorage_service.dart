import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  static CloudStorageService instance = CloudStorageService();
  FirebaseStorage? _storage;
  Reference? _baseRef;
  String _profileImages = "Profile_images";

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
}
