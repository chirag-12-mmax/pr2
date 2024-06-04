import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/launch_url.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_models/document_data_model.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_models/configuration_model.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_providers/profile_provider.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';

class FileUploadWidget extends StatelessWidget {
  final String fieldName;
  final bool isEnabled;
  final bool isRequired;
  final bool isAllowMultiple;
  final bool isAlreadyAdded;

  final Function(List<PlatformFile>?)? onChanged;
  final String title;
  const FileUploadWidget({
    super.key,
    required this.fieldName,
    required this.isEnabled,
    required this.isRequired,
    this.onChanged,
    this.isAllowMultiple = false,
    required this.title,
    required this.isAlreadyAdded,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderFilePicker(
      name: fieldName,
      previewImages: false,
      allowMultiple: false,
      enabled: isEnabled,
      maxFiles: isAllowMultiple ? null : 1,
      withData: true,
      validator: FormBuilderValidators.compose([
        if (isRequired && (isAlreadyAdded))
          FormBuilderValidators.required(
              errorText: "${fieldName} is Mandatory"),
      ]),
      onChanged: onChanged,
      decoration: InputDecoration(
          errorStyle: const TextStyle(
            fontSize: 0,
            height: 0.01,
          ),
          border: InputBorder.none,
          suffix: null,
          counter: Container()),
      customFileViewerBuilder: (files, filesSetter) {
        return Container();
      },
      typeSelectors: [
        TypeSelector(
          type: FileType.any,
          selector: SizedBox(
            child: DottedBorder(
              borderType: BorderType.RRect,
              padding: const EdgeInsets.all(10),
              radius: const Radius.circular(8),
              color: PickColors.hintColor,
              // strokeWidth: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: CommonTextStyle()
                            .noteHeadingTextStyle
                            .copyWith(fontSize: 13),
                      ),
                      if (isRequired)
                        Text(
                          '*',
                          style: CommonTextStyle()
                              .noteHeadingTextStyle
                              .copyWith(
                                  fontSize: 15, color: PickColors.primaryColor),
                        ),
                    ],
                  ),
                  PickHeightAndWidth.width15,
                  SvgPicture.asset(
                    PickImages.uploadIcon,
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class UploadedFilePreviewWidget extends StatefulWidget {
  const UploadedFilePreviewWidget(
      {super.key,
      required this.uploadedFiles,
      required this.onTapDelete,
      this.documentData,
      this.onTapViewButton,
      required this.fieldConfig,
      required this.currentSectionId});
  final List<dynamic> uploadedFiles;
  final List<dynamic> onTapDelete;
  final List<dynamic>? onTapViewButton;
  final DocumentDataModel? documentData;
  final FieldConfigDetails? fieldConfig;
  final String? currentSectionId;

  @override
  State<UploadedFilePreviewWidget> createState() =>
      _UploadedFilePreviewWidgetState();
}

class _UploadedFilePreviewWidgetState extends State<UploadedFilePreviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer3(builder: (BuildContext context, AuthProvider authProvider,
        ProfileProvider profileProvider, GeneralHelper helper, snapshot) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ((widget.uploadedFiles[index] ?? "").toString().trim() != "")
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(Uri.parse(widget.uploadedFiles[index])
                              .path
                              .split("/")
                              .last)),
                      if (widget.uploadedFiles[index].toString().trim() != "")
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye_rounded),
                          onPressed: () async {
                            if (widget.onTapViewButton != null) {
                              widget.onTapViewButton![index]();
                            } else {
                              if (widget.fieldConfig != null) {
                                if (widget.fieldConfig!.isCustomField ??
                                    false) {
                                  launchUrlServiceFunction(
                                      url: widget.uploadedFiles[index],
                                      context: context);
                                } else if ((widget.fieldConfig?.recFieldCode ??
                                        "") ==
                                    "bankUploadedDocument") {
                                  showOverlayLoader(context);
                                  if (await profileProvider
                                      .previewBankDocumentApiFunction(
                                          dataParameter: {
                                        "FileName": widget.uploadedFiles[index]
                                            .split("?")
                                            .first
                                            .split("/")
                                            .last
                                      },
                                          context: context,
                                          helper: helper)) {
                                    hideOverlayLoader();
                                  } else {
                                    hideOverlayLoader();
                                  }
                                } else {
                                  showOverlayLoader(context);
                                  if (await profileProvider
                                      .previewProfileDocumentApiFunction(
                                          dataParameter: {
                                        "FileName": widget.uploadedFiles[index]
                                            .split("?")
                                            .first
                                            .split("/")
                                            .last,
                                        "SectionName": widget.currentSectionId
                                      },
                                          context: context,
                                          helper: helper)) {
                                    hideOverlayLoader();
                                  } else {
                                    hideOverlayLoader();
                                  }
                                }
                              } else {
                                launchUrlServiceFunction(
                                    url: widget.uploadedFiles[index],
                                    context: context);
                              }
                            }
                          },
                        ),
                      if (widget.uploadedFiles[index].toString().trim() != "")
                        (widget.documentData != null
                                ? ([
                                          CandidateStages.OFFER_VERIFICATION,
                                          CandidateStages
                                              .PRE_JOINING_VERIFICATION,
                                          CandidateStages.JOINING_CONFIRMATION,
                                          CandidateStages
                                              .POST_JOINING_VERIFICATION,
                                          CandidateStages.COMPLETION
                                        ].contains(authProvider
                                            .candidateCurrentStage) &&
                                        ["Submitted", "Verified"].contains(
                                            widget.documentData!
                                                    .documentStatus ??
                                                "Pending")) ||
                                    (widget.documentData!
                                                    .uploadedDocumentCount ??
                                                "0")
                                            .toString() ==
                                        "0"
                                : false)
                            ? Container()
                            : IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CommonConfirmationDialogBox(
                                        title: helper.translateTextTitle(
                                            titleText: "Confirmation"),
                                        buttonTitle: helper.translateTextTitle(
                                            titleText: "Yes"),
                                        cancelButtonTitle:
                                            helper.translateTextTitle(
                                                titleText: "No"),
                                        subTitle: helper.translateTextTitle(
                                            titleText:
                                                "Are you sure you want to Delete ?"),
                                        onPressButton: () async {
                                          widget.onTapDelete[index]();
                                          backToScreen(context: context);
                                        },
                                        isCancel: true,
                                      );
                                    },
                                  );
                                },
                                color: PickColors.primaryColor,
                              )
                      // color: [
                      //   CandidateStages.OFFER_VERIFICATION,
                      //   CandidateStages.PRE_JOINING_VERIFICATION
                      // ].contains(authProvider.candidateCurrentStage)
                      //     ? PickColors.hintColor
                      //     : PickColors.primaryColor),
                    ],
                  ),
                )
              : Container();
        },
        // separatorBuilder: (context, index) =>
        //     const Divider(color: PickColors.hintColor),
        itemCount: widget.uploadedFiles.length,
      );
    });
  }
}

class DocumentUploadWidget extends StatefulWidget {
  final String fieldName;
  final bool isEnabled;
  final bool isRequired;
  final Color? color;
  final Function(List<PlatformFile>?)? onChanged;
  const DocumentUploadWidget(
      {super.key,
      required this.fieldName,
      required this.isEnabled,
      required this.isRequired,
      this.color,
      this.onChanged});

  @override
  State<DocumentUploadWidget> createState() => _DocumentUploadWidgetState();
}

class _DocumentUploadWidgetState extends State<DocumentUploadWidget> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderFilePicker(
      name: widget.fieldName,
      previewImages: false,
      allowMultiple: false,
      enabled: widget.isEnabled,
      withData: true,
      validator: FormBuilderValidators.compose([
        if (widget.isRequired)
          FormBuilderValidators.required(
              errorText: "${widget.fieldName} is Mandatory"),
      ]),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          suffix: null,
          counter: Container()),
      customFileViewerBuilder: (files, filesSetter) {
        return Container();
      },
      typeSelectors: [
        TypeSelector(
            type: FileType.any,
            selector: SizedBox(
              height: 19,
              width: 19,
              child: Icon(
                Icons.cloud_upload,
                color: widget.color,
              ),
            )
            // SvgPicture.asset(PickImages.addIcon,
            //     width: 19, colorFilter: widget.colorFilter),
            ),
      ],
    );
  }
}
