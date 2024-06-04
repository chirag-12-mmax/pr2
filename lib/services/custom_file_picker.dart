import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/functions/debug_print.dart';

class CustomFilePicker {
  static Future<dynamic> getFile(BuildContext context,
      {required List<String> allowedExtensions,
      FileType? fileType,
      bool isAllowMultiple = false}) async {
    dynamic returnData;

    if (allowedExtensions.contains('jpg') ||
            allowedExtensions.contains('jpeg') ||
            allowedExtensions.contains('png')
        // ||
        // allowedExtensions.contains('heif') ||
        // allowedExtensions.contains('heic')
        ) {
      returnData = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Choose File Source",
                textAlign: TextAlign.center, style: TextStyle()),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PickColors.primaryColor, // background
                  ),
                  child: const Text(
                    "File",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop(await getFileFromFile(context,
                        allowedExtensions: allowedExtensions,
                        fileType: fileType,
                        isAllowMultiple: isAllowMultiple));
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PickColors.primaryColor, // background
                  ),
                  child: const Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Open Sans",
                    ),
                  ),
                  onPressed: () async {
                    List<File> tempFiles = [];
                    XFile? pickedFile;
                    if (isAllowMultiple) {
                      final pickedFile0 = await ImagePicker().pickMultiImage(
                          imageQuality: 25,
                          maxHeight: 500, // <- reduce the image size
                          maxWidth: 500);

                      pickedFile0.forEach((element) {
                        tempFiles.add(File(element.path));
                      });
                    } else {
                      pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 25,
                          maxHeight: 500, // <- reduce the image size
                          maxWidth: 500);
                    }
                    Navigator.of(context).pop(
                        isAllowMultiple ? tempFiles : File(pickedFile!.path));
                  },
                )
              ],
            ),
          );
        },
      );

      printDebug(textString: "\n\n\n\n\n\n\n My Results $returnData");
    } else {
      returnData = await getFileFromFile(context,
          allowedExtensions: allowedExtensions,
          fileType: fileType,
          isAllowMultiple: isAllowMultiple);
    }

    return returnData;
  }
}

dynamic getFileFromFile(BuildContext context,
    {required List<String> allowedExtensions,
    FileType? fileType,
    bool isAllowMultiple = false}) async {
  File? fileData;
  List<File> uploadedFiles = [];
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: fileType ?? FileType.custom,
      withReadStream: true,
      allowedExtensions: fileType == null ? allowedExtensions : null,
      allowMultiple: isAllowMultiple);

  if (result != null) {
    if (!isAllowMultiple) {
      if (allowedExtensions.isNotEmpty) {
        if (allowedExtensions
            .contains(result.files.single.path!.split(".").last)) {
          fileData = File(result.files.single.path!);
        } else {
          // showToast(message: Titles.fileFormatNotAllowed, isPositive: false);
          fileData = null;
        }
      } else {
        fileData = File(result.files.single.path!);
      }

      return fileData;
    } else {
      result.files.forEach((element) {
        if (allowedExtensions.isNotEmpty) {
          if (allowedExtensions.contains(element.path!.split(".").last)) {
            uploadedFiles.add(File(element.path!));
          } else {
            // showToast(message: Titles.fileFormatNotAllowed, isPositive: false);
          }
        } else {
          uploadedFiles.add(File(element.path!));
        }
      });
      return uploadedFiles;
    }
  }
}
