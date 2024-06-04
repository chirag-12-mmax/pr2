// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/navigation/app_router.gr.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/convert_to_longlink.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  // Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanning = false;
  bool isAlreadyOpen = false;
  late Timer _timer;
  bool _isVisible = true;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        _isVisible = !_isVisible;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          formatsAllowed: [BarcodeFormat.qrcode],
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Text(
              "Place a barcode inside the scan area",
              style: CommonTextStyle()
                  .noteHeadingTextStyle
                  .copyWith(color: PickColors.whiteColor),
            ),
          ),
        ),
        if (isScanning)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Text(
                "Scanning...",
                style: CommonTextStyle()
                    .noteHeadingTextStyle
                    .copyWith(color: PickColors.whiteColor),
              ),
            ),
          ),
        InkWell(
          onTap: () async {
            await controller?.toggleFlash();
            setState(() {});
          },
          child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: PickColors.bgColor.withOpacity(0.5),
                      shape: BoxShape.circle),
                  child: FutureBuilder(
                      future: controller?.getFlashStatus(),
                      builder: (context, snapshot) {
                        return Icon(
                          !(snapshot.data ?? false)
                              ? Icons.flash_off_outlined
                              : Icons.flash_on_outlined,
                          size: 40,
                          color: PickColors.bgColor,
                        );
                      }),
                ),
              )),
        ),
        if (_isVisible)
          Align(
            alignment: Alignment.center,
            child: Container(width: scanArea, height: 1, color: Colors.red),
          ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      isScanning = true;
    });

    final helper = Provider.of<GeneralHelper>(context, listen: false);
    controller.scannedDataStream.listen((scanData) async {
      printDebug(
          textString:
              "====================Scan Data..===============${scanData.code}================");
      if (scanData.code != null) {
        setState(() {
          isScanning = false;
        });

        String? actualURL = await expandShortUrl(shortUrl: scanData.code!);
        if (actualURL != null) {
          controller.stopCamera();
          controller.dispose();

          String requisitionId =
              actualURL.split("/")[actualURL.split("/").length - 2];
          String subscriptionId =
              actualURL.split("/")[actualURL.split("/").length - 3];
          String resumeSource = actualURL.split("/").last;

          replaceNextScreen(
              context: context,
              pageRoute: JobDescriptionScreen(
                  requisitionId: requisitionId,
                  subscriptionId: subscriptionId,
                  resumeSource: resumeSource));
        } else {
          if (!isAlreadyOpen) {
            isAlreadyOpen = true;
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return CommonConfirmationDialogBox(
                  buttonTitle: helper!.translateTextTitle(titleText: "Retry"),
                  title: helper.translateTextTitle(titleText: "Alert"),
                  subTitle: helper.translateTextTitle(
                      titleText: "Something went wrong"),
                  onPressButton: () async {
                    backToScreen(context: context);
                    setState(() {
                      isScanning = true;
                      isAlreadyOpen = false;
                    });
                  },
                );
              },
            );
          }
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('no Permission'),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _timer.cancel();
    super.dispose();
  }
}
