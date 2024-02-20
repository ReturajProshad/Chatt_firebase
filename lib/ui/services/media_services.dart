import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class mediaServices {
  static mediaServices instance = mediaServices();

  Future<XFile?> getImageFromFile() {
    return ImagePicker().pickImage(source: ImageSource.gallery);
  }
}
