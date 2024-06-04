import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/navigation/app_router.gr.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/employer_module/employer_provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

@RoutePage()
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  bool isLoading = false;

  initialization() async {
    setState(() {
      isLoading = true;
    });
    final employDashboardProvider =
        Provider.of<EmployerDashboardProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await employDashboardProvider.getStatisticsEmployeeWiseApiFunction(
      context: context,
      dataParameter: {
        "EmployeeCode": authProvider.employerLoginData!.employCode.toString(),
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PickColors.bgColor,
      body: Consumer2(builder: (BuildContext context, GeneralHelper helper,
          EmployerDashboardProvider employerDashboardProvider, snapshot) {
        return isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: PickColors.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            moveToNextScreenWithRoute(
                              context: context,
                              routePath: AppRoutesPath.CANDIDATE_UPLOAD,
                            );
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              helper.setSelectedEmployerDrawerPagePath(
                                  pagePath: AppRoutesPath.CANDIDATE_UPLOAD);
                            });
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  (employerDashboardProvider
                                                  .totalCandidatesData ??
                                              "") !=
                                          ""
                                      ? "${employerDashboardProvider.totalCandidatesData}  ${helper.translateTextTitle(titleText: "Total Active Candidates")}"
                                      : "-",
                                  // helper.translateTextTitle(titleText: ).statistics ?? "-",
                                  style: CommonTextStyle()
                                      .mainHeadingTextStyle
                                      .copyWith(
                                        fontSize: 20,
                                      ),
                                ),
                              ),
                              PickHeightAndWidth.width15,
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: PickColors.primaryColor,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                        PickHeightAndWidth.height15,
                        Divider(
                          color: Colors.grey.withOpacity(0.3),
                          thickness: 1,
                        ),
                        PickHeightAndWidth.height50,
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 400,
                                child: PieChart(
                                  PieChartData(
                                    startDegreeOffset: 328.0,
                                    sectionsSpace: 00.0,
                                    centerSpaceRadius: 100,
                                    centerSpaceColor: PickColors.whiteColor,
                                    sections: List.generate(
                                        GlobalList.statisticsDataList.length,
                                        (index) {
                                      return PieChartSectionData(
                                        showTitle: false,
                                        color: GlobalList
                                            .statisticsDataList[index]["color"],
                                        value: employerDashboardProvider
                                                    .statisticsEmployData !=
                                                null
                                            ? double.tryParse(
                                                    employerDashboardProvider
                                                        .statisticsEmployData[
                                                            GlobalList
                                                                    .statisticsDataList[
                                                                index]["key"]]
                                                        .toString()) ??
                                                0
                                            : 0,
                                        radius: 50,
                                        titleStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: PickColors.whiteColor,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                            if (!checkPlatForm(context: context, platforms: [
                              CustomPlatForm.TABLET,
                              CustomPlatForm.MOBILE,
                              CustomPlatForm.MOBILE_VIEW,
                              CustomPlatForm.TABLET_VIEW,
                              CustomPlatForm.MIN_MOBILE_VIEW,
                              CustomPlatForm.MIN_MOBILE,
                            ]))
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: PickColors.hintColor, width: 1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        GlobalList.statisticsDataList.length,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          moveToNextScreen(
                                              context: context,
                                              pageRoute: CandidateUploadScreen(
                                                  selectedStageId: GlobalList
                                                          .statisticsDataList[
                                                      index]["stageId"]));
                                          helper
                                              .setSelectedEmployerDrawerPagePath(
                                                  pagePath: AppRoutesPath
                                                      .CANDIDATE_UPLOAD);
                                        },
                                        child: StatisticsDashboardDataWidget(
                                          index: index,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                          ],
                        ),
                        if (checkPlatForm(context: context, platforms: [
                          CustomPlatForm.TABLET,
                          CustomPlatForm.MOBILE,
                          CustomPlatForm.MOBILE_VIEW,
                          CustomPlatForm.TABLET_VIEW,
                          CustomPlatForm.MIN_MOBILE_VIEW,
                          CustomPlatForm.MIN_MOBILE,
                        ]))
                          PickHeightAndWidth.height30,
                        if (checkPlatForm(context: context, platforms: [
                          CustomPlatForm.TABLET,
                          CustomPlatForm.MOBILE,
                          CustomPlatForm.MOBILE_VIEW,
                          CustomPlatForm.TABLET_VIEW,
                          CustomPlatForm.MIN_MOBILE_VIEW,
                          CustomPlatForm.MIN_MOBILE,
                        ]))
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: PickColors.hintColor, width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: GlobalList.statisticsDataList.length,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    moveToNextScreen(
                                        context: context,
                                        pageRoute: CandidateUploadScreen(
                                            selectedStageId: GlobalList
                                                    .statisticsDataList[index]
                                                ["stageId"]));
                                    helper.setSelectedEmployerDrawerPagePath(
                                        pagePath:
                                            AppRoutesPath.CANDIDATE_UPLOAD);
                                  },
                                  child: StatisticsDashboardDataWidget(
                                    index: index,
                                  ),
                                );
                              },
                            ),
                          ),
                        PickHeightAndWidth.height50,
                      ],
                    ),
                  ),
                ),
              );
      }),
    );
  }
}

class StatisticsDashboardDataWidget extends StatelessWidget {
  const StatisticsDashboardDataWidget({
    super.key,
    this.index,
  });

  final int? index;
  @override
  Widget build(BuildContext context) {
    return Consumer2(builder: (BuildContext context, GeneralHelper helper,
        EmployerDashboardProvider employerDashboardProvider, snapshot) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: GlobalList.statisticsDataList[index!]["color"],
                shape: BoxShape.circle,
              ),
            ),
            PickHeightAndWidth.width15,
            Expanded(
              child: Text(
                GlobalList.statisticsDataList[index!]["title"],
                style: CommonTextStyle()
                    .noteHeadingTextStyle
                    .copyWith(color: PickColors.blackColor),
              ),
            ),
            Expanded(
              child: Text(
                employerDashboardProvider.statisticsEmployData != null
                    ? (employerDashboardProvider.statisticsEmployData[
                                GlobalList.statisticsDataList[index!]["key"]] ??
                            "-")
                        .toString()
                    : "-",
                textAlign: TextAlign.end,
                style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                      color: PickColors.blackColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            PickHeightAndWidth.width30,
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: PickColors.primaryColor,
              size: 20,
            )
          ],
        ),
      );
    });
  }
}
