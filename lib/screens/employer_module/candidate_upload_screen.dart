// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigation/app_router.gr.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/functions/toast_msg.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/employer_module/add_new_candidate_form_screen.dart';
import 'package:onboarding_app/screens/employer_module/employer_model/requisition_model.dart';
import 'package:onboarding_app/screens/employer_module/employer_provider/dashboard_provider.dart';
import 'package:onboarding_app/screens/employer_module/push_notification_dialog_box.dart';
import 'package:onboarding_app/widgets/build_logo_profile.dart';
import 'package:onboarding_app/widgets/form_builder_controls/dropdown_control.dart';
import 'package:onboarding_app/widgets/form_builder_controls/text_field_control.dart';
import 'package:provider/provider.dart';

@RoutePage()
class CandidateUploadScreen extends StatefulWidget {
  String? selectedStageId;
  CandidateUploadScreen(
      {super.key, @PathParam('stageId') this.selectedStageId});

  @override
  State<CandidateUploadScreen> createState() => _CandidateUploadScreenState();
}

class _CandidateUploadScreenState extends State<CandidateUploadScreen> {
  bool isLoading = false;
  bool isCheck = false;
  RequisitionModel? selectedRequisition;
  String? searchText = null;
  Timer? debounce;

  List<bool> _selectedCheckBoxList = [];

  bool isADDNewCandidate = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    _selectedCheckBoxList.clear();
    if (widget.selectedStageId == ":stageId") {
      widget.selectedStageId = null;
    }
    setState(() {
      isLoading = true;
    });

    final employerDashboardProvider =
        Provider.of<EmployerDashboardProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (widget.selectedStageId != null) {
      await employerDashboardProvider.getStatisticsCandidateDetailsApiFunction(
          context: context,
          dataParameter: {
            "EmployeeCode":
                authProvider.employerLoginData!.employCode.toString(),
            "ApplicationStageId": widget.selectedStageId
          });

      _selectedCheckBoxList = List.generate(
          employerDashboardProvider.allCandidateDataList.length, (_) => true);
    } else {
      await employerDashboardProvider
          .getAllCandidateDetailsApiFunction(context: context, dataParameter: {
        "EmployeeCode": authProvider.employerLoginData!.employCode.toString(),
        "RequisitionId": "0",
        "_": DateTime.now().toUtc().millisecondsSinceEpoch.toString()
      });
      _selectedCheckBoxList = List.generate(
          employerDashboardProvider.allCandidateDataList.length, (_) => true);
    }

    await employerDashboardProvider
        .getAssignedRequisitionsApiFunction(context: context, dataParameter: {
      "EmployeeCode": authProvider.employerLoginData!.employCode.toString(),
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<void> filterCandidateData() async {
    _selectedCheckBoxList.clear();
    final employerDashboardProvider =
        Provider.of<EmployerDashboardProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (selectedRequisition != null || searchText != null) {
      showOverlayLoader(context);
      if (await employerDashboardProvider
          .getAllSearchableCandidateDetailsFunction(
              context: context,
              dataParameter: {
            "EmployeeCode":
                authProvider.employerLoginData!.employCode.toString(),
            if (selectedRequisition != null)
              "RequisitionId": selectedRequisition!.requisitionId.toString(),
            if ((searchText ?? "").trim() != "") "SearchText": searchText,
            "_": DateTime.now().toUtc().millisecondsSinceEpoch.toString()
          })) {
        _selectedCheckBoxList = List.generate(
            employerDashboardProvider.allCandidateDataList.length,
            (_) => false);
        hideOverlayLoader();
      } else {
        hideOverlayLoader();
      }
    }
  }

  @override
  void didUpdateWidget(covariant CandidateUploadScreen oldWidget) {
    // TODO: implement didUpdateWidget
    if (widget.selectedStageId == ":stageId") {
      widget.selectedStageId = null;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PickColors.bgColor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : isADDNewCandidate
              ? AddNewCandidateFormWidget(
                  isFromAadharKyc: false,
                  isFromUpload: true,
                  actualAadharId: null,
                  initialBasicDetail: {"ReferenceCode": selectedRequisition},
                )
              : Consumer2(
                  builder: (BuildContext context,
                      GeneralHelper helper,
                      EmployerDashboardProvider employerDashboardProvider,
                      snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            PickHeightAndWidth.height10,
                            CommonFormBuilderDropdown(
                                fullyDisable: false,
                                hintText: helper.translateTextTitle(
                                    titleText: "Select Requisition"),
                                fieldName: "ReferenceCode",
                                onChanged: (selectedItem) async {
                                  if (selectedItem != null) {
                                    selectedRequisition = selectedItem;
                                    await filterCandidateData();
                                  }
                                },
                                isEnabled: true,
                                isRequired: false,
                                items: employerDashboardProvider
                                    .listOfRequisition),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      // Unfocus the current focus scope to hide the keyboard
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: CommonFormBuilderTextField(
                                      bottom: 0,
                                      fieldName: "candidate",
                                      hint: helper.translateTextTitle(
                                          titleText: "Search Candidate"),
                                      isRequired: false,
                                      onChanged: (value) {
                                        if (value != null) {
                                          searchText = value;
                                        } else {
                                          searchText = "";
                                        }
                                      },
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  // hoverColor: Colors.transparent,
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    filterCandidateData();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Icon(Icons.search),
                                  ),
                                ),
                                if (widget.selectedStageId == null)
                                  InkWell(
                                    // hoverColor: Colors.transparent,

                                    onTap: () {
                                      if (selectedRequisition != null) {
                                        setState(() {
                                          isADDNewCandidate = true;
                                        });
                                      } else {
                                        showToast(
                                            message: helper.translateTextTitle(
                                                titleText:
                                                    "Please select requisition first"),
                                            isPositive: false,
                                            context: context);
                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Icon(Icons.add),
                                    ),
                                  )
                              ],
                            ),
                            PickHeightAndWidth.height15,
                            employerDashboardProvider
                                    .allCandidateDataList.isNotEmpty
                                ? GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: employerDashboardProvider
                                        .allCandidateDataList.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            mainAxisExtent: checkPlatForm(
                                                    context: context,
                                                    platforms: [
                                                  CustomPlatForm.MOBILE_VIEW,
                                                  CustomPlatForm.MOBILE,
                                                  CustomPlatForm
                                                      .MIN_MOBILE_VIEW,
                                                  CustomPlatForm.MIN_MOBILE,
                                                ])
                                                ? 200
                                                : 130,
                                            crossAxisCount: checkPlatForm(
                                                    context: context,
                                                    platforms: [
                                                  CustomPlatForm.TABLET_VIEW,
                                                  CustomPlatForm.TABLET,
                                                  CustomPlatForm.MOBILE_VIEW,
                                                  CustomPlatForm.MOBILE,
                                                  CustomPlatForm
                                                      .MIN_LAPTOP_VIEW,
                                                  CustomPlatForm
                                                      .MIN_MOBILE_VIEW,
                                                  CustomPlatForm.MIN_MOBILE,
                                                ])
                                                ? 1
                                                : 2,
                                            crossAxisSpacing: 14,
                                            mainAxisSpacing: 14),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      List<dynamic> candidateDataList = [
                                        {
                                          "title": employerDashboardProvider
                                                  .allCandidateDataList[index]
                                                  .requisitionTitle ??
                                              "-",
                                          "icon": PickImages.profileAddIcon,
                                        },
                                        {
                                          "title": employerDashboardProvider
                                                  .allCandidateDataList[index]
                                                  .emailID ??
                                              "-",
                                          "icon": PickImages.mailIcon,
                                        },
                                        {
                                          "title": employerDashboardProvider
                                                  .allCandidateDataList[index]
                                                  .mobile ??
                                              "-",
                                          "icon": PickImages.callIcon,
                                        },
                                        {
                                          "title": employerDashboardProvider
                                                  .allCandidateDataList[index]
                                                  .sourcedOn ??
                                              "-",
                                          "icon": PickImages.calenderImage,
                                        }
                                      ];
                                      return InkWell(
                                        onTap: () {
                                          if (widget.selectedStageId == null) {
                                            moveToNextScreen(
                                                context: context,
                                                pageRoute: ProfileWebScreen(
                                                    applicantId:
                                                        employerDashboardProvider
                                                                .allCandidateDataList[
                                                                    index]
                                                                .obApplicantID ??
                                                            "",
                                                    requisitionId:
                                                        employerDashboardProvider
                                                                .allCandidateDataList[
                                                                    index]
                                                                .requisitionID ??
                                                            ""));
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: PickColors.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: checkPlatForm(
                                                    context: context,
                                                    platforms: [
                                                  CustomPlatForm.MOBILE_VIEW,
                                                  CustomPlatForm.MOBILE,
                                                  CustomPlatForm
                                                      .MIN_MOBILE_VIEW,
                                                  CustomPlatForm.MIN_MOBILE,
                                                ])
                                                ? CrossAxisAlignment.start
                                                : CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Stack(
                                                alignment:
                                                    Alignment.bottomRight,
                                                children: [
                                                  BuildLogoProfileImageWidget(
                                                      height: checkPlatForm(
                                                              context: context,
                                                              platforms: [
                                                            CustomPlatForm
                                                                .MOBILE_VIEW,
                                                            CustomPlatForm
                                                                .MOBILE,
                                                            CustomPlatForm
                                                                .MIN_MOBILE_VIEW,
                                                            CustomPlatForm
                                                                .MIN_MOBILE,
                                                          ])
                                                          ? 45
                                                          : 80,
                                                      width: checkPlatForm(
                                                              context: context,
                                                              platforms: [
                                                            CustomPlatForm
                                                                .MOBILE_VIEW,
                                                            CustomPlatForm
                                                                .MOBILE,
                                                            CustomPlatForm
                                                                .MIN_MOBILE_VIEW,
                                                            CustomPlatForm
                                                                .MIN_MOBILE,
                                                          ])
                                                          ? 45
                                                          : 80,
                                                      imagePath: employerDashboardProvider
                                                              .allCandidateDataList[
                                                                  index]
                                                              .applicantPhoto ??
                                                          "",
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      titleName:
                                                          employerDashboardProvider
                                                              .allCandidateDataList[
                                                                  index]
                                                              .candidateName),
                                                  if (employerDashboardProvider
                                                          .allCandidateDataList[
                                                              index]
                                                          .resumeSource ==
                                                      "ZingHR")
                                                    Positioned(
                                                      bottom: checkPlatForm(
                                                              context: context,
                                                              platforms: [
                                                            CustomPlatForm
                                                                .MOBILE_VIEW,
                                                            CustomPlatForm
                                                                .MOBILE,
                                                            CustomPlatForm
                                                                .MIN_MOBILE_VIEW,
                                                            CustomPlatForm
                                                                .MIN_MOBILE,
                                                          ])
                                                          ? 0.0
                                                          : 12,
                                                      child: SvgPicture.asset(
                                                          PickImages
                                                              .approveIcon),
                                                    )
                                                ],
                                              ),
                                              PickHeightAndWidth.width15,
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "${employerDashboardProvider.allCandidateDataList[index].candidateName ?? "-"}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: CommonTextStyle()
                                                                .textFieldLabelTextStyle
                                                                .copyWith(
                                                                  fontSize: 18,
                                                                ),
                                                          ),
                                                        ),
                                                        if ((employerDashboardProvider
                                                                            .allCandidateDataList[
                                                                                index]
                                                                            .offerStatus ??
                                                                        "")
                                                                    .toString()
                                                                    .trim() !=
                                                                "" &&
                                                            (employerDashboardProvider
                                                                            .allCandidateDataList[
                                                                                index]
                                                                            .offerStatus ??
                                                                        "")
                                                                    .toString()
                                                                    .trim() !=
                                                                "Approve")
                                                          Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          3),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(20),
                                                                  color: employerDashboardProvider.allCandidateDataList[index].offerStatus == "Not Accepted"
                                                                      ? Colors.orange[700]
                                                                      : employerDashboardProvider.allCandidateDataList[index].offerStatus == "Rejected"
                                                                          ? Colors.red
                                                                          : Colors.green[700]),
                                                              child: Text(
                                                                helper.translateTextTitle(
                                                                    titleText: employerDashboardProvider
                                                                            .allCandidateDataList[index]
                                                                            .offerStatus ??
                                                                        " "),
                                                                style: TextStyle(
                                                                    color: PickColors
                                                                        .whiteColor),
                                                              )),
                                                        if (widget
                                                                .selectedStageId !=
                                                            null)
                                                          PickHeightAndWidth
                                                              .width10,
                                                        if (widget
                                                                .selectedStageId !=
                                                            null)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10),
                                                            child: SizedBox(
                                                              height: 25,
                                                              width: 25,
                                                              child: Checkbox(
                                                                activeColor:
                                                                    PickColors
                                                                        .primaryColor,
                                                                value:
                                                                    _selectedCheckBoxList[
                                                                        index],
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    _selectedCheckBoxList[
                                                                            index] =
                                                                        value!;

                                                                    if (!value) {
                                                                      employerDashboardProvider
                                                                          .deviceIdListForSendNotification
                                                                          .remove(employerDashboardProvider
                                                                              .allCandidateDataList[index]
                                                                              .deviceID);
                                                                      // printDebug(textString:employerDashboardProvider
                                                                      //     .deviceIdListForSendNotification
                                                                      //     .toList());
                                                                      // printDebug(textString:employerDashboardProvider
                                                                      //     .deviceIdListForSendNotification
                                                                      //     .length);
                                                                    } else {
                                                                      if (employerDashboardProvider
                                                                              .allCandidateDataList[index]
                                                                              .deviceID !=
                                                                          null) {
                                                                        employerDashboardProvider.deviceIdListForSendNotification.add(employerDashboardProvider
                                                                            .allCandidateDataList[index]
                                                                            .deviceID
                                                                            .toString());
                                                                        // printDebug(textString:"****");
                                                                        // printDebug(textString:employerDashboardProvider
                                                                        //     .deviceIdListForSendNotification
                                                                        //     .toList());
                                                                        // printDebug(textString:employerDashboardProvider
                                                                        //     .deviceIdListForSendNotification
                                                                        //     .length);
                                                                      }
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        // SvgPicture.asset(
                                                        //   PickImages.messageIcon,
                                                        //   height: 25,
                                                        // )
                                                      ],
                                                    ),
                                                    PickHeightAndWidth.height15,
                                                    GridView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          candidateDataList
                                                              .length,
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                              mainAxisExtent:
                                                                  20,
                                                              crossAxisCount:
                                                                  checkPlatForm(
                                                                          context:
                                                                              context,
                                                                          platforms: [
                                                                    CustomPlatForm
                                                                        .MOBILE_VIEW,
                                                                    CustomPlatForm
                                                                        .MOBILE,
                                                                    CustomPlatForm
                                                                        .MIN_MOBILE_VIEW,
                                                                    CustomPlatForm
                                                                        .MIN_MOBILE,
                                                                  ])
                                                                      ? 1
                                                                      : 2,
                                                              crossAxisSpacing:
                                                                  14,
                                                              mainAxisSpacing:
                                                                  14),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SvgPicture.asset(
                                                              candidateDataList[
                                                                      index]
                                                                  ["icon"],
                                                              height: 20,
                                                              color: PickColors
                                                                  .primaryColor,
                                                            ),
                                                            PickHeightAndWidth
                                                                .width10,
                                                            Flexible(
                                                              child: Text(
                                                                candidateDataList[
                                                                        index]
                                                                    ["title"],
                                                                // maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: CommonTextStyle()
                                                                    .noteHeadingTextStyle
                                                                    .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                        top: checkPlatForm(
                                                context: context,
                                                platforms: [
                                          CustomPlatForm.MOBILE_VIEW,
                                          CustomPlatForm.MOBILE,
                                          CustomPlatForm.MIN_MOBILE_VIEW,
                                          CustomPlatForm.MIN_MOBILE,
                                        ])
                                            ? 250
                                            : 350),
                                    child: Text(
                                      helper.translateTextTitle(
                                          titleText: "Oops, no records found"),
                                      style: CommonTextStyle()
                                          .subMainHeadingTextStyle,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: widget.selectedStageId != null
          ? FloatingActionButton(
              elevation: 4.0,
              backgroundColor: PickColors.primaryColor,
              onPressed: () {
                final employerDashboardProvider =
                    Provider.of<EmployerDashboardProvider>(context,
                        listen: false);
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return PushNotificationDialogBox(
                        deviceIdList: employerDashboardProvider
                            .deviceIdListForSendNotification
                            .toList());
                  },
                );
              },
              child: SvgPicture.asset(
                height: 25,
                width: 25,
                PickImages.sendNotificationIcon,
                color: PickColors.whiteColor,
              ),
            )
          : Container(),
    );
  }
}
