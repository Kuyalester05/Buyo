import 'package:image_picker/image_picker.dart';

class LeafImagePicker {
  LeafImagePicker({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  Future<XFile?> captureLeafImage() {
    return _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 90);
  }

  Future<XFile?> uploadLeafImage() {
    return _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
  }
}
