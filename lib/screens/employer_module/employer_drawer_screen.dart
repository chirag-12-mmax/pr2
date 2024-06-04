// ignore_for_file: use_build_context_synchronously
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
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/auth_module/auth_services/logout_service.dart';
import 'package:onboarding_app/screens/employer_module/employer_provider/dashboard_provider.dart';
import 'package:onboarding_app/services/socket_services.dart';
import 'package:onboarding_app/widgets/build_logo_profile.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';

class EmployerDrawerScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> employerScaffoldKey;

  const EmployerDrawerScreen({
    Key? key,
    required this.employerScaffoldKey,
  }) : super(key: key);

  @override
  State<EmployerDrawerScreen> createState() => _EmployerDrawerScreenState();
}

class _EmployerDrawerScreenState extends State<EmployerDrawerScreen> {
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
    final employerDashboardProvider =
        Provider.of<EmployerDashboardProvider>(context, listen: false);

    await employerDashboardProvider.getSystemConfigApiFunction(
      context: context,
      dataParameter: {
        "SubscriptionName": currentLoginUserType == loginUserTypes.first
            ? authProvider.currentUserAuthInfo!.subscriptionId ?? ""
            : authProvider.employerLoginData!.subscriptionId ?? ""
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3(builder: (BuildContext context,
        GeneralHelper helper,
        EmployerDashboardProvider employerDashboardProvider,
        AuthProvider authProvider,
        snapshot) {
      printDebug(
          textString:
              "===============My Drawer================${helper.selectedEmployerDrawerPagePath}");
      if (helper.selectedEmployerDrawerPagePath
          .toString()
          .contains("candidate-profile-screen")) {
        helper.selectedEmployerDrawerPagePath = AppRoutesPath.CANDIDATE_UPLOAD;
      }
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
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: GlobalList.employerDrawerMenuLists.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Column(
                              children: [
                                if (index == 0)
                                  DrawerHeader(
                                    child: employerDashboardProvider
                                                .employerConfiguration !=
                                            null
                                        ? BuildLogoProfileImageWidget(
                                            fit: BoxFit.contain,
                                            width: 170,
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            imagePath: employerDashboardProvider
                                                    .employerConfiguration!
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
                                  onTap: () {
                                    moveToNextScreenWithRoute(
                                      context: context,
                                      routePath: GlobalList
                                              .employerDrawerMenuLists[index]
                                          ["path"],
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
                                      widget.employerScaffoldKey.currentState!
                                          .closeDrawer();
                                    }

                                    helper.setSelectedEmployerDrawerPagePath(
                                        pagePath: GlobalList
                                                .employerDrawerMenuLists[index]
                                            ["path"]);
                                  },
                                  leading: SvgPicture.asset(
                                    GlobalList.employerDrawerMenuLists[index]
                                        ["icon"],
                                    color: GlobalList.employerDrawerMenuLists[
                                                index]["path"] ==
                                            helper
                                                .selectedEmployerDrawerPagePath
                                        ? PickColors.primaryColor
                                        : PickColors.blackColor,
                                    height: 25,
                                    width: 25,
                                  ),
                                  title: Text(
                                    GlobalList.employerDrawerMenuLists[index]
                                            ["title"] ??
                                        "-",
                                    style: CommonTextStyle()
                                        .noteHeadingTextStyle
                                        .copyWith(
                                          fontWeight: GlobalList
                                                          .employerDrawerMenuLists[
                                                      index]["path"] ==
                                                  helper
                                                      .selectedEmployerDrawerPagePath
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: GlobalList
                                                          .employerDrawerMenuLists[
                                                      index]["path"] ==
                                                  helper
                                                      .selectedEmployerDrawerPagePath
                                              ? PickColors.primaryColor
                                              : PickColors.blackColor,
                                          overflow: TextOverflow.visible,
                                        ),
                                  ),
                                  trailing: Container(
                                    height: 30,
                                    width: 3,
                                    decoration: BoxDecoration(
                                        color: GlobalList
                                                        .employerDrawerMenuLists[
                                                    index]["path"] ==
                                                helper
                                                    .selectedEmployerDrawerPagePath
                                            ? PickColors.primaryColor
                                            : PickColors.whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  //  title: Text("${GlobalList.employerDrawerMenuLists[index]["title"]}"
                                  //  ,
                                  //    style: CommonTextStyle()
                                  //           .noteHeadingTextStyle
                                  //           .copyWith(
                                  //             fontWeight: GlobalList.employerDrawerMenuLists[
                                  //                         index]["path"] ==
                                  //                     helper
                                  //                         .selectedEmployerDrawerPagePath
                                  //                 ? FontWeight.bold
                                  //                 : FontWeight.normal,
                                  //             color: GlobalList.employerDrawerMenuLists[
                                  //                         index]["path"] ==
                                  //                     helper
                                  //                         .selectedEmployerDrawerPagePath
                                  //                 ? PickColors.primaryColor
                                  //                 : PickColors.hintColor,
                                  //             overflow: TextOverflow.visible,
                                  //           ),
                                ),
                              ],
                            ),
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
                          padding: EdgeInsets.all(10),
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
                              Text(
                                helper.translateTextTitle(
                                        titleText: "Log Out") ??
                                    "-",
                                style: CommonTextStyle()
                                    .noteHeadingTextStyle
                                    .copyWith(
                                      color: PickColors.primaryColor,
                                      overflow: TextOverflow.visible,
                                    ),
                              )
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
                          // child: SvgPicture.network(
                          child: Image.asset(
                            PickImages.zingHrLogo,
                            height: 25,
                            width: 25,
                            // alignment: Alignment.centerLeft,
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
