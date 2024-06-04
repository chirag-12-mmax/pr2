import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/date_formates.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/auth_module/auth_views/offer_acceptance.dart';
import 'package:onboarding_app/screens/auth_module/auth_views/proceed_screen.dart';
import 'package:onboarding_app/screens/candidate_module/dashboard/dashboard_commons/list_tile_widget.dart';
import 'package:onboarding_app/screens/candidate_module/dashboard/dashboard_commons/status_widget.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_common/profile_row_info_widget.dart';
import 'package:onboarding_app/widgets/build_logo_profile.dart';
import 'package:provider/provider.dart';

@RoutePage()
class WEbDashboardScreen extends StatefulWidget {
  const WEbDashboardScreen({super.key});

  @override
  State<WEbDashboardScreen> createState() => _WEbDashboardScreenState();
}

class _WEbDashboardScreenState extends State<WEbDashboardScreen> {
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
    SizeConfig().init(context);
    return Consumer2(builder: (BuildContext context, AuthProvider authProvider,
        GeneralHelper helper, snapshot) {
      return Scaffold(
        backgroundColor: PickColors.bgColor,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: authProvider.candidateCurrentStage ==
                              CandidateStages.OFFER_ACCEPTANCE ||
                          (authProvider.candidateCurrentStage ==
                                  CandidateStages.POST_JOINING_CHECK_LIST
                              ? (authProvider.applicantInformation!
                                              .offerStatus ??
                                          "")
                                      .toString()
                                      .trim() ==
                                  ""
                              : false)
                      ? authProvider.isForFirstTime
                          ? const ProceedToWidget()
                          : const OfferAcceptWidget()
                      : (authProvider.candidateCurrentStage ==
                                  CandidateStages.OFFER_CHECK_LIST ||
                              authProvider.candidateCurrentStage ==
                                  CandidateStages.OFFER_VERIFICATION)
                          ? const ProceedToWidget()
                          : Column(
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
                                        children: [
                                          BuildLogoProfileImageWidget(
                                            height: 60,
                                            width: 60,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            imagePath: authProvider
                                                    .applicantInformation!
                                                    .applicantPhoto ??
                                                "",
                                            titleName:
                                                "${authProvider.applicantInformation!.candidateFirstName ?? ""} ${authProvider.applicantInformation!.candidateLastName ?? ""}",
                                          ),
                                          PickHeightAndWidth.width15,
                                          Expanded(
                                            flex: checkPlatForm(
                                                    context: context,
                                                    platforms: [
                                                  CustomPlatForm
                                                      .MIN_LAPTOP_VIEW,
                                                  CustomPlatForm
                                                      .LARGE_LAPTOP_VIEW
                                                ])
                                                ? 1
                                                : 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${helper.translateTextTitle(titleText: "Welcome")}!",
                                                  style: CommonTextStyle()
                                                      .noteHeadingTextStyle,
                                                ),
                                                PickHeightAndWidth.height5,
                                                Text(
                                                  "${authProvider.applicantInformation!.candidateFirstName ?? ""} ${authProvider.applicantInformation!.candidateLastName ?? ""}",
                                                  style: CommonTextStyle()
                                                      .subMainHeadingTextStyle,
                                                )
                                              ],
                                            ),
                                          ),
                                          if (checkPlatForm(
                                              context: context,
                                              platforms: [
                                                CustomPlatForm.WEB,
                                                CustomPlatForm.MIN_LAPTOP_VIEW,
                                                CustomPlatForm.LARGE_LAPTOP_VIEW
                                              ]))
                                            const Expanded(
                                                child: StatusWidget()),
                                        ],
                                      ),
                                      if (checkPlatForm(
                                          context: context,
                                          platforms: [
                                            CustomPlatForm.MOBILE_VIEW,
                                            CustomPlatForm.TABLET_VIEW,
                                            CustomPlatForm.MOBILE,
                                            CustomPlatForm.TABLET,
                                            CustomPlatForm.MIN_MOBILE_VIEW,
                                            CustomPlatForm.MIN_MOBILE,
                                          ]))
                                        PickHeightAndWidth.height20,
                                      if (checkPlatForm(
                                          context: context,
                                          platforms: [
                                            CustomPlatForm.MOBILE_VIEW,
                                            CustomPlatForm.TABLET_VIEW,
                                            CustomPlatForm.MOBILE,
                                            CustomPlatForm.MIN_MOBILE_VIEW,
                                            CustomPlatForm.MIN_MOBILE,
                                          ]))
                                        const StatusWidget(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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

                                      // Text(
                                      //   authProvider.applicantInformation!
                                      //           .designation ??
                                      //       "",
                                      //   style: CommonTextStyle()
                                      //       .subMainHeadingTextStyle,
                                      // ),
                                      // PickHeightAndWidth.height5,
                                      // Text(
                                      //   DateFormate.displayDateFormate.format(
                                      //       DateTime.parse(authProvider
                                      //               .applicantInformation!
                                      //               .dateOfJoining ??
                                      //           "")),
                                      //   style: CommonTextStyle()
                                      //       .noteHeadingTextStyle,
                                      // ),
                                      // PickHeightAndWidth.height5,
                                      Divider(
                                        color: PickColors.bgColor,
                                        thickness: 2,
                                      ),
                                      PickHeightAndWidth.height15,
                                      GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            GlobalList.drawerMenuLists.length -
                                                2,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                mainAxisExtent: 55,
                                                crossAxisCount: checkPlatForm(
                                                        context: context,
                                                        platforms: [
                                                      CustomPlatForm
                                                          .TABLET_VIEW,
                                                      CustomPlatForm
                                                          .MIN_LAPTOP_VIEW,
                                                      CustomPlatForm.TABLET,
                                                    ])
                                                    ? 2
                                                    : checkPlatForm(
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
                                                        ? 1
                                                        : 3,
                                                crossAxisSpacing: 14,
                                                mainAxisSpacing: 14),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          //Remove First two menu
                                          index += 2;
                                          return ListTitleWidget(
                                            trailingIcon: PickImages.arrowIcon,
                                            backGroundColor: PickColors.bgColor,
                                            title: GlobalList
                                                    .drawerMenuLists[index]
                                                ["title"],
                                            leadingIcon: GlobalList
                                                .drawerMenuLists[index]["icon"],
                                            onTap: () {
                                              if (GlobalList.drawerMenuLists[
                                                      index]["path"] !=
                                                  null) {
                                                moveToNextScreenWithRoute(
                                                    context: context,
                                                    routePath: GlobalList
                                                            .drawerMenuLists[
                                                        index]["path"]);
                                              }
                                              final helper =
                                                  Provider.of<GeneralHelper>(
                                                      context,
                                                      listen: false);
                                              //Change Selection Of Drawer When Back to Old Screen
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                helper.setSelectedDrawerPagePath(
                                                    pagePath: GlobalList
                                                            .drawerMenuLists[
                                                        index]["path"]);
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                ),
              ),
      );
    });
  }
}
