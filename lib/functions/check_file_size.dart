import 'package:flutter/services.dart';

bool checkSizeValidation(
    {required int mbSize, required Uint8List sizeInBytes}) {
  // final file = uploadedFile;
  // int sizeInBytes = file.lengthSync();
  double sizeInMb = sizeInBytes.lengthInBytes / (1024 * 1024);
  if (sizeInMb > mbSize) {
    return false;
  } else {
    return true;
  }
}

double getFileSizeInMB({required int mbSize, required Uint8List sizeInBytes}) {
 
  double sizeInMb = sizeInBytes.lengthInBytes / (1024 * 1024);

  return sizeInMb;
}
