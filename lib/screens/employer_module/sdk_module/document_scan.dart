// // ignore_for_file: use_build_context_synchronously

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_document_scanner/flutter_document_scanner.dart';
// // import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:onboarding_app/constants/api_info/common_api_struture.dart';
// import 'package:onboarding_app/functions/debug_print.dart';

// class DocumentScannerPage extends StatefulWidget {
//   @override
//   _DocumentScannerPageState createState() => _DocumentScannerPageState();
// }

// class _DocumentScannerPageState extends State<DocumentScannerPage> {
//   late CameraController _cameraController;
//   // late TextRecognizer _textRecognizer;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize the camera
//     _initializeCamera();

//     // Initialize the text recognizer
//     // _textRecognizer = TextRecognizer();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;

//     _cameraController = CameraController(
//       firstCamera,
//       ResolutionPreset.medium,
//     );

//     await _cameraController.initialize();
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     // _textRecognizer.close();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_cameraController != null
//         ? !_cameraController.value.isInitialized
//         : true) {
//       return Container();
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Document Scanner'),
//       ),
//       body: Stack(
//         children: [
//           CameraPreview(_cameraController),
//           Center(
//             child: Text(
//               'Place document within the frame',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _scanDocument,
//         child: Icon(Icons.camera),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   void _scanDocument() async {
//     if (!_cameraController.value.isTakingPicture) {
//       try {
//         XFile image = await _cameraController.takePicture();

//         printDebug(
//             textString:
//                 "========My Image...........${base64Encode(await image.readAsBytes())}");

//         await ApiManager.requestApi(
//             apiMethod: APIMethod.POST,
//             context: context,
//             serviceLabel: "Fetch Data....",
//             endPoint:
//                 "https://sandbox.veri5digital.com/video-id-kyc/api/1.0/docInfoExtract",
//             isQueryParameter: false,
//             dataParameter: {
//               //  {
//               //       "client_code": "CNER6217",
//               //       "sub_client_code": "CNER6217",
//               //       "actor_type": "Self",
//               //       "channel_code": "ANDROID_SDK",
//               //       "stan": randomKey,
//               //       "user_handle_type": "Mobile",
//               //       "user_handle_value": "1234567890",
//               //       "location": "1.1,1.1",
//               //       "transmission_datetime": transmission_datetime,
//               //       "run_mode": "REAL",
//               //       "client_ip": "192.168.1.1",
//               //       "operation_mode": "SELF",
//               //       "channel_version": "4.1.1",
//               //       "function_code": "REVISED",
//               //       "function_sub_code": "DEFAULT"
//               //   }
//               "headers": {
//                 "client_code": "CNER6217",
//                 "sub_client_code": "CNER6217",
//                 "actor_type": "Self",
//                 "channel_code": "ANDROID_SDK",
//                 "stan": "sdfasdad",
//                 "user_handle_type": "Mobile",
//                 "user_handle_value": "1234567890",
//                 "location": "1.1,1.1",
//                 "transmission_datetime": DateTime.now().toString(),
//                 "run_mode": "REAL",
//                 "client_ip": "192.168.1.1",
//                 "operation_mode": "SELF",
//                 "channel_version": "4.1.1",
//                 "function_code": "REVISED",
//                 "function_sub_code": "DEFAULT"
//               },
//               "request": {
//                 "api_key": "CRb3PL08",
//                 "request_id": "asdasdasdasd",
//                 "purpose": "testing in Khosla",
//                 "hash":
//                     "b9bbb3e188faae7190a41be8f35fd85ed0f49a093cb8f9ff916f29b1a9fe0749",
//                 "document_type": "AADHAAR",
//                 "document_side": "FRONT",
//                 "extraction_type": "FRONT",
//                 "document_front_image": base64Encode(await image.readAsBytes()),
//                 "document_back_image": ""
//               }
//             });

//         // // Process the captured image with text recognition
//         // final FirebaseVisionImage visionImage =
//         //     FirebaseVisionImage.fromFile(File(image.path));
//         // final VisionText visionText =
//         //     await _textRecognizer.processImage(visionImage);

//         // TODO: Handle the recognized text as needed
//         printDebug(textString: image.path);
//       } catch (e) {
//         printDebug(textString: 'Error: $e');
//       }
//     }
//   }
// }


// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_document_scanner/flutter_document_scanner.dart';

// // class ScanMyDocument extends StatefulWidget {
// //   const ScanMyDocument({super.key});

// //   @override
// //   State<ScanMyDocument> createState() => _ScanMyDocumentState();
// // }

// // class _ScanMyDocumentState extends State<ScanMyDocument>
// //     with SingleTickerProviderStateMixin {
// //   final _controller = DocumentScannerController();

// //   @override
// //   void initState() {
// //     super.initState();
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return DocumentScanner(
// //       controller: _controller,
// //       generalStyles: const GeneralStyles(
// //         hideDefaultBottomNavigation: true,
// //         messageTakingPicture: 'Taking picture of document',
// //         messageCroppingPicture: 'Cropping picture of document',
// //         messageEditingPicture: 'Editing picture of document',
// //         messageSavingPicture: 'Saving picture of document',
// //         baseColor: Colors.teal,
// //       ),
// //       takePhotoDocumentStyle: TakePhotoDocumentStyle(
// //         top: MediaQuery.of(context).padding.top + 25,
// //         hideDefaultButtonTakePicture: true,
// //         onLoading: const CircularProgressIndicator(
// //           color: Colors.white,
// //         ),
// //         children: [
// //           // * AppBar
// //           Positioned(
// //             top: 0,
// //             left: 0,
// //             right: 0,
// //             child: Container(
// //               color: Colors.teal,
// //               padding: EdgeInsets.only(
// //                 top: MediaQuery.of(context).padding.top + 10,
// //                 bottom: 15,
// //               ),
// //               child: const Center(
// //                 child: Text(
// //                   'Take a picture of the document',
// //                   style: TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 20,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),

// //           // * Button to take picture
// //           Positioned(
// //             bottom: MediaQuery.of(context).padding.bottom + 10,
// //             left: 0,
// //             right: 0,
// //             child: Center(
// //               child: ElevatedButton(
// //                 onPressed: _controller.takePhoto,
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.teal,
// //                 ),
// //                 child: const Text(
// //                   'Take picture',
// //                   style: TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 20,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //       cropPhotoDocumentStyle: CropPhotoDocumentStyle(
// //         top: MediaQuery.of(context).padding.top,
// //         maskColor: Colors.teal.withOpacity(0.2),
// //       ),
// //       editPhotoDocumentStyle: EditPhotoDocumentStyle(
// //         top: MediaQuery.of(context).padding.top,
// //       ),
// //       resolutionCamera: ResolutionPreset.ultraHigh,
// //       pageTransitionBuilder: (child, animation) {
// //         final tween = Tween<double>(begin: 0, end: 1);

// //         final curvedAnimation = CurvedAnimation(
// //           parent: animation,
// //           curve: Curves.easeOutCubic,
// //         );

// //         return ScaleTransition(
// //           scale: tween.animate(curvedAnimation),
// //           child: child,
// //         );
// //       },
// //       onSave: (Uint8List imageBytes) {
// //         printDebug(textString:"============My image bytes: $imageBytes");
// //       },
// //     );
// //   }
// // }
