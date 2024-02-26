import 'dart:io';
import 'package:image_picker/image_picker.dart';

class mediaServices {
  static mediaServices instance = mediaServices();

  Future<File?> getImageFromFile() async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      // Handle if the user didn't pick any image
      return null;
    }

    File imageFile = File(pickedImage.path);
    return imageFile;
  }
}
