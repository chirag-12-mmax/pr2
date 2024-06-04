// ignore_for_file: use_build_context_synchronously

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/rich_text_widget.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class EVideoSignaturePadScreen extends StatefulWidget {
  const EVideoSignaturePadScreen({
    super.key,
  });

  @override
  State<EVideoSignaturePadScreen> createState() =>
      _EVideoSignaturePadScreenState();
}

class _EVideoSignaturePadScreenState extends State<EVideoSignaturePadScreen> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  dynamic signatureData;

  void handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
    signatureData = null;
  }

  Future<void> handleSaveButtonPressed() async {
    if (signatureGlobalKey.currentState!.toPathList().isNotEmpty) {
      final data =
          await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);

      signatureData = await data.toByteData(
        format: ui.ImageByteFormat.png,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setInitialData();
    super.initState();
  }

  void setInitialData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.acceptanceDetailsData != null) {
      if (authProvider.acceptanceDetailsData!.acceptanceDetails!.isSignature ??
          false) {
        signatureData =
            authProvider.acceptanceDetailsData!.acceptanceDetails!.signatureURL;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer2(
      builder:
          (context, GeneralHelper helper, AuthProvider authProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PickHeightAndWidth.height20,
            RichTextWidget(
              mainTitle:
                  "${helper.translateTextTitle(titleText: "E-Sign into the below panel for Acceptance the")} ${authProvider.candidateCurrentStage == CandidateStages.OFFER_ACCEPTANCE ? "${helper.translateTextTitle(titleText: "Offer")}" : "${helper.translateTextTitle(titleText: "Appointment")}"}. ${helper.translateTextTitle(titleText: "Tap")} ",
              subTitle: "${helper.translateTextTitle(titleText: "Preview")} ",
              subTitle2:
                  "${helper.translateTextTitle(titleText: "to Verify and")} ",
              subTitle3: "${helper.translateTextTitle(titleText: "Clear")} ",
              subTitle4:
                  "${helper.translateTextTitle(titleText: "to E-Sign again & Proceed")} ",
              subTitle2Style: CommonTextStyle()
                  .noteHeadingTextStyle
                  .copyWith(color: PickColors.hintColor, fontSize: 13),
              mainTitleStyle: CommonTextStyle()
                  .noteHeadingTextStyle
                  .copyWith(color: PickColors.hintColor, fontSize: 13),
              subTitleStyle: CommonTextStyle().noteHeadingTextStyle.copyWith(
                    color: PickColors.primaryColor,
                    fontSize: 13,
                  ),
            ),
            PickHeightAndWidth.height20,
            if (signatureData == null ||
                (signatureData.runtimeType.toString() != "String"))
              Text(
                helper.translateTextTitle(titleText: "E-Signature Pad") ?? "-",
                style: CommonTextStyle()
                    .mainHeadingTextStyle
                    .copyWith(fontSize: 16),
              ),
            if (signatureData == null ||
                (signatureData.runtimeType.toString() != "String"))
              PickHeightAndWidth.height10,
            if (signatureData == null ||
                (signatureData.runtimeType.toString() != "String"))
              SizedBox(
                  height: SizeConfig.screenHeight! / 4.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SfSignaturePad(
                        key: signatureGlobalKey,
                        backgroundColor: Colors.white,
                        strokeColor: Colors.black,
                        minimumStrokeWidth: 1.0,
                        maximumStrokeWidth: 4.0),
                  )),
            if (signatureData == null ||
                (signatureData.runtimeType.toString() != "String"))
              PickHeightAndWidth.height20,
            if (signatureData == null ||
                (signatureData.runtimeType.toString() != "String"))
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: checkPlatForm(context: context, platforms: [
                    CustomPlatForm.MIN_LAPTOP_VIEW,
                    CustomPlatForm.LARGE_LAPTOP_VIEW,
                  ])
                      ? 100
                      : checkPlatForm(context: context, platforms: [
                          CustomPlatForm.MOBILE_VIEW,
                          CustomPlatForm.TABLET_VIEW,
                          CustomPlatForm.MOBILE,
                          CustomPlatForm.TABLET,
                          CustomPlatForm.MIN_MOBILE_VIEW,
                          CustomPlatForm.MIN_MOBILE,
                        ])
                          ? 0.0
                          : 350,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CommonMaterialButton(
                        style: CommonTextStyle().buttonTextStyle.copyWith(
                              color: PickColors.primaryColor,
                            ),
                        borderColor: PickColors.primaryColor,
                        color: PickColors.whiteColor,
                        title: helper.translateTextTitle(titleText: "Clear") ??
                            "-",
                        onPressed: () async {
                          setState(() {
                            handleClearButtonPressed();
                          });
                        },
                      ),
                    ),
                    PickHeightAndWidth.width15,
                    Expanded(
                      child: CommonMaterialButton(
                        title:
                            helper.translateTextTitle(titleText: "Preview") ??
                                "-",
                        onPressed: () async {
                          await handleSaveButtonPressed();
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (signatureData != null) PickHeightAndWidth.height20,
            if (signatureData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    helper.translateTextTitle(titleText: "Preview") ?? "-",
                    style: CommonTextStyle()
                        .mainHeadingTextStyle
                        .copyWith(fontSize: 16),
                  ),
                  PickHeightAndWidth.height10,
                  Container(
                    height: SizeConfig.screenHeight! / 4.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: PickColors.whiteColor,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: signatureData.runtimeType.toString() == "String"
                          ? Image.network(signatureData)
                          : Image.memory(signatureData!.buffer.asUint8List()),
                    ),
                  ),
                ],
              ),
            if (signatureData != null)
              SizedBox(
                height: SizeConfig.screenWidth! * 0.05,
              ),
            if (signatureData != null)
              Center(
                child: Container(
                  constraints: const BoxConstraints(minWidth: 350),
                  width: SizeConfig.screenWidth! * 0.20,
                  child: CommonMaterialButton(
                    title: signatureData.runtimeType.toString() != "String"
                        ? helper.translateTextTitle(titleText: "Save & Next")
                        : helper.translateTextTitle(titleText: "Retake") ?? "-",
                    onPressed: () async {
                      if (signatureData.runtimeType.toString() != "String") {
                        showOverlayLoader(context);
                        if (await authProvider.submitSignatureApiFunction(
                            context: context,
                            type: authProvider.candidateCurrentStage ==
                                    CandidateStages.OFFER_ACCEPTANCE
                                ? "OfferLetter"
                                : "AppointmentLetter",
                            fieName:
                                "onboarding_doc_signature_${authProvider.currentUserAuthInfo!.obApplicantId.toString().toLowerCase()}_${DateTime.now().toUtc().millisecondsSinceEpoch.toString()}.png",
                            fileByteData:
                                signatureData!.buffer.asUint8List())) {
                          if (authProvider.uploadedSignatureData != null) {
                            setState(() {
                              signatureData = authProvider
                                  .uploadedSignatureData["blobPath"];
                            });
                            await authProvider.getAcceptanceDetailsApiFunction(
                                context: context,
                                time: DateTime.now()
                                    .toUtc()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                type: authProvider.candidateCurrentStage ==
                                        CandidateStages.OFFER_ACCEPTANCE
                                    ? "OfferLetter"
                                    : "AppointmentLetter");
                          }
                          hideOverlayLoader();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            authProvider.updateAcceptanceScreenIndex(
                                tabIndex: 1);
                          });
                        } else {
                          hideOverlayLoader();
                        }
                      } else {
                        await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return CommonConfirmationDialogBox(
                                cancelButtonTitle:
                                    helper.translateTextTitle(titleText: "No"),
                                buttonTitle:
                                    helper.translateTextTitle(titleText: "Yes"),
                                isCancel: true,
                                onPressButton: () {
                                  backToScreen(context: context);
                                  setState(() {
                                    signatureData = null;
                                  });
                                },
                                title: helper.translateTextTitle(
                                    titleText: "Confirmation"),
                                subTitle: helper.translateTextTitle(
                                    titleText:
                                        "Are you sure that you want to retake this signature ?"));
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
