// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/share_preference.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_models/document_data_model.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_providers/candidate_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:onboarding_app/widgets/form_builder_controls/dropdown_control.dart';
import 'package:onboarding_app/widgets/form_builder_controls/text_field_control.dart';
import 'package:provider/provider.dart';

class RemarksDialogBox extends StatefulWidget {
  final DocumentDataModel? selectedDocumentData;
  final String obApplicantId;

  final bool isDisable;
  const RemarksDialogBox(
      {super.key,
      this.selectedDocumentData,
      this.isDisable = false,
      required this.obApplicantId});

  @override
  State<RemarksDialogBox> createState() => _RemarksDialogBoxState();
}

class _RemarksDialogBoxState extends State<RemarksDialogBox> {
  final reviewKey = GlobalKey<FormBuilderState>();
  FocusNode selectReasonNode = FocusNode();

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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (widget.selectedDocumentData != null) {
      // authProvider.currentUserAuthInfo!.obApplicantId.toString()
      await candidateProvider.getDocumentRemarkHistoryApiFunction(
          context: context,
          dataParameter: {
            "documentId": widget.selectedDocumentData!.documentId,
            "pageSize": 500,
            "pageIndex": 1,
            "ObApplicantId": widget.obApplicantId,
            "_": DateTime.now().toUtc().millisecondsSinceEpoch.toString()
          });
    } else {
      await candidateProvider.getRejectReasonApiProvider(context: context);
    }

    setState(() {
      isLoading = false;
    });
  }

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
                  widget.selectedDocumentData == null
                      ? helper.translateTextTitle(titleText: "Reject Offer")
                      : helper.translateTextTitle(titleText: "Remarks") ?? "-",
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
          SizedBox(
            width: 500,
            child: FormBuilder(
              key: reviewKey,
              initialValue: {
                if (widget.selectedDocumentData != null)
                  "Remarks": widget.selectedDocumentData!.checkListRemarks ?? ""
              },
              child: SingleChildScrollView(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.selectedDocumentData == null)
                            CommonFormBuilderDropdown(
                              menuMaxHeight: 200.0,
                              hintText: helper.translateTextTitle(
                                  titleText:
                                      "Please select the reason to reject your offer"),
                              fieldName: "selectedReason",
                              // items: candidateProvider.getRejectReasonList
                              //     .map((reasonList) => DropdownItemModel(
                              //           // alignment: AlignmentDirectional.centerStart,
                              //           value: reasonList,
                              //           displayText:
                              //               reasonList.reason.toString(),
                              //         ))
                              //     .toList(),
                              items: candidateProvider.getRejectReasonList,

                              isRequired: false,
                            ),
                          CommonFormBuilderTextField(
                            // validator: (value) => value!.isEmpty
                            //     ? 'Please enter a remark before submitting'
                            //     : null,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText:
                                      "Please enter a remark before submitting"),
                            ]),
                            maxLines: 5,
                            fieldName: "Remarks",
                            isRequired: true,
                            maxCharLength: 570,
                            hint: helper.translateTextTitle(
                                titleText: "Please enter remarks here"),
                            onChanged: (value) {},
                            keyboardType: TextInputType.text,
                          ),
                          PickHeightAndWidth.height30,
                          Row(
                            children: [
                              Expanded(
                                child: CommonMaterialButton(
                                  borderColor: PickColors.primaryColor,
                                  color: PickColors.whiteColor,
                                  title: helper.translateTextTitle(
                                          titleText: "Cancel") ??
                                      "-",
                                  style: CommonTextStyle()
                                      .buttonTextStyle
                                      .copyWith(
                                        color: PickColors.primaryColor,
                                      ),
                                  onPressed: () {
                                    backToScreen(context: context);
                                  },
                                ),
                              ),
                              PickHeightAndWidth.width10,
                              Expanded(
                                child: CommonMaterialButton(
                                  title: helper.translateTextTitle(
                                          titleText: "Submit") ??
                                      "-",
                                  isButtonDisable: widget.isDisable,
                                  onPressed: () async {
                                    if (!widget.isDisable) {
                                      if (reviewKey.currentState!.validate()) {
                                        reviewKey.currentState!.save();

                                        final candidateProvider =
                                            Provider.of<CandidateProvider>(
                                                context,
                                                listen: false);
                                        final authProvider =
                                            Provider.of<AuthProvider>(context,
                                                listen: false);

                                        if (widget.selectedDocumentData !=
                                            null) {
                                          showOverlayLoader(context);
                                          if (await candidateProvider
                                              .uploadCheckListDocumentFunction(
                                                  documentId: widget
                                                      .selectedDocumentData!
                                                      .documentId
                                                      .toString(),
                                                  documentCount: "0",
                                                  obApplicantId:
                                                      widget.obApplicantId,
                                                  remarkString: reviewKey
                                                      .currentState!
                                                      .value["Remarks"],
                                                  documentStatus: "Submitted",
                                                  stageId: widget
                                                      .selectedDocumentData!
                                                      .applicationStage
                                                      .toString(),
                                                  updatedBy:
                                                      widget.obApplicantId,
                                                  fieName: "",
                                                  fileByteData: null,
                                                  context: context)) {
                                            await candidateProvider
                                                .getDocumentCheckListApiFunction(
                                                    context: context,
                                                    obApplicantId:
                                                        widget.obApplicantId,
                                                    time: DateTime.now()
                                                        .microsecondsSinceEpoch
                                                        .toString());
                                            hideOverlayLoader();
                                            backToScreen(context: context);
                                          } else {
                                            hideOverlayLoader();
                                          }
                                        } else {
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
                                                isCancel: true,
                                                subTitle: helper.translateTextTitle(
                                                    titleText:
                                                        "In case you click on 'Submit' and choose to Reject this offer, you will not be able to log in to this onboarding portal."),
                                                onPressButton: () async {
                                                  showOverlayLoader(context);
                                                  if (await authProvider
                                                      .saveCandidateOfferDetailApiFunction(
                                                          helper: helper,
                                                          dataParameter: {
                                                            "rejectReasonId":
                                                                reviewKey
                                                                    .currentState!
                                                                    .value[
                                                                        "selectedReason"]
                                                                        ['id']
                                                                    .toString(),
                                                            "remark": reviewKey
                                                                .currentState!
                                                                .value[
                                                                    "Remarks"]
                                                                .toString(),
                                                            "isDiscuss": false,
                                                            "isReject": true,
                                                            "uploadedDocument":
                                                                ""
                                                          },
                                                          context: context)) {
                                                    hideOverlayLoader();
                                                  } else {
                                                    hideOverlayLoader();
                                                  }
                                                  backToScreen(
                                                      context: context);
                                                  await Shared_Preferences
                                                      .clearAllPref();

                                                  moveToNextScreenWithRoute(
                                                      context: context,
                                                      routePath:
                                                          AppRoutesPath.LOGIN);
                                                },
                                              );
                                            },
                                          );
                                        }
                                      } else {
                                        await showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return CommonConfirmationDialogBox(
                                              buttonTitle:
                                                  helper.translateTextTitle(
                                                      titleText: "Okay"),
                                              title: helper.translateTextTitle(
                                                  titleText: "Alert"),
                                              subTitle: reviewKey
                                                          .currentState!.errors[
                                                      reviewKey.currentState!
                                                          .errors.keys
                                                          .toList()
                                                          .first] ??
                                                  "-",
                                              onPressButton: () async {
                                                backToScreen(context: context);
                                              },
                                            );
                                          },
                                        );
                                        // showDialog(
                                        //   barrierDismissible: false,
                                        //   context: context,
                                        //   builder: (context) {
                                        //     return CommonConfirmationDialogBox(
                                        //       buttonTitle: "Okay",
                                        //       title: "Alert",
                                        //       subTitle:
                                        //           "Please enter a remark before submitting",
                                        //       onPressButton: () async {
                                        //         backToScreen(context: context);
                                        //       },
                                        //     );
                                        //   },
                                        // );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (candidateProvider
                              .documentRemarkHistoryList.isNotEmpty)
                            PickHeightAndWidth.height30,
                          if (candidateProvider
                              .documentRemarkHistoryList.isNotEmpty)
                            Text(
                              helper.translateTextTitle(
                                      titleText: "Recruiter Comments") ??
                                  "-",
                              style: CommonTextStyle()
                                  .mainHeadingTextStyle
                                  .copyWith(
                                    color: PickColors.blackColor,
                                    fontSize: 16,
                                  ),
                            ),
                          if (candidateProvider
                              .documentRemarkHistoryList.isNotEmpty)
                            PickHeightAndWidth.height20,
                          Container(
                            constraints: BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: candidateProvider
                                  .documentRemarkHistoryList.length,
                              itemBuilder: (context, index) {
                                return (candidateProvider
                                                .documentRemarkHistoryList[
                                                    index]
                                                .remarks ??
                                            "") !=
                                        ""
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: Container(
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: PickColors.bgColor,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RemarkPreviewWidget(
                                                title: "Name :- ",
                                                titleValue: candidateProvider
                                                        .documentRemarkHistoryList[
                                                            index]
                                                        .user ??
                                                    "-",
                                              ),
                                              PickHeightAndWidth.height10,
                                              RemarkPreviewWidget(
                                                title: "Remarks :- ",
                                                titleValue: candidateProvider
                                                        .documentRemarkHistoryList[
                                                            index]
                                                        .remarks ??
                                                    "-",
                                              ),
                                              PickHeightAndWidth.height10,
                                              RemarkPreviewWidget(
                                                title: "Date :- ",
                                                titleValue: candidateProvider
                                                        .documentRemarkHistoryList[
                                                            index]
                                                        .submittedDate ??
                                                    "-",
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container();
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          )
        ],
      );
    });
  }
}

class RemarkPreviewWidget extends StatelessWidget {
  final String title;
  final String titleValue;
  const RemarkPreviewWidget({
    super.key,
    required this.title,
    required this.titleValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                color: PickColors.blackColor,
                fontFamily: "Cera Pro",
              ),
        ),
        PickHeightAndWidth.width10,
        Expanded(
          child: Text(
            titleValue,
            style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                  color: PickColors.hintColor,
                  fontFamily: "Cera Pro",
                ),
          ),
        ),
      ],
    );
  }
}
