import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/rich_text_widget.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/dashboard/dashboard_provider/dashboard_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class StatusWidget extends StatefulWidget {
  const StatusWidget({super.key});
  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  double percent = 80;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer3(
      builder: (BuildContext context, AuthProvider authProvider,
          DashboardProvider dashboardProvider, GeneralHelper helper, snapshot) {
        return Container(
          decoration: BoxDecoration(
            color: PickColors.bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth! * 0.01 < 15
                    ? 15
                    : SizeConfig.screenWidth! * 0.01,
                vertical: 10),
            child: Row(
              children: [
                CircularPercentIndicator(
                  radius: SizeConfig.screenWidth! * 0.017 < 25
                      ? 25
                      : SizeConfig.screenWidth! * 0.017,
                  lineWidth: SizeConfig.screenWidth! * 0.002 < 6.0
                      ? 6.0
                      : SizeConfig.screenWidth! * 0.002,
                  animation: true,
                  percent: (DateTime.now()
                          .toLocal()
                          .difference(DateTime.parse(authProvider
                                  .applicantInformation!.dateOfJoining
                                  .toString())
                              .toLocal())
                          .inDays
                          .abs()) /
                      100,
                  center: DottedBorder(
                    borderType: BorderType.Circle,
                    color: PickColors.primaryColor,
                    dashPattern: const [3, 1],
                    child: Container(
                      height: SizeConfig.screenWidth! * 0.02 < 25
                          ? 25
                          : SizeConfig.screenWidth! * 0.02,
                      width: SizeConfig.screenWidth! * 0.02 < 25
                          ? 25
                          : SizeConfig.screenWidth! * 0.02,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                    ),
                  ),
                  backgroundColor: PickColors.primaryColor.withOpacity(0.3),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: PickColors.primaryColor,
                ),
                SizedBox(
                  width: SizeConfig.width17,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichTextWidget(
                      mainTitle: (DateTime.now()
                                  .toLocal()
                                  .difference(DateTime.parse(authProvider
                                          .applicantInformation!.dateOfJoining
                                          .toString())
                                      .toLocal())
                                  .inDays
                                  .abs() +
                              1)
                          .toString(),
                      mainTitleStyle: CommonTextStyle().subMainHeadingTextStyle,
                      subTitle: helper.translateTextTitle(
                          titleText: DateTime.now()
                                      .toLocal()
                                      .difference(DateTime.parse(authProvider
                                              .applicantInformation!
                                              .dateOfJoining
                                              .toString())
                                          .toLocal())
                                      .inDays <
                                  0
                              ? " Days to Join"
                              : " days of joining"),
                      subTitleStyle: CommonTextStyle().textFieldLabelTextStyle,
                    ),
                  ),
                ),
                if (checkPlatForm(context: context, platforms: [
                  CustomPlatForm.MOBILE,
                  CustomPlatForm.MOBILE_VIEW,
                ]))
                  PickHeightAndWidth.width15,
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth! * 0.002 < 8
                          ? 15
                          : SizeConfig.screenWidth! * 0.002,
                      vertical: 8),
                  decoration: BoxDecoration(
                      color: PickColors.whiteColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      IgnorePointer(
                        ignoring: (authProvider
                                .applicantInformation!.isDownloadDisabled ??
                            false),
                        child: InkWell(
                          onTap: () async {
                            if (!(authProvider
                                    .applicantInformation!.isDownloadDisabled ??
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
                          child: SvgPicture.asset(
                            PickImages.downloadIcon,
                            color: (authProvider.applicantInformation!
                                        .isDownloadDisabled ??
                                    false)
                                ? PickColors.hintColor
                                : PickColors.primaryColor,
                            height: 15,
                            width: 15,
                          ),
                        ),
                      ),
                      PickHeightAndWidth.width15,
                      InkWell(
                        onTap: () {
                          moveToNextScreenWithRoute(
                              context: context,
                              routePath: AppRoutesPath.OFFER_DETAIL);
                          final helper = Provider.of<GeneralHelper>(context,
                              listen: false);
                          //Change Selection Of Drawer When Back to Old Screen
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            helper.setSelectedDrawerPagePath(
                                pagePath: AppRoutesPath.OFFER_DETAIL);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          // decoration: BoxDecoration(
                          //   color: PickColors.bgColor,
                          //   borderRadius: BorderRadius.circular(25),
                          // ),
                          child: SvgPicture.asset(
                            PickImages.documentsIcon,
                            color: PickColors.primaryColor,
                            height: 15,
                            width: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
