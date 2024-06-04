// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/date_formates.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/share_preference.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/offer_accept_dialog_box.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/auth_module/auth_views/acceptance_screen.dart';
import 'package:onboarding_app/screens/candidate_module/dashboard/dashboard_provider/dashboard_provider.dart';
import 'package:onboarding_app/screens/candidate_module/documents/documents_commons/remarks_dialog_box.dart';
import 'package:onboarding_app/services/socket_services.dart';
import 'package:onboarding_app/widgets/build_logo_profile.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';

class OfferAcceptWidget extends StatefulWidget {
  const OfferAcceptWidget({
    super.key,
  });

  @override
  State<OfferAcceptWidget> createState() => _OfferAcceptWidgetState();
}

class _OfferAcceptWidgetState extends State<OfferAcceptWidget> {
  bool isAccepted = false;
  String remarkString = "";

  @override
  Widget build(BuildContext context) {
    return Consumer3(builder: (BuildContext context,
        GeneralHelper helper,
        AuthProvider authProvider,
        DashboardProvider dashboardProvider,
        snapshot) {
      return isAccepted
          ? AcceptanceFlowWidget(
              remarkString: remarkString,
            )
          : Column(
              children: [
                if (authProvider.candidateCurrentStage ==
                        CandidateStages.POST_JOINING_CHECK_LIST
                    ? false
                    : authProvider
                            .applicantInformation!.isOfferExtensionEnabled ??
                        false)
                  Container(
                    color: PickColors.yellowColor.withOpacity(0.5),
                    width: SizeConfig.screenWidth,
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      (authProvider.applicantInformation!.offerExtensionStatus ==
                              null)
                          ? helper.translateTextTitle(
                                  titleText:
                                      "Kindly confirm acceptance of your offer before its expiry on") +
                              " " +
                              DateFormate.normalDateFormate
                                  .format(DateTime.fromMicrosecondsSinceEpoch(
                                (authProvider.applicantInformation!
                                            .offerExpiryDateTimestamp ??
                                        0) *
                                    1000000,
                              ).toUtc())
                          : ((authProvider.applicantInformation!.offerExtensionStatus
                                          .toString()
                                          .toLowerCase() ==
                                      "offerletterexpired") &&
                                  !(authProvider.applicantInformation!.requestedOfferExtension ??
                                      false))
                              ? helper.translateTextTitle(
                                      titleText:
                                          "Kindly confirm acceptance of your offer extension before its expiry on") +
                                  " " +
                                  DateFormate.normalDateFormate.format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                    (authProvider.applicantInformation!
                                                .offerExtensionDateTimestamp ??
                                            0) *
                                        1000000,
                                  ).toUtc())
                              : (authProvider.applicantInformation!.offerExtensionStatus
                                          .toString()
                                          .toLowerCase() ==
                                      "pendingforapproval")
                                  ? helper.translateTextTitle(
                                      titleText:
                                          "The request for an extension of the offer acceptance period is currently awaiting for approval.")
                                  : (authProvider.applicantInformation!.offerExtensionStatus
                                              .toString()
                                              .toLowerCase() ==
                                          "offerletterextensionexpired")
                                      ? helper.translateTextTitle(titleText: "The extension for the offer acceptance period has expired")
                                      : (authProvider.applicantInformation!.offerExtensionStatus.toString().toLowerCase() == "requestapproved")
                                          ? "Your offer extension period is valid until ${DateFormate.normalDateFormate.format(DateTime.fromMicrosecondsSinceEpoch(
                                              (authProvider
                                                          .applicantInformation!
                                                          .offerExtensionDateTimestamp ??
                                                      0) *
                                                  1000000,
                                            ).toUtc())}. Once it expires, you will no longer be able to proceed with offer acceptance."
                                          : "Your offer extension period is valid until ${DateFormate.normalDateFormate.format(DateTime.fromMicrosecondsSinceEpoch(
                                              (authProvider
                                                          .applicantInformation!
                                                          .offerExtensionDateTimestamp ??
                                                      0) *
                                                  1000000,
                                            ).toUtc())}. Once it expires, you will no longer be able to proceed with offer acceptance.",
                      style: CommonTextStyle().textFieldLabelTextStyle,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: PickColors.whiteColor,
                        ),
                        width: SizeConfig.screenWidth,
                        child: Column(
                          children: [
                            Text(
                              "${helper.translateTextTitle(titleText: "Welcome")} ${authProvider.applicantInformation!.candidateFirstName ?? ""}!",
                              style: CommonTextStyle()
                                  .mainHeadingTextStyle
                                  .copyWith(
                                    color: PickColors.blackColor,
                                  ),
                            ),
                            PickHeightAndWidth.height20,
                            Row(
                              children: [
                                Expanded(
                                  child: IgnorePointer(
                                    ignoring: (authProvider
                                            .applicantInformation!
                                            .isDownloadDisabled ??
                                        false),
                                    child: InkWell(
                                      onTap: () async {
                                        if (!(authProvider.applicantInformation!
                                                .isDownloadDisabled ??
                                            false)) {
                                          showOverlayLoader(context);
                                          if (await dashboardProvider
                                              .downloadOfferLatterApiFunction(
                                                  time: DateTime.now()
                                                      .millisecondsSinceEpoch
                                                      .toString(),
                                                  onlyGetURL: false,
                                                  context: context)) {
                                            hideOverlayLoader();
                                          } else {
                                            hideOverlayLoader();
                                          }
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: PickColors.bgColor,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(20),
                                            child: SvgPicture.asset(
                                              PickImages.downloadIcon,
                                              color: (authProvider
                                                          .applicantInformation!
                                                          .isDownloadDisabled ??
                                                      false)
                                                  ? PickColors.primaryColor
                                                      .withOpacity(0.3)
                                                  : PickColors.primaryColor,
                                              height: 20,
                                              width: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              authProvider.candidateCurrentStage ==
                                                      CandidateStages
                                                          .OFFER_ACCEPTANCE
                                                  ? "Download Offer Letter"
                                                  : "Download Appointment Letter",
                                              textAlign: TextAlign.center,
                                              style: CommonTextStyle()
                                                  .noteHeadingTextStyle
                                                  .copyWith(
                                                    color: (authProvider
                                                                .applicantInformation!
                                                                .isDownloadDisabled ??
                                                            false)
                                                        ? PickColors.blackColor
                                                            .withOpacity(0.5)
                                                        : PickColors.blackColor,
                                                  ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                PickHeightAndWidth.width15,
                                BuildLogoProfileImageWidget(
                                  height: 100,
                                  width: 100,
                                  borderRadius: BorderRadius.circular(70),
                                  imagePath: authProvider.applicantInformation!
                                          .applicantPhoto ??
                                      "",
                                  titleName:
                                      "${authProvider.applicantInformation?.candidateFirstName ?? ""} ${authProvider.applicantInformation!.candidateLastName ?? ""}",
                                ),
                                PickHeightAndWidth.width15,
                                Expanded(
                                  child: IgnorePointer(
                                    ignoring: !(authProvider
                                            .applicantInformation!
                                            .isSalaryBreakupVisible ??
                                        false),
                                    child: InkWell(
                                      onTap: () {
                                        moveToNextScreenWithRoute(
                                            context: context,
                                            routePath:
                                                AppRoutesPath.OFFER_DETAIL);
                                        final helper =
                                            Provider.of<GeneralHelper>(context,
                                                listen: false);
                                        //Change Selection Of Drawer When Back to Old Screen
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          helper.setSelectedDrawerPagePath(
                                              pagePath:
                                                  AppRoutesPath.OFFER_DETAIL);
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: PickColors.bgColor,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(20),
                                            child: SvgPicture.asset(
                                              PickImages.documentsIcon,
                                              color: !(authProvider
                                                          .applicantInformation!
                                                          .isSalaryBreakupVisible ??
                                                      false)
                                                  ? PickColors.primaryColor
                                                      .withOpacity(0.3)
                                                  : PickColors.primaryColor,
                                              height: 20,
                                              width: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text("View Salary Break-up",
                                              textAlign: TextAlign.center,
                                              style: CommonTextStyle()
                                                  .noteHeadingTextStyle
                                                  .copyWith(
                                                    color: !(authProvider
                                                                .applicantInformation!
                                                                .isSalaryBreakupVisible ??
                                                            false)
                                                        ? PickColors.blackColor
                                                            .withOpacity(0.5)
                                                        : PickColors.blackColor,
                                                  ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: -25,
                        child: SvgPicture.asset(
                          PickImages.likeIcon,
                          height: 50,
                          width: 50,
                        ),
                      )
                    ],
                  ),
                ),
                PickHeightAndWidth.height40,
                Text(
                  helper.translateTextTitle(titleText: "Congratulations!") ??
                      "-",
                  style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                        color: PickColors.primaryColor,
                      ),
                ),
                PickHeightAndWidth.height30,
                Text(
                  authProvider.applicantInformation!.welcomeMessage ?? "-",
                  textAlign: TextAlign.center,
                  style: CommonTextStyle().textFieldLabelTextStyle.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                ),
                // PickHeightAndWidth.height80,
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
                  child: Column(
                    children: [
                      if (authProvider.candidateCurrentStage ==
                              CandidateStages.OFFER_ACCEPTANCE
                          ? (authProvider.applicantInformation!
                                  .isAuthBridgeDigitalSignatureEnabledInOffer ??
                              false)
                          : (authProvider.applicantInformation!
                                  .isAuthBridgeDigitalSignatureEnabledInAppointment ??
                              false))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: CommonMaterialButton(
                            title: helper.translateTextTitle(
                                    titleText: "E-SIGN") ??
                                "-",
                            isButtonDisable: (authProvider.applicantInformation!
                                        .iseSignedProceed ??
                                    false) ||
                                (authProvider.applicantInformation!
                                        .iseSignedDocumentDowanloded ??
                                    false),
                            onPressed: () async {
                              showOverlayLoader(context);

                              if (await dashboardProvider
                                  .downloadOfferLatterApiFunction(
                                      time: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      onlyGetURL: true,
                                      context: context)) {
                                if (dashboardProvider.downloadedURl != null) {
                                  if (await authProvider
                                      .submitSignatureForOfferAcceptanceApiFunction(
                                          requestData: {
                                        "signerEmail": authProvider
                                                .applicantInformation!.email ??
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
                                        "subModuleCode": authProvider
                                                    .candidateCurrentStage ==
                                                CandidateStages.OFFER_ACCEPTANCE
                                            ? "OfferLetter"
                                            : "AppointmentLetter",
                                        "documentUri":
                                            dashboardProvider.downloadedURl,
                                        "documentTitle": authProvider
                                                    .candidateCurrentStage ==
                                                CandidateStages.OFFER_ACCEPTANCE
                                            ? "Offer Letter"
                                            : "Appointment Letter",
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
                                            "isJK": false
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
                                              title: helper.translateTextTitle(
                                                  titleText: "Alert"),
                                              subTitle:
                                                  "An email has been sent to your registered email address ,${authProvider.applicantInformation!.email ?? ""} ,containing a document that requires your signature . Kindly proceed to sign the document and re-login to complete the process",
                                              onPressButton: () async {
                                                backToScreen(context: context);
                                                await Shared_Preferences
                                                    .clearAllPref();
                                                SocketServices(context)
                                                    .disposeSocket();

                                                moveToNextScreenWithRoute(
                                                    context: context,
                                                    routePath:
                                                        AppRoutesPath.LOGIN);
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
                                }
                              } else {
                                hideOverlayLoader();
                              }
                            },
                          ),
                        ),
                      PickHeightAndWidth.height15,
                      Row(
                        children: [
                          Expanded(
                            child: CommonMaterialButton(
                              style: CommonTextStyle().buttonTextStyle.copyWith(
                                    color: PickColors.primaryColor,
                                  ),
                              borderColor: PickColors.primaryColor,
                              color: PickColors.whiteColor,
                              title: (helper.translateTextTitle(
                                          titleText: "Reject") ??
                                      "-") +
                                  " " +
                                  (authProvider.candidateCurrentStage ==
                                          CandidateStages.OFFER_ACCEPTANCE
                                      ? helper.translateTextTitle(
                                          titleText: "Offer")
                                      : helper.translateTextTitle(
                                          titleText: "Appointment")),
                              onPressed: () async {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return RemarksDialogBox(
                                        obApplicantId: authProvider
                                            .currentUserAuthInfo!.obApplicantId
                                            .toString());
                                  },
                                );
                              },
                            ),
                          ),
                          PickHeightAndWidth.width15,
                          Expanded(
                            child: CommonMaterialButton(
                              title: (helper.translateTextTitle(
                                          titleText: "Accept") ??
                                      "-") +
                                  " " +
                                  (authProvider.candidateCurrentStage ==
                                          CandidateStages.OFFER_ACCEPTANCE
                                      ? helper.translateTextTitle(
                                          titleText: "Offer")
                                      : helper.translateTextTitle(
                                          titleText: "Appointment")),
                              isButtonDisable: (authProvider.candidateCurrentStage ==
                                          CandidateStages.OFFER_ACCEPTANCE
                                      ? (authProvider.applicantInformation!
                                              .isAuthBridgeDigitalSignatureEnabledInOffer ??
                                          false)
                                      : (authProvider.applicantInformation!
                                              .isAuthBridgeDigitalSignatureEnabledInAppointment ??
                                          false))
                                  ? (!(authProvider.applicantInformation!.iseSignedProceed ?? false) ||
                                      !(authProvider.applicantInformation!
                                              .iseSignedDocumentDowanloded ??
                                          false))
                                  : (((authProvider.applicantInformation!.offerExtensionStatus ?? "").toString().toLowerCase() != "") &&
                                      (authProvider.applicantInformation!.offerExtensionStatus ?? "")
                                              .toString() !=
                                          "requestapproved" &&
                                      !(((authProvider.applicantInformation!.offerExtensionStatus ?? "")
                                                  .toString()
                                                  .toLowerCase() ==
                                              "offerletterexpired") &&
                                          (authProvider.applicantInformation!.requestedOfferExtension ?? false))),
                              onPressed: () async {
                                var result = await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return const OfferAcceptDialogBox();
                                  },
                                );
                                if (result != null) {
                                  if ((authProvider.candidateCurrentStage ==
                                          CandidateStages.OFFER_ACCEPTANCE
                                      ? (authProvider.applicantInformation!
                                              .isAcceptanceFlow ??
                                          false)
                                      : (authProvider.applicantInformation!
                                              .isAppointmentAcceptanceFlow ??
                                          false))) {
                                    setState(() {
                                      remarkString = result["remark"];
                                      isAccepted = true;
                                    });
                                  } else {
                                    showOverlayLoader(context);
                                    if (await authProvider
                                        .saveCandidateOfferDetailApiFunction(
                                            helper: helper,
                                            dataParameter: {
                                              "rejectReasonId": 0,
                                              "remark": result["remark"],
                                              "isDiscuss": false,
                                              "isReject": false,
                                              "uploadedDocument": ""
                                            },
                                            context: context)) {
                                      final helper = Provider.of<GeneralHelper>(
                                          context,
                                          listen: false);
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
                                      hideOverlayLoader();
                                    } else {
                                      hideOverlayLoader();
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      if (((authProvider.applicantInformation!
                                          .offerExtensionStatus ??
                                      "")
                                  .toString()
                                  .toLowerCase() !=
                              "") &&
                          (authProvider.applicantInformation!
                                          .offerExtensionStatus ??
                                      "")
                                  .toString() !=
                              "requestapproved" &&
                          !(((authProvider.applicantInformation!
                                              .offerExtensionStatus ??
                                          "")
                                      .toString()
                                      .toLowerCase() ==
                                  "offerletterexpired") &&
                              (authProvider.applicantInformation!
                                      .requestedOfferExtension ??
                                  false)))
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 15),
                          child: CommonMaterialButton(
                            title: helper.translateTextTitle(
                                    titleText: "REQUEST EXTENSION") ??
                                "-",
                            isButtonDisable: !((authProvider
                                        .applicantInformation!
                                        .offerExtensionStatus)
                                    .toString()
                                    .toLowerCase() ==
                                "offerletterexpired"),
                            onPressed: () async {
                              showOverlayLoader(context);

                              if (await authProvider
                                  .requestForOfferExtensionApiFunction(
                                      dataParameter: {},
                                      context: context,
                                      helper: helper)) {
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

                                hideOverlayLoader();
                              } else {
                                hideOverlayLoader();
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
    });
  }
}
