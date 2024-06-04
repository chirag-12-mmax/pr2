// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/check_file_size.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/rich_text_widget.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_providers/profile_provider.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_provider/qr_code_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:onboarding_app/widgets/form_builder_controls/file_upload_widget.dart';
import 'package:onboarding_app/widgets/form_builder_controls/image_picker_control.dart';
import 'package:onboarding_app/widgets/form_builder_controls/qr_code_image_dialog.dart';
import 'package:onboarding_app/widgets/form_builder_controls/qr_code_upload_image.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

// import 'dart:html' as html;

class ResumeDetailsScreen extends StatefulWidget {
  const ResumeDetailsScreen({super.key});

  @override
  State<ResumeDetailsScreen> createState() => _ResumeDetailsScreenState();
}

class _ResumeDetailsScreenState extends State<ResumeDetailsScreen> {
  final _resumeFormKey = GlobalKey<FormBuilderState>();
  bool isPDFLoad = false;

  bool isLoading = false;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  initializeData() async {
    setState(() {
      isLoading = true;
    });

    final qrCodeProvider = Provider.of<QRCodeProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    await profileProvider.getCommonMasterProvider(
        context: context,
        subscriptionName: qrCodeProvider.qrCodeSubscription ?? "",
        time: DateTime.now().toUtc().millisecondsSinceEpoch.toString());

    await profileProvider.getCustomMasterProvider(
        context: context,
        role: "OB QRCode",
        subscriptionName: qrCodeProvider.qrCodeSubscription ?? "",
        time: DateTime.now().toUtc().millisecondsSinceEpoch.toString());

    if ((qrCodeProvider.qrObApplicantID ?? "") != "" ||
        (qrCodeProvider.previousObApplicantId ?? "") != "") {
      await qrCodeProvider.getCandidateUploadedResumeDetailApiFunction(
          context: context,
          dataParameter: {
            "SubscriptionName": qrCodeProvider.qrCodeSubscription,
            "ObApplicantId": (qrCodeProvider.qrObApplicantID ?? "") != ""
                ? qrCodeProvider.qrObApplicantID
                : (qrCodeProvider.previousObApplicantId ?? "") != ""
                    ? qrCodeProvider.previousObApplicantId
                    : null
          });
      if (qrCodeProvider.uploadedResumeDetailed != null) {
        qrCodeProvider.candidateProfileImageURl =
            qrCodeProvider.uploadedResumeDetailed["candidatePhotoUrl"];
        qrCodeProvider.candidateImageResume =
            qrCodeProvider.uploadedResumeDetailed["candidateResumeUrl"];
        qrCodeProvider.candidateImageResumeName =
            qrCodeProvider.uploadedResumeDetailed["candidateResume"];
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer3(builder: (BuildContext context,
        QRCodeProvider qrCodeProvider,
        ProfileProvider profileProvider,
        GeneralHelper helper,
        snapshot) {
      return FormBuilder(
        key: _resumeFormKey,
        initialValue: {
          "candidatePhoto":
              ((qrCodeProvider.candidateProfileImageURl ?? "") != "")
                  ? [XFile(qrCodeProvider.candidateProfileImageURl!)]
                  : [], //
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: PickColors.whiteColor,
                    ),
                    child: Column(
                      children: [
                        RichTextWidget(
                          mainTitle: helper.translateTextTitle(
                              titleText: "Upload your Photo"),
                          subTitle: "*",
                          mainTitleStyle: CommonTextStyle()
                              .subMainHeadingTextStyle
                              .copyWith(
                                fontFamily: "Cera Pro",
                              ),
                          subTitleStyle:
                              CommonTextStyle().buttonTextStyle.copyWith(
                                    fontFamily: "Cera Pro",
                                    color: PickColors.primaryColor,
                                  ),
                        ),
                        PickHeightAndWidth.height10,
                        ImagePickerControl(
                          isRequired: true,
                          isEnabled: true,
                          fieldName: "candidatePhoto",
                          onFileChange: ((value) async {
                            printDebug(
                                textString: "=================Value: ${value}");
                            if ((value ?? []).isNotEmpty) {
                              if (checkSizeValidation(
                                mbSize: 10,
                                sizeInBytes: await value.last.readAsBytes()!,
                              )) {
                                if ([
                                  "png", "jpg", "jpeg",

                                  // "heic", "heif"
                                ].contains(value.last.name
                                    .toString()
                                    .split(".")
                                    .last
                                    .toLowerCase())) {
                                  showOverlayLoader(context);
                                  try {
                                    if (await profileProvider
                                        .uploadCandidateFileForWalkInFunction(
                                            uploadType: "CandidatePhoto",
                                            subscriptionId: qrCodeProvider
                                                    .qrCodeSubscription ??
                                                "",
                                            fileByteData:
                                                await value.last.readAsBytes(),
                                            fieName: value.last.name,
                                            context: context)) {
                                      hideOverlayLoader();
                                      if (profileProvider
                                              .uploadedFileDataForWalkIn !=
                                          null) {
                                        qrCodeProvider
                                                .candidateProfileImageName =
                                            profileProvider
                                                    .uploadedFileDataForWalkIn[
                                                "fileName"];
                                        qrCodeProvider
                                                .candidateProfileImageURl =
                                            profileProvider
                                                    .uploadedFileDataForWalkIn[
                                                "blobPath"];
                                      }
                                    } else {
                                      hideOverlayLoader();
                                    }
                                  } catch (e) {
                                    hideOverlayLoader();
                                    printDebug(
                                        textString:
                                            "===================Profile Image Error: ${e}");
                                  }
                                } else {
                                  _resumeFormKey.currentState!
                                      .patchValue({"candidatePhoto": []});
                                  await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return CommonConfirmationDialogBox(
                                        buttonTitle: helper.translateTextTitle(
                                            titleText: "Okay"),
                                        title: helper.translateTextTitle(
                                            titleText: "Alert"),
                                        subTitle: helper.translateTextTitle(
                                            titleText: "Invalid File Type"),
                                        onPressButton: () async {
                                          backToScreen(context: context);
                                        },
                                      );
                                    },
                                  );
                                }
                              } else {
                                _resumeFormKey.currentState!
                                    .patchValue({"candidatePhoto": []});
                                await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return CommonConfirmationDialogBox(
                                      buttonTitle: helper.translateTextTitle(
                                          titleText: "Okay"),
                                      title: helper.translateTextTitle(
                                          titleText: "Alert"),
                                      subTitle: helper.translateTextTitle(
                                          titleText:
                                              "Image size not more then 10 MB"),
                                      onPressButton: () async {
                                        backToScreen(context: context);
                                      },
                                    );
                                  },
                                );
                              }
                            } else {
                              setState(() {
                                qrCodeProvider.candidateProfileImageName = null;
                                qrCodeProvider.candidateProfileImageURl = null;
                              });
                            }
                          }),
                        ),
                        PickHeightAndWidth.height10,
                        Text(
                          helper.translateTextTitle(
                                  titleText:
                                      '(Max 5MB, File type: .png, .jpg, .jpeg)') ??
                              "-",
                          style: CommonTextStyle().noteHeadingTextStyle,
                        ),
                      ],
                    ),
                  ),
                  PickHeightAndWidth.height40,
                  Container(
                    width: SizeConfig.screenWidth,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: PickColors.whiteColor,
                    ),
                    child: Column(
                      children: [
                        RichTextWidget(
                          mainTitle: helper.translateTextTitle(
                              titleText: 'Upload your Resume'),
                          subTitle: "*",
                          mainTitleStyle: CommonTextStyle()
                              .subMainHeadingTextStyle
                              .copyWith(
                                fontFamily: "Cera Pro",
                              ),
                          subTitleStyle:
                              CommonTextStyle().buttonTextStyle.copyWith(
                                    fontFamily: "Cera Pro",
                                    color: PickColors.primaryColor,
                                  ),
                        ),
                        PickHeightAndWidth.height20,
                        Text(
                          helper.translateTextTitle(
                              titleText:
                                  "(Max 10MB, File type: .pdf, .docx, .png, .jpg, .jpeg)"),
                          style: CommonTextStyle().noteHeadingTextStyle,
                        ),
                        PickHeightAndWidth.height40,
                        if (qrCodeProvider.candidateImageResume != null)
                          Container(
                            constraints: const BoxConstraints(minWidth: 350),
                            width: SizeConfig.screenWidth! * 0.45,
                            child: UploadedFilePreviewWidget(
                              uploadedFiles: [
                                qrCodeProvider.candidateImageResume
                              ],
                              currentSectionId: null,
                              onTapDelete: [
                                () {
                                  setState(() {
                                    qrCodeProvider.candidateImageResume = null;
                                    qrCodeProvider.candidateImageResumeName =
                                        null;
                                  });
                                }
                              ],
                              fieldConfig: null,
                            ),
                          ),
                        PickHeightAndWidth.height40,
                        if (qrCodeProvider.candidateImageResume == null)
                          Container(
                            constraints: const BoxConstraints(minWidth: 350),
                            width: SizeConfig.screenWidth! * 0.45,
                            // color: Colors.black,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: checkPlatForm(
                                          context: context,
                                          platforms: [
                                        CustomPlatForm.TABLET,
                                        CustomPlatForm.TABLET_VIEW,
                                        CustomPlatForm.MOBILE,
                                        CustomPlatForm.MOBILE_VIEW,
                                        CustomPlatForm.MIN_MOBILE_VIEW,
                                        CustomPlatForm.MIN_MOBILE,
                                      ])
                                      ? 2
                                      : 1,
                                  child: QrCodeUploadImageWidget(
                                    fieldName: 'candidateResume',
                                    isEnabled: true,
                                    isRequired: true,
                                    icon: PickImages.addFileIcon,
                                    onChanged: (value) async {
                                      if ((value ?? []).isNotEmpty) {
                                        if (checkSizeValidation(
                                          mbSize: 10,
                                          sizeInBytes: value!.last.bytes!,
                                        )) {
                                          if (["pdf", "docx", "doc"].contains(
                                              value.last.name
                                                  .toString()
                                                  .split(".")
                                                  .last)) {
                                            showOverlayLoader(context);

                                            if (await qrCodeProvider
                                                .getBasicDetailFromParsingResumeFunction(
                                                    fileByteData:
                                                        value.last.bytes!,
                                                    fieName: value.last.name,
                                                    profileProvider:
                                                        profileProvider,
                                                    subscriptionName: qrCodeProvider
                                                            .qrCodeSubscription ??
                                                        "",
                                                    context: context)) {
                                              hideOverlayLoader();
                                              if (qrCodeProvider
                                                      .parsedResumeData !=
                                                  null) {
                                                setState(() {
                                                  qrCodeProvider
                                                          .candidateImageResume =
                                                      qrCodeProvider
                                                              .parsedResumeData[
                                                          "blobPath"];
                                                  qrCodeProvider
                                                          .candidateImageResumeName =
                                                      qrCodeProvider
                                                              .parsedResumeData[
                                                          "fileName"];
                                                });
                                              }
                                            } else {
                                              hideOverlayLoader();
                                            }
                                          } else {
                                            _resumeFormKey.currentState!
                                                .patchValue(
                                                    {"candidateResume": null});
                                            await showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return CommonConfirmationDialogBox(
                                                  buttonTitle:
                                                      helper.translateTextTitle(
                                                          titleText: "Okay"),
                                                  title:
                                                      helper.translateTextTitle(
                                                          titleText: "Alert"),
                                                  subTitle: [
                                                    "png",
                                                    "jpg",
                                                    "jpeg",
                                                    // "heic",
                                                    // "heif"
                                                  ].contains(value.last.name
                                                          .toString()
                                                          .split(".")
                                                          .last
                                                          .toLowerCase())
                                                      ? helper.translateTextTitle(
                                                          titleText:
                                                              "Please upload a valid file like pdf, doc and docx, if you like to add resume using images choose Add Image option")
                                                      : helper.translateTextTitle(
                                                          titleText:
                                                              "Invalid File Type"),
                                                  onPressButton: () async {
                                                    backToScreen(
                                                        context: context);
                                                  },
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          _resumeFormKey.currentState!
                                              .patchValue(
                                                  {"candidateResume": null});
                                          await showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return CommonConfirmationDialogBox(
                                                buttonTitle:
                                                    helper.translateTextTitle(
                                                        titleText: "Okay"),
                                                title:
                                                    helper.translateTextTitle(
                                                        titleText: "Alert"),
                                                subTitle: helper.translateTextTitle(
                                                    titleText:
                                                        "Resume size not more then 10 MB"),
                                                onPressButton: () async {
                                                  backToScreen(
                                                      context: context);
                                                },
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
                                    title: helper.translateTextTitle(
                                        titleText: "Add File"),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    helper.translateTextTitle(titleText: "OR"),
                                    textAlign: TextAlign.center,
                                    style: CommonTextStyle()
                                        .textFieldLabelTextStyle
                                        .copyWith(
                                          fontSize: 16,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  flex: checkPlatForm(
                                          context: context,
                                          platforms: [
                                        CustomPlatForm.TABLET,
                                        CustomPlatForm.TABLET_VIEW,
                                        CustomPlatForm.MOBILE,
                                        CustomPlatForm.MOBILE_VIEW,
                                        CustomPlatForm.MIN_MOBILE_VIEW,
                                        CustomPlatForm.MIN_MOBILE,
                                      ])
                                      ? 2
                                      : 1,
                                  child: InkWell(
                                    onTap: () async {
                                      await showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return QRCodeMultiImageDialogWidget(
                                            buttonTitle:
                                                helper.translateTextTitle(
                                                    titleText: "Submit"),
                                            title: "Image Resume",
                                            subTitle: "Image Resume",
                                            onPressButton: (value) async {
                                              await convertImageListToPDF(
                                                      listOfImages: value,
                                                      context: context)
                                                  .then((value) async {
                                                showOverlayLoader(context);

                                                if (await qrCodeProvider
                                                    .getBasicDetailFromParsingResumeFunction(
                                                        fileByteData: value,
                                                        profileProvider:
                                                            profileProvider,
                                                        fieName:
                                                            "image_resume_uevmwmz_${DateTime.now().millisecond}.pdf",
                                                        subscriptionName:
                                                            qrCodeProvider
                                                                    .qrCodeSubscription ??
                                                                "",
                                                        context: context)) {
                                                  hideOverlayLoader();
                                                  if (qrCodeProvider
                                                          .parsedResumeData !=
                                                      null) {
                                                    backToScreen(
                                                        context: context);

                                                    setState(() {
                                                      qrCodeProvider
                                                              .candidateImageResume =
                                                          qrCodeProvider
                                                                  .parsedResumeData[
                                                              "blobPath"];
                                                      qrCodeProvider
                                                              .candidateImageResumeName =
                                                          qrCodeProvider
                                                                  .parsedResumeData[
                                                              "fileName"];
                                                    });
                                                  }
                                                } else {
                                                  hideOverlayLoader();
                                                }
                                              });
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: PickColors.bgColor,
                                      ),
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            PickImages.addImageIcon,
                                            height: 40,
                                            width: 40,
                                          ),
                                          PickHeightAndWidth.height15,
                                          Text(
                                            helper.translateTextTitle(
                                                    titleText: "Add image") ??
                                                "-",
                                            style: CommonTextStyle()
                                                .textFieldLabelTextStyle
                                                .copyWith(
                                                  fontSize: 16,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  PickHeightAndWidth.height40,
                  Container(
                    constraints: const BoxConstraints(minWidth: 350),
                    width: SizeConfig.screenWidth! * 0.20,
                    child: CommonMaterialButton(
                      title:
                          helper.translateTextTitle(titleText: "Submit") ?? "-",
                      onPressed: () async {
                        //                       String? candidateProfileImage;
                        // String? candidateImageResume;
                        // String? candidateImageResumeName;

                        if (qrCodeProvider.candidateProfileImageURl != null &&
                            qrCodeProvider.candidateImageResume != null &&
                            qrCodeProvider.candidateImageResumeName != null) {
                          qrCodeProvider.updateQrCodeScreenIndex(
                              context: context,
                              tabIndex:
                                  qrCodeProvider.qrCodeSelectedTabIndex + 1);
                        } else {
                          if (qrCodeProvider.candidateProfileImageURl == null) {
                            await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return CommonConfirmationDialogBox(
                                  buttonTitle: helper.translateTextTitle(
                                      titleText: "Okay"),
                                  title: helper.translateTextTitle(
                                      titleText: "Alert"),
                                  subTitle: helper.translateTextTitle(
                                      titleText:
                                          "Please upload your profile image"),
                                  onPressButton: () async {
                                    backToScreen(context: context);
                                  },
                                );
                              },
                            );
                          } else if (qrCodeProvider.candidateImageResume ==
                              null) {
                            await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return CommonConfirmationDialogBox(
                                  buttonTitle: helper.translateTextTitle(
                                      titleText: "Okay"),
                                  title: helper.translateTextTitle(
                                      titleText: "Alert"),
                                  subTitle: helper.translateTextTitle(
                                      titleText:
                                          "Please upload your resume and then submit."),
                                  onPressButton: () async {
                                    backToScreen(context: context);
                                  },
                                );
                              },
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
      );
    });
  }
}

Future<Uint8List> convertImageListToPDF(
    {required List<dynamic> listOfImages,
    required BuildContext context}) async {
  printDebug(textString: "=================Starting ================");

  final pdf = pw.Document();

  await Future.forEach(listOfImages, (image) async {
    final imageBytes = await image.readAsBytes();
    final imageWidget = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(imageWidget),
          );
        },
      ),
    );
  });
  Uint8List convertedPDF = await pdf.save();

  // printDebug(textString:"=================Ending ================");

  // final blob = html.Blob([convertedPDF]); // Convert to Blob
  // final url = html.Url.createObjectUrlFromBlob(blob);

  // final anchor = html.AnchorElement(href: url)
  //   ..target = '_blank'
  //   ..download = 'example.pdf' // Set desired file name
  //   ..click();

  // html.Url.revokeObjectUrl(url);
  // printDebug(textString:"=================${url}");
  return convertedPDF;
}
