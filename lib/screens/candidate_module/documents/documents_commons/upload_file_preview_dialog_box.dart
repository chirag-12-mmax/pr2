// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/launch_url.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_providers/candidate_provider.dart';
import 'package:onboarding_app/widgets/form_builder_controls/file_upload_widget.dart';
import 'package:provider/provider.dart';

class UploadFilePreviewDialogBox extends StatefulWidget {
  final int selectedIndex;
  final String obApplicantId;
  const UploadFilePreviewDialogBox({
    super.key,
    required this.selectedIndex,
    required this.obApplicantId,
  });

  @override
  State<UploadFilePreviewDialogBox> createState() =>
      _UploadFilePreviewDialogBoxState();
}

class _UploadFilePreviewDialogBoxState
    extends State<UploadFilePreviewDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Consumer2(builder: (BuildContext context, GeneralHelper helper,
        CandidateProvider candidateProvider, snapshot) {
      return SimpleDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        title: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  helper.translateTextTitle(titleText: "Files") ?? "-",
                  style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                        color: PickColors.blackColor,
                        fontSize: 20,
                      ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                backToScreen(context: context);
              },
              child: SvgPicture.asset(
                alignment: Alignment.centerRight,
                PickImages.cancelIcon,
              ),
            ),
          ],
        ),
        children: [
          Container(
            width: 500,
            constraints: const BoxConstraints(
              maxHeight: 300,
            ),
            // height: 300,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UploadedFilePreviewWidget(
                    documentData: candidateProvider
                        .documentCheckListDetailList[widget.selectedIndex],
                    fieldConfig: null,
                    currentSectionId: null,
                    onTapDelete: candidateProvider
                        .documentCheckListDetailList[widget.selectedIndex]
                        .fileName
                        .toString()
                        .split(",")
                        .map((e) {
                      return () async {
                        final candidateProvider =
                            Provider.of<CandidateProvider>(context,
                                listen: false);
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        showOverlayLoader(context);
                        if (await candidateProvider
                            .deleteUploadedDocumentApiFunction(
                                context: context,
                                dataParameter: {
                              "documentId": candidateProvider
                                  .documentCheckListDetailList[
                                      widget.selectedIndex]
                                  .documentId
                                  .toString(),
                              "applicationStageId": candidateProvider
                                  .documentCheckListDetailList[
                                      widget.selectedIndex]
                                  .applicationStage
                                  .toString(),
                              "documentName": e,
                              "ObApplicantId": widget.obApplicantId,
                            })) {
                          await candidateProvider
                              .getDocumentCheckListApiFunction(
                                  context: context,
                                  obApplicantId: widget.obApplicantId,
                                  time: DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString());
                          hideOverlayLoader();
                        }
                        hideOverlayLoader();
                        backToScreen(context: context);
                      };
                    }).toList(),
                    onTapViewButton: candidateProvider
                        .documentCheckListDetailList[widget.selectedIndex]
                        .fileName
                        .toString()
                        .split(",")
                        .map((e) {
                      return () async {
                        final candidateProvider =
                            Provider.of<CandidateProvider>(context,
                                listen: false);
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        showOverlayLoader(context);
                        if (await candidateProvider
                            .previewUploadedDocumentApiFunction(
                                context: context,
                                dataParameter: {
                              "documentId": candidateProvider
                                  .documentCheckListDetailList[
                                      widget.selectedIndex]
                                  .documentId
                                  .toString(),
                              "stageName": candidateProvider
                                  .documentCheckListDetailList[
                                      widget.selectedIndex]
                                  .applicationStageStatus
                                  .toString(),
                              "fileName": e,
                              "ObApplicantId": widget.obApplicantId,
                              "_": DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString()
                            })) {
                          hideOverlayLoader();
                          if (candidateProvider.fileForPreview != null) {}
                          await launchUrlServiceFunction(
                              url: candidateProvider
                                  .fileForPreview["fileDownloadURL"],
                              context: context);
                        }
                        hideOverlayLoader();
                      };
                    }).toList(),
                    uploadedFiles: candidateProvider
                        .documentCheckListDetailList[widget.selectedIndex]
                        .fileName
                        .toString()
                        .split(","),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
