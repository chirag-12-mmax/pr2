// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
import 'package:onboarding_app/screens/candidate_module/candidate_providers/candidate_provider.dart';
import 'package:onboarding_app/screens/candidate_module/dashboard/dashboard_commons/list_tile_widget.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_common/profile_row_info_widget.dart';
import 'package:onboarding_app/widgets/build_logo_profile.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ApplicationStatusWebScreen extends StatefulWidget {
  const ApplicationStatusWebScreen({super.key});

  @override
  State<ApplicationStatusWebScreen> createState() =>
      _ApplicationStatusWebScreenState();
}

class _ApplicationStatusWebScreenState
    extends State<ApplicationStatusWebScreen> {
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
    final helper = Provider.of<GeneralHelper>(context, listen: false);
    await authProvider.getApplicantInformationApiFunction(
        context: context,
        authToken: authProvider.currentUserAuthInfo!.authToken ?? "",
        timestamp: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
        helper: helper);
    await candidateProvider.getCandidateApplicationStatusApiFunction(
      context: context,
      time: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer2(builder: (BuildContext context, GeneralHelper helper,
        AuthProvider authProvider, snapshot) {
      return Scaffold(
        backgroundColor: PickColors.bgColor,
        appBar: ([
          CandidateStages.SALARY_FITMENT,
          CandidateStages.SCREENING,
          CandidateStages.SHORTLISTED,
          CandidateStages.INTERVIEW,
          CandidateStages.ASSESSMENT,
          CandidateStages.OFFER_LATTER
        ].contains(authProvider.candidateCurrentStage ??
                CandidateStages.SALARY_FITMENT))
            ? checkPlatForm(context: context, platforms: [
                CustomPlatForm.TABLET,
                CustomPlatForm.TABLET_VIEW,
                CustomPlatForm.MOBILE,
                CustomPlatForm.MOBILE_VIEW,
                CustomPlatForm.MIN_MOBILE_VIEW,
                CustomPlatForm.MIN_MOBILE,
                CustomPlatForm.LARGE_LAPTOP_VIEW,
                CustomPlatForm.MIN_LAPTOP_VIEW,
                CustomPlatForm.WEB,
              ])
                ? AppBar(
                    elevation: 0,
                    backgroundColor: PickColors.whiteColor,
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    title: Text(
                        helper.translateTextTitle(
                                titleText: "Application Status") ??
                            "-",
                        style: CommonTextStyle().mainHeadingTextStyle),
                  )
                : null
            : null,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Consumer(builder: (BuildContext context,
                    CandidateProvider candidateProvider, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: SingleChildScrollView(
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
                                  children: [
                                    BuildLogoProfileImageWidget(
                                      //  height: 70,
                                      //   width: 70,
                                      borderRadius: BorderRadius.circular(12),
                                      imagePath: authProvider
                                              .applicantInformation!
                                              .applicantPhoto ??
                                          "",
                                      titleName: candidateProvider
                                              .candidateStageDetailData!
                                              .candidateDetails!
                                              .candidateFullName ??
                                          "-",
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
                                            candidateProvider
                                                    .candidateStageDetailData!
                                                    .candidateDetails!
                                                    .candidateFullName ??
                                                "-",
                                            style: CommonTextStyle()
                                                .subMainHeadingTextStyle,
                                          ),
                                          PickHeightAndWidth.height5,
                                          ProfileRowInfoWidget(
                                            icon: PickImages.profileAdd,
                                            title: candidateProvider
                                                    .candidateStageDetailData!
                                                    .candidateDetails!
                                                    .designation ??
                                                "-",
                                          ),
                                          PickHeightAndWidth.height5,
                                          ProfileRowInfoWidget(
                                            icon: PickImages.locationIcon,
                                            title: candidateProvider
                                                    .candidateStageDetailData!
                                                    .candidateDetails!
                                                    .location ??
                                                "-",
                                          ),
                                          PickHeightAndWidth.height5,
                                          ProfileRowInfoWidget(
                                            icon: PickImages.departmentIcon,
                                            title: candidateProvider
                                                    .candidateStageDetailData!
                                                    .candidateDetails!
                                                    .department ??
                                                "-",
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: PickColors.successColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 10,
                                        ),
                                        child: Text(
                                          helper.translateTextTitle(
                                                  titleText: "Applied") ??
                                              "-",
                                          style: CommonTextStyle()
                                              .textFieldLabelTextStyle
                                              .copyWith(
                                                color: PickColors.whiteColor,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: candidateProvider
                                      .candidateStageDetailData!
                                      .applicationStageDetails!
                                      .length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: 60,
                                          crossAxisCount: 1,
                                          crossAxisSpacing: 14,
                                          mainAxisSpacing: 14),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTitleWidget(
                                      trailingIcon: (candidateProvider
                                                  .candidateStageDetailData!
                                                  .applicationStageDetails![
                                                      index]
                                                  .status ??
                                              false)
                                          ? PickImages.trueButtonIcon
                                          : PickImages.falseButtonIcon,
                                      backGroundColor: PickColors.bgColor,
                                      onTap: () {},
                                      title: (candidateProvider
                                              .candidateStageDetailData!
                                              .applicationStageDetails![index]
                                              .applicationStageName ??
                                          "-"),
                                      leadingIcon: GlobalList
                                              .applicationStatusWebList[index]
                                          ["leadingIcon"],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (([
                            CandidateStages.SALARY_FITMENT,
                            CandidateStages.SCREENING,
                            CandidateStages.SHORTLISTED,
                            CandidateStages.INTERVIEW,
                            CandidateStages.ASSESSMENT,
                            CandidateStages.OFFER_LATTER
                          ].contains(authProvider.candidateCurrentStage ??
                              CandidateStages.SALARY_FITMENT)))
                            SizedBox(
                              height: SizeConfig.screenWidth! * 0.03,
                            ),
                          if (([
                            CandidateStages.SALARY_FITMENT,
                            CandidateStages.SCREENING,
                            CandidateStages.SHORTLISTED,
                            CandidateStages.INTERVIEW,
                            CandidateStages.ASSESSMENT,
                            CandidateStages.OFFER_LATTER
                          ].contains(authProvider.candidateCurrentStage ??
                              CandidateStages.SALARY_FITMENT)))
                            Container(
                              constraints: const BoxConstraints(minWidth: 350),
                              width: SizeConfig.screenWidth! * 0.20,
                              child: CommonMaterialButton(
                                title: helper.translateTextTitle(
                                        titleText: "Log Out") ??
                                    "-",
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CommonConfirmationDialogBox(
                                        title: helper.translateTextTitle(
                                            titleText: "Confirmation"),
                                        buttonTitle: helper.translateTextTitle(
                                            titleText: "Log Out"),
                                        subTitle: helper.translateTextTitle(
                                            titleText:
                                                "Are you sure you want to Logout ?"),
                                        onPressButton: () async {
                                          await Shared_Preferences
                                              .clearAllPref();

                                          moveToNextScreenWithRoute(
                                              context: context,
                                              routePath: AppRoutesPath.LOGIN);
                                        },
                                        isCancel: true,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
      );
    });
  }
}
