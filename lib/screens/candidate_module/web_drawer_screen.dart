// ignore_for_file: use_build_context_synchronously
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/api_info/api_routes.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/share_preference.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/auth_module/auth_services/logout_service.dart';
import 'package:onboarding_app/services/socket_services.dart';
import 'package:onboarding_app/widgets/build_logo_profile.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DrawerScreen({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final helper = Provider.of<GeneralHelper>(context, listen: false);

    await authProvider.getApplicantInformationApiFunction(
        context: context,
        authToken: authProvider.currentUserAuthInfo!.authToken ?? "",
        timestamp: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
        helper: helper);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2(builder: (BuildContext context, GeneralHelper helper,
        AuthProvider authProvider, snapshot) {
      return SingleChildScrollView(
        child: Container(
          height: SizeConfig.screenHeight,
          decoration: BoxDecoration(
            color: PickColors.whiteColor,
            border: Border(
              right: BorderSide(
                color: PickColors.hintColor.withOpacity(0.4),
                width: 1,
              ),
            ),
          ),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: GlobalList.drawerMenuLists.length,
                        itemBuilder: ((context, index) {
                          if (GlobalList.drawerMenuLists[index]["pageIndex"] ==
                              1) {
                            GlobalList.drawerMenuLists[index] = {
                              "title":
                                  (authProvider.candidateCurrentStage ==
                                              CandidateStages
                                                  .POST_JOINING_CHECK_LIST ||
                                          authProvider.candidateCurrentStage ==
                                              CandidateStages
                                                  .POST_JOINING_VERIFICATION ||
                                          authProvider.candidateCurrentStage ==
                                              CandidateStages.COMPLETION)
                                      ? helper.translateTextTitle(
                                          titleText: "Appointment Details")
                                      : helper.translateTextTitle(
                                          titleText: "Offer Details"),
                              "path": AppRoutesPath.OFFER_DETAIL,
                              "icon": PickImages.offerIcon,
                              "pageIndex": 1
                            };
                          }
                          // if (index != GlobalList.drawerMenuLists.length) {
                          bool isActive = (authProvider.candidateCurrentStage ==
                                      CandidateStages.OFFER_CHECK_LIST ||
                                  authProvider.candidateCurrentStage ==
                                      CandidateStages.OFFER_VERIFICATION)
                              ? !([
                                  AppRoutesPath.DASHBOARD,
                                  AppRoutesPath.OFFER_DETAIL,
                                  AppRoutesPath.CONNECT,
                                  AppRoutesPath.WEB_CANDIDATE_PROFILE_SCREEN
                                ].contains(
                                  GlobalList.drawerMenuLists[index]["path"]))
                              : (GlobalList.drawerMenuLists[index]
                                          ["pageIndex"] ==
                                      1)
                                  ? (authProvider.applicantInformation!
                                          .isSalaryBreakupVisible ??
                                      false)
                                  : true;

                          bool isPendingAccept = (authProvider
                                          .candidateCurrentStage ==
                                      CandidateStages.OFFER_ACCEPTANCE) ||
                                  (authProvider.candidateCurrentStage ==
                                          CandidateStages
                                              .POST_JOINING_CHECK_LIST
                                      ? (authProvider.applicantInformation!
                                                      .offerStatus ??
                                                  "")
                                              .toString()
                                              .trim() ==
                                          ""
                                      : false)
                              ? !([
                                  AppRoutesPath.DASHBOARD,
                                  AppRoutesPath.OFFER_DETAIL,
                                  AppRoutesPath.COMPANY_INFO
                                ].contains(
                                  GlobalList.drawerMenuLists[index]["path"]))
                              : false;
                          return Column(
                            children: [
                              if (index == 0)
                                DrawerHeader(
                                  child:
                                      authProvider.applicantInformation != null
                                          ? BuildLogoProfileImageWidget(
                                              fit: BoxFit.contain,
                                              width: 170,
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              imagePath: authProvider
                                                      .applicantInformation!
                                                      .companyLogo ??
                                                  "-",
                                              titleName: "",
                                            )
                                          : Container(),
                                ),
                              ListTile(
                                contentPadding: const EdgeInsets.only(
                                  left: 20,
                                ),
                                onTap: () async {
                                  if (isPendingAccept) {
                                    await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return CommonConfirmationDialogBox(
                                          buttonTitle:
                                              helper.translateTextTitle(
                                                      titleText: "Okay") ??
                                                  "-",
                                          title: helper.translateTextTitle(
                                                  titleText: "Alert") ??
                                              "-",
                                          subTitle: authProvider
                                                      .candidateCurrentStage ==
                                                  CandidateStages
                                                      .POST_JOINING_CHECK_LIST
                                              ? helper.translateTextTitle(
                                                  titleText:
                                                      "Am sorry, but you need to accept the offer to proceed ahead")
                                              : helper.translateTextTitle(
                                                  titleText:
                                                      "Am sorry, but you need to accept the offer to proceed ahead"),

                                          // "Am sorry, but you need to accept the  ${(authProvider.candidateCurrentStage == CandidateStages.POST_JOINING_CHECK_LIST) ? "appointment letter" : "offer"} to proceed ahead",
                                          onPressButton: () async {
                                            backToScreen(context: context);
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    if (isActive) {
                                      if (context.router.currentPath
                                              .split("/")
                                              .last !=
                                          GlobalList.drawerMenuLists[index]
                                              ["path"]) {
                                        print(
                                            "=======${context.router.currentPath} :${GlobalList.drawerMenuLists[index]["path"]}}");
                                        moveToNextScreenWithRoute(
                                          context: context,
                                          routePath: GlobalList
                                              .drawerMenuLists[index]["path"],
                                        );

                                        if (checkPlatForm(
                                            context: context,
                                            platforms: [
                                              CustomPlatForm.MOBILE_VIEW,
                                              CustomPlatForm.TABLET_VIEW,
                                              CustomPlatForm.MOBILE,
                                              CustomPlatForm.MIN_MOBILE_VIEW,
                                              CustomPlatForm.MIN_MOBILE,
                                            ])) {
                                          widget.scaffoldKey.currentState!
                                              .closeDrawer();
                                        }

                                        helper.setSelectedDrawerPagePath(
                                            pagePath: GlobalList
                                                    .drawerMenuLists[index]
                                                ["path"]);
                                      }
                                    }
                                  }
                                },
                                leading: SvgPicture.asset(
                                  GlobalList.drawerMenuLists[index]["icon"],
                                  color: GlobalList.drawerMenuLists[index]
                                              ["path"] ==
                                          helper.selectedDrawerPagePath
                                      ? PickColors.primaryColor
                                      : isActive
                                          ? PickColors.blackColor
                                          : PickColors.blackColor
                                              .withOpacity(0.5),
                                  height: 25,
                                  width: 25,
                                ),
                                title: Text(
                                  GlobalList.drawerMenuLists[index]["title"] ??
                                      "-",
                                  style: CommonTextStyle()
                                      .noteHeadingTextStyle
                                      .copyWith(
                                        fontWeight: GlobalList
                                                        .drawerMenuLists[index]
                                                    ["path"] ==
                                                helper.selectedDrawerPagePath
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: GlobalList.drawerMenuLists[index]
                                                    ["path"] ==
                                                helper.selectedDrawerPagePath
                                            ? PickColors.primaryColor
                                            : isActive
                                                ? PickColors.blackColor
                                                : PickColors.blackColor
                                                    .withOpacity(0.5),
                                        overflow: TextOverflow.visible,
                                      ),
                                ),
                                trailing: Container(
                                  height: 30,
                                  width: 3,
                                  decoration: BoxDecoration(
                                      color: GlobalList.drawerMenuLists[index]
                                                  ["path"] ==
                                              helper.selectedDrawerPagePath
                                          ? PickColors.primaryColor
                                          : PickColors.whiteColor,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await logoutFromAppFunction(
                            context: context,
                            helper: helper,
                            authProvider: authProvider);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                            color: PickColors.primaryColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                PickImages.logoutIcon,
                                color: PickColors.primaryColor,
                                height: 25,
                                width: 25,
                              ),
                              PickHeightAndWidth.width10,
                              Expanded(
                                child: Text(
                                  helper.translateTextTitle(
                                          titleText: "Log Out") ??
                                      "-",
                                  style: CommonTextStyle()
                                      .noteHeadingTextStyle
                                      .copyWith(
                                        color: PickColors.primaryColor,
                                        overflow: TextOverflow.visible,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    PickHeightAndWidth.height10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              helper.translateTextTitle(
                                      titleText: "Powered by") ??
                                  "",
                              style: CommonTextStyle()
                                  .noteHeadingTextStyle
                                  .copyWith(
                                    color: PickColors.blackColor,
                                    fontFamily: "Cera Pro",
                                  ),
                            ),
                          ),
                        ),
                        // PickHeightAndWidth.width10,
                        Expanded(
                          child: Image.asset(
                            PickImages.zingHrLogo,
                            height: 25,
                            width: 25,
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ],
                    ),
                    PickHeightAndWidth.height10,
                  ],
                ),
        ),
      );
    });
  }
}
