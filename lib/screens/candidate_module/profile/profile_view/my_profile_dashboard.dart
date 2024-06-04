// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/date_formates.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigation/app_router.gr.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/share_preference.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/launch_url.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/dashboard/dashboard_commons/list_tile_widget.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_common/profile_row_info_widget.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_common/profile_status_widget.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_providers/profile_provider.dart';
import 'package:onboarding_app/screens/employer_module/employer_provider/dashboard_provider.dart';
import 'package:onboarding_app/services/socket_services.dart';
import 'package:onboarding_app/widgets/build_logo_profile.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';

@RoutePage()
class MyProfileWidget extends StatefulWidget {
  const MyProfileWidget({super.key});

  @override
  State<MyProfileWidget> createState() => _MyProfileWidgetState();
}

class _MyProfileWidgetState extends State<MyProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer4(builder: (BuildContext context,
        ProfileProvider profileProvider,
        AuthProvider authProvider,
        GeneralHelper helper,
        EmployerDashboardProvider employerDashboardProvider,
        snapshot) {
      return SingleChildScrollView(
        child: profileProvider.profileConfigurationDetails != null
            ? Container(
                color: PickColors.bgColor,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 20, right: 20, bottom: 20),
                  child: Column(
                    children: [
                      Container(
                        width: SizeConfig.screenWidth,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: PickColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BuildLogoProfileImageWidget(
                                  // height: 70,
                                  // width: 70,
                                  borderRadius: BorderRadius.circular(12),
                                  imagePath: profileProvider
                                      .candidateProfileStatusInformation!
                                      .candidateDetails!
                                      .applicantPhoto
                                      .toString(),
                                  titleName: profileProvider
                                      .candidateProfileStatusInformation!
                                      .candidateDetails!
                                      .candidateFullName
                                      .toString(),
                                ),
                                PickHeightAndWidth.width15,
                                Expanded(
                                  flex: checkPlatForm(
                                          context: context,
                                          platforms: [
                                        CustomPlatForm.MIN_LAPTOP_VIEW,
                                        CustomPlatForm.LARGE_LAPTOP_VIEW
                                      ])
                                      ? 1
                                      : 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        profileProvider
                                                .candidateProfileStatusInformation!
                                                .candidateDetails!
                                                .candidateFullName ??
                                            "-",
                                        style: CommonTextStyle()
                                            .subMainHeadingTextStyle,
                                      ),
                                      if (currentLoginUserType !=
                                          loginUserTypes[1])
                                        PickHeightAndWidth.height5,
                                      if (currentLoginUserType !=
                                          loginUserTypes[1])
                                        ProfileRowInfoWidget(
                                            icon: PickImages.profileAdd,
                                            title: currentLoginUserType ==
                                                    loginUserTypes.first
                                                ? authProvider
                                                        .applicantInformation!
                                                        .designation ??
                                                    ""
                                                : "-"),
                                      if (currentLoginUserType !=
                                          loginUserTypes[1])
                                        PickHeightAndWidth.height5,
                                      if (currentLoginUserType !=
                                          loginUserTypes[1])
                                        ProfileRowInfoWidget(
                                          icon: PickImages.calenderImage,
                                          title: currentLoginUserType ==
                                                  loginUserTypes.first
                                              ? "Joining Date : " +
                                                  DateFormate.displayDateFormate
                                                      .format(DateTime.parse(
                                                          authProvider
                                                              .applicantInformation!
                                                              .dateOfJoining!))
                                              : "-",
                                        ),
                                    ],
                                  ),
                                ),
                                if (checkPlatForm(context: context, platforms: [
                                  CustomPlatForm.WEB,
                                  CustomPlatForm.MIN_LAPTOP_VIEW,
                                  CustomPlatForm.LARGE_LAPTOP_VIEW
                                ]))
                                  const Expanded(
                                    child: ProfileStatusWidget(),
                                  ),
                              ],
                            ),
                            if (checkPlatForm(context: context, platforms: [
                              CustomPlatForm.MOBILE_VIEW,
                              CustomPlatForm.TABLET_VIEW,
                              CustomPlatForm.MOBILE,
                              CustomPlatForm.TABLET,
                              CustomPlatForm.MIN_MOBILE_VIEW,
                              CustomPlatForm.MIN_MOBILE,
                            ]))
                              PickHeightAndWidth.height20,
                            if (checkPlatForm(context: context, platforms: [
                              CustomPlatForm.MOBILE_VIEW,
                              CustomPlatForm.MOBILE,
                              CustomPlatForm.TABLET,
                              CustomPlatForm.TABLET_VIEW,
                              CustomPlatForm.MIN_MOBILE_VIEW,
                              CustomPlatForm.MIN_MOBILE,
                            ]))
                              const ProfileStatusWidget(),
                          ],
                        ),
                      ),
                      PickHeightAndWidth.height20,
                      Container(
                        width: SizeConfig.screenWidth,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: PickColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: (profileProvider
                                              .profileConfigurationDetails!
                                              .tabDetails ??
                                          [])
                                      .length +
                                  (([
                                            CandidateStages.SCREENING,
                                            CandidateStages.SHORTLISTED,
                                            CandidateStages.INTERVIEW,
                                            CandidateStages.ASSESSMENT,
                                            CandidateStages.OFFER_CHECK_LIST,
                                            CandidateStages.OFFER_VERIFICATION,
                                            CandidateStages.SALARY_FITMENT,
                                            CandidateStages.OFFER_LATTER,
                                            CandidateStages.OFFER_ACCEPTANCE,
                                            CandidateStages
                                                .PRE_JOINING_CHECK_LIST,
                                            CandidateStages
                                                .PRE_JOINING_VERIFICATION,
                                            CandidateStages
                                                .JOINING_CONFIRMATION,
                                            CandidateStages.APPOINTMENT_LETTER,
                                            CandidateStages
                                                .POST_JOINING_CHECK_LIST,
                                            CandidateStages
                                                .POST_JOINING_VERIFICATION,
                                            CandidateStages.COMPLETION,
                                          ].contains(authProvider
                                              .candidateCurrentStage)) &&
                                          currentLoginUserType ==
                                              loginUserTypes[1]
                                      ? 1
                                      : 0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: 60,
                                      crossAxisCount: checkPlatForm(
                                              context: context,
                                              platforms: [
                                            CustomPlatForm.TABLET_VIEW,
                                            CustomPlatForm.MIN_LAPTOP_VIEW,
                                          ])
                                          ? 2
                                          : checkPlatForm(
                                                  context: context,
                                                  platforms: [
                                                  CustomPlatForm.MOBILE,
                                                  CustomPlatForm.MOBILE_VIEW,
                                                  CustomPlatForm
                                                      .MIN_MOBILE_VIEW,
                                                  CustomPlatForm.MIN_MOBILE,
                                                ])
                                              ? 1
                                              : 3,
                                      crossAxisSpacing: 14,
                                      mainAxisSpacing: 14),
                              itemBuilder: (BuildContext context, int index) {
                                bool isDocument = index ==
                                    (profileProvider
                                                .profileConfigurationDetails!
                                                .tabDetails ??
                                            [])
                                        .length;
                                return ListTitleWidget(
                                  trailingIcon: PickImages.arrowIcon,
                                  backGroundColor: PickColors.bgColor,
                                  onTap: () async {
                                    if (isDocument) {
                                      if ([
                                        CandidateStages.SCREENING,
                                        CandidateStages.SHORTLISTED,
                                        CandidateStages.INTERVIEW,
                                        CandidateStages.ASSESSMENT,
                                        CandidateStages.OFFER_VERIFICATION,
                                        CandidateStages.SALARY_FITMENT,
                                        CandidateStages.OFFER_LATTER,
                                        CandidateStages.OFFER_ACCEPTANCE,
                                        CandidateStages
                                            .PRE_JOINING_VERIFICATION,
                                        CandidateStages.JOINING_CONFIRMATION,
                                        CandidateStages.APPOINTMENT_LETTER,
                                        CandidateStages
                                            .POST_JOINING_VERIFICATION,
                                        CandidateStages.COMPLETION,
                                      ].contains(
                                          authProvider.candidateCurrentStage)) {
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
                                              subTitle: helper.translateTextTitle(
                                                  titleText:
                                                      "Please verify if you have filled in all the mandatory forms before uploading documents or forward this candidate to the next document upload stage"),
                                              onPressButton: () async {
                                                backToScreen(context: context);
                                              },
                                            );
                                          },
                                        );
                                      } else {
                                        moveToNextScreenWithRoute(
                                          context: context,
                                          routePath: AppRoutesPath.DOCUMENT,
                                        );
                                      }
                                    } else {
                                      moveToNextScreen(
                                          context: context,
                                          pageRoute: AboutMeScreen(
                                            tabName: profileProvider
                                                    .profileConfigurationDetails!
                                                    .tabDetails![index]
                                                    .fieldCode ??
                                                "-",
                                          ));
                                    }

                                    // profileTabsRouter!.setActiveIndex(index + 1);
                                  },
                                  title: helper.translateTextTitle(
                                      titleText: isDocument
                                          ? helper.translateTextTitle(
                                                  titleText: "Documents") ??
                                              "-"
                                          : profileProvider
                                                  .profileConfigurationDetails!
                                                  .tabDetails![index]
                                                  .fieldName ??
                                              "-"),
                                  leadingIcon: GlobalList.getProfileTabIcon(
                                      tabCode: isDocument
                                          ? "Document"
                                          : profileProvider
                                                  .profileConfigurationDetails!
                                                  .tabDetails![index]
                                                  .fieldCode ??
                                              "-"),
                                  subTitleText: isDocument
                                      ? null
                                      : "${profileProvider.candidateProfileStatusInformation!.tabWiseStatus!.firstWhere((element) => element.tabname == profileProvider.profileConfigurationDetails!.tabDetails![index].fieldCode).doneCount.toString()}/${profileProvider.candidateProfileStatusInformation!.tabWiseStatus!.firstWhere((element) => element.tabname == profileProvider.profileConfigurationDetails!.tabDetails![index].fieldCode).totalCount.toString()}",
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // SizedBox(
                      //     height: checkPlatForm(context: context, platforms: [
                      //   CustomPlatForm.MOBILE,
                      //   CustomPlatForm.MOBILE_VIEW,
                      //   CustomPlatForm.MIN_MOBILE_VIEW,
                      //   CustomPlatForm.MIN_MOBILE,
                      // ])
                      //         ? SizeConfig.screenWidth! * 0.10
                      //         : SizeConfig.screenWidth! * 0.25),
                      if ([
                            CandidateStages.SCREENING,
                            CandidateStages.SHORTLISTED,
                            CandidateStages.INTERVIEW,
                            CandidateStages.ASSESSMENT,
                            CandidateStages.OFFER_CHECK_LIST,
                            CandidateStages.OFFER_VERIFICATION,
                            CandidateStages.SALARY_FITMENT,
                            CandidateStages.OFFER_LATTER,
                            CandidateStages.OFFER_ACCEPTANCE,
                            CandidateStages.PRE_JOINING_CHECK_LIST,
                            CandidateStages.PRE_JOINING_VERIFICATION,
                            CandidateStages.JOINING_CONFIRMATION,
                          ].contains(authProvider.candidateCurrentStage) &&
                          currentLoginUserType == loginUserTypes[1])
                        Container(
                          constraints: const BoxConstraints(minWidth: 350),
                          margin: EdgeInsets.symmetric(vertical: 30),
                          width: SizeConfig.screenWidth! * 0.20,
                          child: CommonMaterialButton(
                            title: helper.translateTextTitle(
                                titleText: "Forward To Salary Fitment"),
                            isButtonDisable: [
                              CandidateStages.SALARY_FITMENT,
                              CandidateStages.OFFER_LATTER,
                              CandidateStages.OFFER_ACCEPTANCE,
                              CandidateStages.PRE_JOINING_CHECK_LIST,
                              CandidateStages.PRE_JOINING_VERIFICATION,
                              CandidateStages.JOINING_CONFIRMATION
                            ].contains(authProvider.candidateCurrentStage),
                            onPressed: () async {
                              if (getProfileCompletionPercentage(
                                          profileProvider: profileProvider)
                                      .round() <
                                  100) {
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
                                              "Please fill all mandatory fields from all the sections to move candidate to salary fitment stage"),
                                      onPressButton: () async {
                                        backToScreen(context: context);
                                      },
                                    );
                                  },
                                );
                              } else {
                                showOverlayLoader(context);
                                if (await profileProvider
                                    .changeCandidateStatusApiFunction(
                                        helper: helper,
                                        dataParameter: {
                                          "obApplicantId": currentLoginUserType ==
                                                  loginUserTypes.first
                                              ? authProvider
                                                      .currentUserAuthInfo!
                                                      .obApplicantId ??
                                                  ""
                                              : employerDashboardProvider
                                                      .selectedObApplicantID ??
                                                  "",
                                          "requisitionId":
                                              employerDashboardProvider
                                                  .selectedRequisitionID,
                                          "applicationStageId": 60,
                                          "actionCode": 0,
                                          "actionId": 1,
                                          "updatedBy": currentLoginUserType ==
                                                  loginUserTypes.first
                                              ? authProvider
                                                      .currentUserAuthInfo!
                                                      .obApplicantId ??
                                                  ""
                                              : "ADMIN",
                                          "source": "mobile"
                                        },
                                        context: context)) {
                                  setState(() {
                                    authProvider.candidateCurrentStage =
                                        CandidateStages.SALARY_FITMENT;
                                  });
                                  hideOverlayLoader();
                                } else {
                                  hideOverlayLoader();
                                }
                              }
                            },
                          ),
                        ),
                      if ((![
                            CandidateStages.SCREENING,
                            CandidateStages.SHORTLISTED,
                            CandidateStages.INTERVIEW,
                            CandidateStages.ASSESSMENT,
                            CandidateStages.OFFER_CHECK_LIST,
                            CandidateStages.OFFER_VERIFICATION,
                            CandidateStages.SALARY_FITMENT,
                            CandidateStages.OFFER_LATTER,
                            CandidateStages.OFFER_ACCEPTANCE,
                            CandidateStages.PRE_JOINING_CHECK_LIST,
                            CandidateStages.PRE_JOINING_VERIFICATION,
                            CandidateStages.JOINING_CONFIRMATION
                          ].contains(authProvider.candidateCurrentStage) ||
                          currentLoginUserType == loginUserTypes.first))
                        Container(
                          constraints: const BoxConstraints(minWidth: 350),
                          width: SizeConfig.screenWidth! * 0.20,
                          child: CommonMaterialButton(
                            title: !(currentLoginUserType ==
                                        loginUserTypes.first
                                    ? authProvider.applicantInformation!
                                            .isAuthBridgeDigitalSignatureEnabledInJK ??
                                        false
                                    : false)
                                ? helper.translateTextTitle(
                                        titleText: "Print Joining Kit") ??
                                    "-"
                                : helper.translateTextTitle(
                                        titleText:
                                            "E-Sign And Print Joining Kit") ??
                                    "-",
                            isButtonDisable: currentLoginUserType ==
                                    loginUserTypes.first
                                ? (authProvider.applicantInformation!
                                            .isAuthBridgeDigitalSignatureEnabledInJK ??
                                        false
                                    ? (profileProvider
                                            .candidateProfileStatusInformation!
                                            .candidateDetails!
                                            .iseSignedJKProceed ??
                                        false)
                                    : false)
                                : false,
                            onPressed: () async {
                              if (getProfileCompletionPercentage(
                                          profileProvider: profileProvider)
                                      .round() <
                                  100) {
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
                                              "Please fill all mandatory fields from all the sections to generate the Joining Kit"),
                                      onPressButton: () async {
                                        backToScreen(context: context);
                                      },
                                    );
                                  },
                                );
                              } else {
                                showOverlayLoader(context);
                                if (await profileProvider
                                    .getJoiningKitApiFunction(
                                        helper: helper,
                                        dataParameter: {
                                          "ObApplicantId": currentLoginUserType ==
                                                  loginUserTypes.first
                                              ? authProvider
                                                      .currentUserAuthInfo!
                                                      .obApplicantId ??
                                                  ""
                                              : employerDashboardProvider
                                                      .selectedObApplicantID ??
                                                  ""
                                        },
                                        context: context)) {
                                  if (profileProvider.joiningKitResponceData !=
                                      null) {
                                    if (currentLoginUserType ==
                                            loginUserTypes.first
                                        ? authProvider.applicantInformation!
                                                .isAuthBridgeDigitalSignatureEnabledInJK ??
                                            false
                                        : false) {
                                      if (await authProvider
                                          .submitSignatureForOfferAcceptanceApiFunction(
                                              requestData: {
                                            "signerEmail": authProvider
                                                    .applicantInformation!
                                                    .email ??
                                                "",
                                            "signerFirstName": authProvider
                                                .applicantInformation!
                                                .candidateFirstName,
                                            "signerLastName": authProvider
                                                .applicantInformation!
                                                .candidateLastName,
                                            "signerMiddleName": "",
                                            "signerPhone": authProvider
                                                .applicantInformation!.mobile,
                                            "moduleCode": "Recruitment",
                                            "subModuleCode": "JoiningKit",
                                            "documentUri": profileProvider
                                                    .joiningKitResponceData[
                                                "joiningKitFile"],
                                            "documentTitle": "Joining Kit",
                                            "signType": authProvider
                                                    .applicantInformation!
                                                    .signType ??
                                                ""
                                          },
                                              context: context)) {
                                        if (authProvider.signatureInformation !=
                                            null) {
                                          if (await authProvider
                                              .saveSignedInformationApiFunction(
                                                  context: context,
                                                  requestData: {
                                                "applicantID": authProvider
                                                        .currentUserAuthInfo!
                                                        .obApplicantId ??
                                                    "",
                                                "eSignedDocumentID": authProvider
                                                        .signatureInformation[
                                                    "documentId"],
                                                "isJK": true
                                              })) {
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
                                                      "An email has been sent to your registered email address ,${authProvider.applicantInformation!.email ?? ""} ,containing a document that requires your signature . Kindly proceed to sign the document and re-login to complete the process",
                                                  onPressButton: () async {
                                                    backToScreen(
                                                        context: context);
                                                    await Shared_Preferences
                                                        .clearAllPref();
                                                    SocketServices(context)
                                                        .disposeSocket();

                                                    moveToNextScreenWithRoute(
                                                        context: context,
                                                        routePath: AppRoutesPath
                                                            .LOGIN);
                                                  },
                                                );
                                              },
                                            );
                                          } else {
                                            hideOverlayLoader();
                                          }
                                        } else {
                                          hideOverlayLoader();
                                        }
                                      } else {
                                        hideOverlayLoader();
                                      }
                                    } else {
                                      hideOverlayLoader();
                                      if (profileProvider
                                              .joiningKitResponceData[
                                          "isJoiningKitSignatureEnabled"]) {
                                        moveToNextScreenWithRoute(
                                            context: context,
                                            routePath:
                                                AppRoutesPath.E_SiGNATURE);
                                      } else {
                                        launchUrlServiceFunction(
                                            context: context,
                                            url: profileProvider
                                                    .joiningKitResponceData[
                                                "joiningKitFile"]);
                                      }
                                    }
                                  } else {
                                    hideOverlayLoader();
                                  }
                                } else {
                                  hideOverlayLoader();
                                }
                              }
                            },
                          ),
                        ),

                      if ((![
                                CandidateStages.SCREENING,
                                CandidateStages.SHORTLISTED,
                                CandidateStages.INTERVIEW,
                                CandidateStages.ASSESSMENT,
                                CandidateStages.OFFER_CHECK_LIST,
                                CandidateStages.OFFER_VERIFICATION,
                                CandidateStages.SALARY_FITMENT,
                                CandidateStages.OFFER_LATTER,
                                CandidateStages.OFFER_ACCEPTANCE,
                                CandidateStages.PRE_JOINING_CHECK_LIST,
                                CandidateStages.PRE_JOINING_VERIFICATION,
                                CandidateStages.JOINING_CONFIRMATION
                              ].contains(authProvider.candidateCurrentStage) ||
                              currentLoginUserType == loginUserTypes.first) &&
                          (profileProvider.candidateProfileStatusInformation!
                                  .candidateDetails!.iseSignedJKProceed ??
                              false) &&
                          (authProvider.applicantInformation!
                                  .isAuthBridgeDigitalSignatureEnabledInJK ??
                              false))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Container(
                            constraints: const BoxConstraints(minWidth: 350),
                            width: SizeConfig.screenWidth! * 0.20,
                            child: CommonMaterialButton(
                              title: helper.translateTextTitle(
                                  titleText: "Download Joining Kit"),
                              onPressed: () async {
                                showOverlayLoader(context);
                                if (await profileProvider
                                    .getJoiningKitLatterAfterSignatureApiFunction(
                                        helper: helper,
                                        dataParameter: {
                                          "ObApplicantId": currentLoginUserType ==
                                                  loginUserTypes.first
                                              ? authProvider
                                                      .currentUserAuthInfo!
                                                      .obApplicantId ??
                                                  ""
                                              : employerDashboardProvider
                                                      .selectedObApplicantID ??
                                                  "",
                                          "eSignedDocumentID": profileProvider
                                                  .candidateProfileStatusInformation!
                                                  .candidateDetails!
                                                  .eSignedJKDocumentID ??
                                              "",
                                          "IseSignedDocumentDowanloded": profileProvider
                                                  .candidateProfileStatusInformation!
                                                  .candidateDetails!
                                                  .iseSignedJKDocumentDowanloded ??
                                              "false",
                                          "JKLetterFileName": profileProvider
                                              .candidateProfileStatusInformation!
                                              .candidateDetails!
                                              .jkLetterFileName,
                                          "_": DateTime.now()
                                              .toUtc()
                                              .millisecondsSinceEpoch
                                              .toString()
                                        },
                                        context: context)) {
                                  if (profileProvider
                                          .joiningKitDataAfterSignature !=
                                      null) {
                                    if (profileProvider
                                                .joiningKitDataAfterSignature[
                                            "signedStatus"] ==
                                        "Pending") {
                                      hideOverlayLoader();
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
                                            subTitle:
                                                "Document sign is pending, please sign document before download it.",
                                            onPressButton: () async {
                                              backToScreen(context: context);
                                            },
                                          );
                                        },
                                      );
                                    } else {
                                      hideOverlayLoader();
                                      launchUrlServiceFunction(
                                          context: context,
                                          url: profileProvider
                                                  .joiningKitDataAfterSignature[
                                              "letterURL"]);
                                    }
                                  } else {
                                    hideOverlayLoader();
                                  }
                                } else {
                                  hideOverlayLoader();
                                }
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            : Container(),
      );
    });
  }
}
