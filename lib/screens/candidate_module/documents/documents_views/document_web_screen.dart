// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/share_pref_keys.dart';
import 'package:onboarding_app/constants/share_preference.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/check_file_size.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/launch_url.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/functions/toast_msg.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/rich_text_widget.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_providers/candidate_provider.dart';
import 'package:onboarding_app/screens/candidate_module/documents/documents_commons/documents_status_widget.dart';
import 'package:onboarding_app/screens/candidate_module/documents/documents_commons/instructions_dialog_box.dart';
import 'package:onboarding_app/screens/candidate_module/documents/documents_commons/remarks_dialog_box.dart';
import 'package:onboarding_app/screens/candidate_module/documents/documents_commons/slidable_widget.dart';
import 'package:onboarding_app/screens/candidate_module/documents/documents_commons/upload_file_preview_dialog_box.dart';
import 'package:onboarding_app/screens/employer_module/employer_provider/dashboard_provider.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_provider/qr_code_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';

@RoutePage()
class DocumentWebScreen extends StatefulWidget {
  const DocumentWebScreen({super.key});

  @override
  State<DocumentWebScreen> createState() => _DocumentWebScreenState();
}

class _DocumentWebScreenState extends State<DocumentWebScreen> {
  final ScrollController _controller = ScrollController();
  final FocusNode _focusNode = FocusNode();

  void _handleKeyEvent(RawKeyEvent event) {
    var offset = _controller.offset;
    // if (_controller.offset == _offset) {
    //   return;
    // }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _controller.animateTo(offset - 200,
            duration: Duration(milliseconds: 30), curve: Curves.ease);
      });
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _controller.animateTo(offset + 200,
            duration: Duration(milliseconds: 30), curve: Curves.ease);
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer2(builder: (BuildContext context, AuthProvider authProvider,
        EmployerDashboardProvider employerDashboardProvider, snapshot) {
      return Scaffold(
        backgroundColor: PickColors.bgColor,
        body: RawKeyboardListener(
          autofocus: true,
          onKey: _handleKeyEvent,
          focusNode: _focusNode,
          child: SingleChildScrollView(
            controller: _controller,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: DocumentsScreenWidget(
                obApplicantID: currentLoginUserType == loginUserTypes.first
                    ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                    : employerDashboardProvider.selectedObApplicantID ?? "",
              ),
            ),
          ),
        ),
      );
    });
  }
}

class DocumentsScreenWidget extends StatefulWidget {
  final String obApplicantID;
  final bool isFromQrCode;
  const DocumentsScreenWidget(
      {super.key, required this.obApplicantID, this.isFromQrCode = false});

  @override
  State<DocumentsScreenWidget> createState() => _DocumentsScreenWidgetState();
}

class _DocumentsScreenWidgetState extends State<DocumentsScreenWidget> {
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
    final candidateProvider =
        Provider.of<CandidateProvider>(context, listen: false);

    await candidateProvider.getCheckListInstructionApiFunction(
      context: context,
      obApplicantId: widget.obApplicantID,
    );
    await candidateProvider.getDocumentCheckListApiFunction(
        context: context,
        obApplicantId: widget.obApplicantID,
        time: DateTime.now().microsecondsSinceEpoch.toString());
    setState(() {
      isLoading = false;
    });
    if (candidateProvider.documentInstructionList.isNotEmpty) {
      bool alreadyAccepted =
          await Shared_Preferences.prefGetBool(SharedP.instructionFlag, false);

      if (!alreadyAccepted) {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const InstructionsDialogBox();
          },
        );
      }
    }
  }

  String getDocumentCount({required int documentIdex}) {
    final candidateProvider =
        Provider.of<CandidateProvider>(context, listen: false);
    switch (documentIdex) {
      case 0:
        return candidateProvider.documentCountData!.pendingCount.toString();
      case 1:
        return candidateProvider.documentCountData!.submittedCount.toString();
      case 2:
        return candidateProvider.documentCountData!.rejectedCount.toString();
      case 3:
        return candidateProvider.documentCountData!.verifiedCount.toString();
      default:
        return "0";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3(builder: (BuildContext context,
        GeneralHelper helper,
        AuthProvider authProvider,
        CandidateProvider candidateProvider,
        snapshot) {
      return isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // if (!widget.isFromQrCode) PickHeightAndWidth.height20,
                // if (!widget.isFromQrCode &&
                //     authProvider.applicantInformation != null)
                //   Text(
                //     "${helper.translateTextTitle(titleText: "Application is at")} ${authProvider.applicantInformation!.applicationStageStatus.toString()} Stage",
                //     style: CommonTextStyle().textFieldLabelTextStyle.copyWith(
                //           color: PickColors.blackColor,
                //           fontWeight: FontWeight.normal,
                //         ),
                //   ),
                PickHeightAndWidth.height20,
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: GlobalList.documentsStatusList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // childAspectRatio: 2.4,
                    mainAxisExtent: 80,
                    crossAxisCount: checkPlatForm(context: context, platforms: [
                      CustomPlatForm.TABLET_VIEW,
                      CustomPlatForm.TABLET,
                      CustomPlatForm.MOBILE,
                      CustomPlatForm.MOBILE_VIEW,
                      CustomPlatForm.MIN_MOBILE_VIEW,
                      CustomPlatForm.MIN_MOBILE,
                      CustomPlatForm.MIN_LAPTOP_VIEW,
                    ])
                        ? 2
                        : 4,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return DocumentsStatusWidget(
                      color: GlobalList.documentsStatusList[index]["color"],
                      count: getDocumentCount(documentIdex: index),
                      icon: GlobalList.documentsStatusList[index]["icon"],
                      title: GlobalList.documentsStatusList[index]["title"],
                      textColor: GlobalList.documentsStatusList[index]
                          ["textColor"],
                    );
                  },
                ),
                PickHeightAndWidth.height20,
                candidateProvider.totalDocumentList.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          color: PickColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              helper.translateTextTitle(
                                      titleText: "Documents") ??
                                  "-",
                              style: CommonTextStyle()
                                  .mainHeadingTextStyle
                                  .copyWith(
                                    fontSize: 20,
                                  ),
                            ),
                            PickHeightAndWidth.height15,
                            Divider(
                              color: PickColors.bgColor,
                              thickness: 1,
                            ),
                            if (candidateProvider
                                    .documentInstructionList.length !=
                                0)
                              PickHeightAndWidth.height15,
                            if (candidateProvider
                                    .documentInstructionList.length !=
                                0)
                              Text(
                                helper.translateTextTitle(
                                        titleText: "Supporting documents") ??
                                    "-",
                                style: CommonTextStyle()
                                    .mainHeadingTextStyle
                                    .copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                            if (candidateProvider
                                    .documentInstructionList.length !=
                                0)
                              PickHeightAndWidth.height15,
                            const DocumentInstructionWidget(),
                            PickHeightAndWidth.height20,
                            Text(
                              helper.translateTextTitle(
                                      titleText: "Instructions") ??
                                  "-",
                              style: CommonTextStyle()
                                  .textFieldLabelTextStyle
                                  .copyWith(
                                    color: PickColors.primaryColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                            PickHeightAndWidth.height20,
                            Text(
                              "• ${helper.translateTextTitle(titleText: "File size should be less than 10 MB.")}\n• ${helper.translateTextTitle(titleText: "The file types that you can upload are JPG, JPEG, PNG, DOC, DOCX, PDF  only.")}\n• ${helper.translateTextTitle(titleText: "The filename should not contain any special character")}",
                              style: CommonTextStyle()
                                  .textFieldLabelTextStyle
                                  .copyWith(
                                    color: PickColors.blackColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                            Wrap(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${helper.translateTextTitle(titleText: "• Documents uploaded against the")} ",
                                  style: CommonTextStyle()
                                      .textFieldLabelTextStyle
                                      .copyWith(
                                        color: PickColors.blackColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                                Icon(
                                  Icons.shield_outlined,
                                  color: PickColors.primaryColor,
                                ),
                                
                                Text(
                                  " ${helper.translateTextTitle(titleText: "symbol will be shared with third parties for background verification.")}",
                                  style: CommonTextStyle()
                                      .textFieldLabelTextStyle
                                      .copyWith(
                                        color: PickColors.blackColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ],
                            ),
                            Wrap(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${helper.translateTextTitle(titleText: "• Documents uploaded against the")} ",
                                  style: CommonTextStyle()
                                      .textFieldLabelTextStyle
                                      .copyWith(
                                        color: PickColors.blackColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                                Icon(
                                  Icons.file_download,
                                  color: PickColors.primaryColor,
                                ),
                                
                                Text(
                                  " ${helper.translateTextTitle(titleText: "symbol to view the instructions for the sample document")}",
                                  style: CommonTextStyle()
                                      .textFieldLabelTextStyle
                                      .copyWith(
                                        color: PickColors.blackColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ],
                            ),
                            RichTextWidget(
                              mainTitle: "• ",
                              subTitle: "* ",
                              subTitle2: helper.translateTextTitle(
                                  titleText: "Marked Documents are mandatory"),
                              mainTitleStyle: CommonTextStyle()
                                  .textFieldLabelTextStyle
                                  .copyWith(
                                    color: PickColors.blackColor,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Cera Pro",
                                  ),
                              subTitle2Style: CommonTextStyle()
                                  .textFieldLabelTextStyle
                                  .copyWith(
                                    color: PickColors.blackColor,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Cera Pro",
                                  ),
                              subTitleStyle: CommonTextStyle()
                                  .textFieldLabelTextStyle
                                  .copyWith(
                                    color: PickColors.primaryColor,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Cera Pro",
                                  ),
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: 20),
                              shrinkWrap: true,
                              itemCount: candidateProvider
                                  .documentCheckListDetailList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: SlidableWidget(
                                    documentData: candidateProvider
                                        .documentCheckListDetailList[index],
                                    helper: helper,
                                    isFromNoDocument: false,
                                    onTapAddButtonDisable: [
                                          CandidateStages.OFFER_VERIFICATION,
                                          CandidateStages
                                              .PRE_JOINING_VERIFICATION,
                                          CandidateStages.JOINING_CONFIRMATION,
                                          CandidateStages
                                              .POST_JOINING_VERIFICATION,
                                          CandidateStages.COMPLETION
                                        ].contains(authProvider
                                            .candidateCurrentStage) &&
                                        [
                                          "Submitted",
                                          "Verified"
                                        ].contains(candidateProvider
                                            .documentCheckListDetailList[index]
                                            .documentStatus),
                                    onTapDeleteDisable: ([
                                              CandidateStages
                                                  .OFFER_VERIFICATION,
                                              CandidateStages
                                                  .PRE_JOINING_VERIFICATION,
                                              CandidateStages
                                                  .JOINING_CONFIRMATION,
                                              CandidateStages
                                                  .POST_JOINING_VERIFICATION,
                                              CandidateStages.COMPLETION
                                            ].contains(authProvider
                                                .candidateCurrentStage) &&
                                            [
                                              "Submitted",
                                              "Verified"
                                            ].contains(candidateProvider
                                                .documentCheckListDetailList[
                                                    index]
                                                .documentStatus)) ||
                                        (candidateProvider
                                                        .documentCheckListDetailList[
                                                            index]
                                                        .uploadedDocumentCount ??
                                                    "0")
                                                .toString() ==
                                            "0",
                                    onTapReviewDisable: [
                                          CandidateStages.OFFER_VERIFICATION,
                                          CandidateStages
                                              .PRE_JOINING_VERIFICATION,
                                          CandidateStages.JOINING_CONFIRMATION,
                                          CandidateStages
                                              .POST_JOINING_VERIFICATION,
                                          CandidateStages.COMPLETION
                                        ].contains(authProvider
                                            .candidateCurrentStage) &&
                                        [
                                          "Submitted",
                                          "Verified"
                                        ].contains(candidateProvider
                                            .documentCheckListDetailList[index]
                                            .documentStatus),
                                    onTapViewButtonDisable: (candidateProvider
                                                    .documentCheckListDetailList[
                                                        index]
                                                    .uploadedDocumentCount ??
                                                "0")
                                            .toString() ==
                                        "0",
                                    onTapViewButton: () async {
                                      final candidateProvider =
                                          Provider.of<CandidateProvider>(
                                              context,
                                              listen: false);
                                      final authProvider =
                                          Provider.of<AuthProvider>(context,
                                              listen: false);
                                      if (candidateProvider
                                              .documentCheckListDetailList[
                                                  index]
                                              .fileName
                                              .toString()
                                              .split(",")
                                              .length >
                                          1) {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return UploadFilePreviewDialogBox(
                                              selectedIndex: index,
                                              obApplicantId:
                                                  widget.obApplicantID,
                                            );
                                          },
                                        );
                                      } else {
                                        showOverlayLoader(context);
                                        if (await candidateProvider
                                            .previewUploadedDocumentApiFunction(
                                                context: context,
                                                dataParameter: {
                                              "documentId": candidateProvider
                                                  .documentCheckListDetailList[
                                                      index]
                                                  .documentId
                                                  .toString(),
                                              "stageName": candidateProvider
                                                  .documentCheckListDetailList[
                                                      index]
                                                  .applicationStageStatus
                                                  .toString(),
                                              "fileName": candidateProvider
                                                  .documentCheckListDetailList[
                                                      index]
                                                  .fileName
                                                  .toString(),
                                              "ObApplicantId":
                                                  widget.obApplicantID,
                                              "_": DateTime.now()
                                                  .microsecondsSinceEpoch
                                                  .toString()
                                            })) {
                                          hideOverlayLoader();
                                          if (candidateProvider
                                                  .fileForPreview !=
                                              null) {}
                                          await launchUrlServiceFunction(
                                              url: candidateProvider
                                                      .fileForPreview[
                                                  "fileDownloadURL"],
                                              context: context);
                                        }
                                        hideOverlayLoader();
                                      }
                                    },
                                    onTapReview: () {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return RemarksDialogBox(
                                            obApplicantId: widget.obApplicantID,
                                            isDisable: [
                                                  CandidateStages
                                                      .OFFER_VERIFICATION,
                                                  CandidateStages
                                                      .PRE_JOINING_VERIFICATION,
                                                  CandidateStages
                                                      .JOINING_CONFIRMATION,
                                                  CandidateStages
                                                      .POST_JOINING_VERIFICATION,
                                                  CandidateStages.COMPLETION
                                                ].contains(authProvider
                                                    .candidateCurrentStage) &&
                                                [
                                                  "Submitted",
                                                  "Verified"
                                                ].contains(candidateProvider
                                                    .documentCheckListDetailList[
                                                        index]
                                                    .documentStatus),
                                            selectedDocumentData: candidateProvider
                                                    .documentCheckListDetailList[
                                                index],
                                          );
                                        },
                                      );
                                    },
                                    onTapDelete: () {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return CommonConfirmationDialogBox(
                                            cancelButtonTitle:
                                                helper.translateTextTitle(
                                                    titleText: "No"),
                                            isCancel: true,
                                            buttonTitle:
                                                helper.translateTextTitle(
                                                    titleText: "Yes"),
                                            title: helper.translateTextTitle(
                                                titleText: "Confirmation"),
                                            subTitle: helper.translateTextTitle(
                                                    titleText:
                                                        "Are you sure that you want to delete this document ?") ??
                                                "-",
                                            onPressButton: () async {
                                              showOverlayLoader(context);
                                              if (await candidateProvider
                                                  .deleteUploadedDocumentApiFunction(
                                                      context: context,
                                                      dataParameter: {
                                                    "documentId": candidateProvider
                                                        .documentCheckListDetailList[
                                                            index]
                                                        .documentId
                                                        .toString(),
                                                    "applicationStageId":
                                                        candidateProvider
                                                            .documentCheckListDetailList[
                                                                index]
                                                            .applicationStage
                                                            .toString(),
                                                    "documentName":
                                                        candidateProvider
                                                            .documentCheckListDetailList[
                                                                index]
                                                            .fileName
                                                            .toString(),
                                                    "ObApplicantId":
                                                        widget.obApplicantID,
                                                  })) {
                                                await candidateProvider
                                                    .getDocumentCheckListApiFunction(
                                                        context: context,
                                                        obApplicantId: widget
                                                            .obApplicantID,
                                                        time: DateTime.now()
                                                            .microsecondsSinceEpoch
                                                            .toString())
                                                    .whenComplete(() {
                                                  hideOverlayLoader();
                                                  backToScreen(
                                                      context: context);
                                                });
                                              } else {
                                                hideOverlayLoader();
                                              }
                                            },
                                          );
                                        },
                                      );
                                    },
                                    onTapAddButton: (value) async {
                                      if (value != null && value.isNotEmpty) {
                                        if (checkSizeValidation(
                                          mbSize: 10,
                                          sizeInBytes: value.last.bytes!,
                                        )) {
                                          if ([
                                            'png',
                                            "jpg",
                                            "jpeg",
                                            "doc",
                                            "docx",
                                            "pdf",
                                            // "heic",
                                            // "heif"
                                          ].contains(value.last.name
                                              .toString()
                                              .split(".")
                                              .last
                                              .toLowerCase())) {
                                            Loader.show(
                                              context,
                                              progressIndicator:
                                                  SpinKitPulsingGrid(
                                                color: PickColors.primaryColor,
                                              ),
                                            );
                                            if (await candidateProvider
                                                .uploadCheckListDocumentFunction(
                                                    documentId: candidateProvider
                                                        .documentCheckListDetailList[
                                                            index]
                                                        .documentId
                                                        .toString(),
                                                    documentCount: "0",
                                                    obApplicantId:
                                                        widget.obApplicantID,
                                                    remarkString: "",
                                                    documentStatus: "Submitted",
                                                    stageId: candidateProvider
                                                        .documentCheckListDetailList[
                                                            index]
                                                        .applicationStage
                                                        .toString(),
                                                    updatedBy:
                                                        widget.obApplicantID,
                                                    fieName:
                                                        "${candidateProvider.documentCheckListDetailList[index].documentName!.replaceAll(" ", "").toString().toLowerCase()}${DateTime.now().microsecondsSinceEpoch}.${value.last.name.toString().split("/").last.split(".").last}",
                                                    fileByteData:
                                                        value.last.bytes!,
                                                    context: context)) {
                                              await candidateProvider
                                                  .getDocumentCheckListApiFunction(
                                                      context: context,
                                                      obApplicantId:
                                                          widget.obApplicantID,
                                                      time: DateTime.now()
                                                          .microsecondsSinceEpoch
                                                          .toString());

                                              hideOverlayLoader();
                                            }
                                            hideOverlayLoader();
                                          } else {
                                            hideOverlayLoader();
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
                                                  subTitle:
                                                      helper.translateTextTitle(
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
                                          hideOverlayLoader();
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
                                                        "File size not more then 10 MB"),
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
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          PickHeightAndWidth.height40,
                          SvgPicture.asset(PickImages.oopsImage),
                          PickHeightAndWidth.height40,
                          Text(
                            helper.translateTextTitle(
                                    titleText:
                                        "Am sorry no documents has been configured as of now ,please contact HR") ??
                                "-",
                          ),
                        ],
                      ),
                PickHeightAndWidth.height30,
                if (candidateProvider.nonDocumentCheckListDetailList.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: PickColors.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          helper.translateTextTitle(
                                  titleText: "Non Documents") ??
                              "-",
                          style:
                              CommonTextStyle().mainHeadingTextStyle.copyWith(
                                    fontSize: 22,
                                  ),
                        ),
                        PickHeightAndWidth.height15,
                        Divider(
                          color: PickColors.bgColor,
                          thickness: 1,
                        ),
                        PickHeightAndWidth.height15,
                        Text(
                          helper.translateTextTitle(
                              titleText:
                                  "Uploading this non document will make it eligible for background verification."),
                          style: CommonTextStyle()
                              .textFieldLabelTextStyle
                              .copyWith(
                                color: PickColors.blackColor,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 20),
                          shrinkWrap: true,
                          itemCount: candidateProvider
                              .nonDocumentCheckListDetailList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: SlidableWidget(
                                documentData: candidateProvider
                                    .nonDocumentCheckListDetailList[index],
                                isFromNoDocument: true,
                                helper: helper,
                                onTapAddButtonDisable: false,
                                onTapDeleteDisable: false,
                                onTapReviewDisable: [
                                      CandidateStages.OFFER_VERIFICATION,
                                      CandidateStages.PRE_JOINING_VERIFICATION,
                                      CandidateStages.JOINING_CONFIRMATION,
                                      CandidateStages.POST_JOINING_VERIFICATION,
                                      CandidateStages.COMPLETION
                                    ].contains(
                                        authProvider.candidateCurrentStage) &&
                                    [
                                      "Submitted",
                                      "Verified"
                                    ].contains(candidateProvider
                                        .nonDocumentCheckListDetailList[index]
                                        .documentStatus),
                                onTapViewButtonDisable: false,
                                onTapReview: () async {
                                  await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return RemarksDialogBox(
                                        isDisable: [
                                              CandidateStages
                                                  .OFFER_VERIFICATION,
                                              CandidateStages
                                                  .PRE_JOINING_VERIFICATION,
                                              CandidateStages
                                                  .JOINING_CONFIRMATION,
                                              CandidateStages
                                                  .POST_JOINING_VERIFICATION,
                                              CandidateStages.COMPLETION
                                            ].contains(authProvider
                                                .candidateCurrentStage) &&
                                            [
                                              "Submitted",
                                              "Verified"
                                            ].contains(candidateProvider
                                                .nonDocumentCheckListDetailList[
                                                    index]
                                                .documentStatus),
                                        selectedDocumentData: candidateProvider
                                                .nonDocumentCheckListDetailList[
                                            index],
                                        obApplicantId: widget.obApplicantID,
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                PickHeightAndWidth.height30,
                Center(
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 350),
                    width: SizeConfig.screenWidth! * 0.20,
                    child: CommonMaterialButton(
                      title:
                          helper.translateTextTitle(titleText: "Submit") ?? "-",
                      isButtonDisable: currentLoginUserType == loginUserTypes[2]
                          ? false
                          : [
                              CandidateStages.OFFER_VERIFICATION,
                              CandidateStages.PRE_JOINING_VERIFICATION,
                              CandidateStages.JOINING_CONFIRMATION,
                              CandidateStages.APPOINTMENT_LETTER,
                              CandidateStages.POST_JOINING_VERIFICATION,
                              CandidateStages.COMPLETION
                            ].contains(authProvider.candidateCurrentStage),
                      onPressed: () async {
                        if (currentLoginUserType == loginUserTypes[2]
                            ? true
                            : (![
                                CandidateStages.OFFER_VERIFICATION,
                                CandidateStages.PRE_JOINING_VERIFICATION,
                                CandidateStages.JOINING_CONFIRMATION,
                                CandidateStages.APPOINTMENT_LETTER,
                                CandidateStages.POST_JOINING_VERIFICATION,
                                CandidateStages.COMPLETION
                              ].contains(authProvider.candidateCurrentStage))) {
                          bool isDocumentUploaded = true;

                          await Future.forEach(
                              candidateProvider.totalDocumentList, (element) {
                            if (element.isMandatory ?? false) {
                              if ((element.documentStatus ?? "Pending") ==
                                      "Pending" ||
                                  (element.documentStatus ?? "Pending") ==
                                      "Not Submitted") {
                                isDocumentUploaded = false;
                              }
                            }
                          });

                          if (isDocumentUploaded) {
                            if (!widget.isFromQrCode) {
                              showOverlayLoader(context);
                              if (await candidateProvider
                                  .saveCandidateUploadedDocumentDetailApiRoute(
                                      context: context,
                                      dataParameter: {
                                    "obApplicantId": widget.obApplicantID,
                                  })) {
                                if (currentLoginUserType ==
                                    loginUserTypes.first) {
                                  await authProvider
                                      .getApplicantInformationApiFunction(
                                          context: context,
                                          authToken: authProvider
                                                  .currentUserAuthInfo!
                                                  .authToken ??
                                              "",
                                          timestamp: DateTime.now()
                                              .toUtc()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                          helper: helper);
                                }

                                hideOverlayLoader();
                              } else {
                                hideOverlayLoader();
                              }
                            } else {
                              final qrProvider = Provider.of<QRCodeProvider>(
                                  context,
                                  listen: false);
                              qrProvider.updateQrCodeScreenIndex(
                                  context: context,
                                  tabIndex:
                                      qrProvider.qrCodeSelectedTabIndex + 1);
                            }
                          } else {
                            showToast(
                                message: helper.translateTextTitle(
                                        titleText:
                                            "Please upload mandatory document first!") ??
                                    "-",
                                isPositive: false,
                                context: context);
                          }
                        } else {}
                      },
                    ),
                  ),
                ),
                PickHeightAndWidth.height20,
              ],
            );
    });
  }
}
