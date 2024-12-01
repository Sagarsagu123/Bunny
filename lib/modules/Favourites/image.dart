import 'dart:convert';
import 'dart:io';

class ImageConstants {
  static final ImageConstants constants = ImageConstants._();
  factory ImageConstants() => constants;
  ImageConstants._();
  dynamic convertToBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    return 'data:image/jpeg;base64,$base64Image';
  }
}
