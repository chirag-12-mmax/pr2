import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/date_formates.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_providers/candidate_provider.dart';
import 'package:onboarding_app/screens/candidate_module/dashboard/dashboard_provider/dashboard_provider.dart';
import 'package:onboarding_app/screens/candidate_module/offer_detail/offer_detail_commons/offer_detail_data_widget.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:provider/provider.dart';

@RoutePage()
class OfferDetailScreen extends StatefulWidget {
  const OfferDetailScreen({super.key});

  @override
  State<OfferDetailScreen> createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends State<OfferDetailScreen> {
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
    await candidateProvider.getSalaryBreakUpInfoApiProvider(context: context);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: PickColors.bgColor,
      body: Consumer4(builder: (BuildContext context,
          GeneralHelper helper,
          AuthProvider authProvider,
          CandidateProvider candidateProvider,
          DashboardProvider dashboardProvider,
          snapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      OfferDetailDataWidget(
                        backgroundColor: PickColors.whiteColor,
                        mainTitle: (authProvider.candidateCurrentStage ==
                                    CandidateStages.POST_JOINING_CHECK_LIST ||
                                authProvider.candidateCurrentStage ==
                                    CandidateStages.POST_JOINING_VERIFICATION ||
                                authProvider.candidateCurrentStage ==
                                    CandidateStages.COMPLETION)
                            ? helper.translateTextTitle(
                                    titleText: "Appointment Details") ??
                                "-"
                            : helper.translateTextTitle(
                                    titleText: "Offer Details") ??
                                "-",
                        isSpaceBetween: false,
                        dataList: [
                          {
                            "title": helper.translateTextTitle(
                                titleText: "Designation"),
                            "titleValue": authProvider
                                    .applicantInformation!.designation ??
                                "",
                          },
                          {
                            "title": helper.translateTextTitle(
                                titleText: "Joining Date"),
                            "titleValue": DateFormate.displayDateFormate.format(
                                DateTime.parse(authProvider
                                        .applicantInformation!.dateOfJoining ??
                                    "")),
                          },
                        ],
                        icon: PickImages.compensationIcon,
                      ),
                      PickHeightAndWidth.height20,
                      OfferDetailDataWidget(
                        backgroundColor: PickColors.whiteColor,
                        isSpaceBetween: true,
                        isSecondHeading: true,
                        secondHeadingData: {
                          "title": helper.translateTextTitle(
                              titleText: "Particulars"),
                          "titleValue": helper.translateTextTitle(
                              titleText: "Annual Amount")
                        },
                        mainTitle: helper.translateTextTitle(
                                titleText: "Compensation") ??
                            "-",
                        dataList: candidateProvider.salaryInformationList
                            .map((e) => {
                                  "title": e.name ?? "-",
                                  "titleValue": (e.amount ?? "0.0").toString()
                                })
                            .toList(),
                        icon: PickImages.offerDetailsIcon,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 350),
                        width: SizeConfig.screenWidth! * 0.20,
                        child: CommonMaterialButton(
                          isButtonDisable: (authProvider
                                  .applicantInformation!.isDownloadDisabled ??
                              false),
                          title: authProvider.candidateCurrentStage ==
                                  CandidateStages.POST_JOINING_CHECK_LIST
                              ? helper.translateTextTitle(
                                  titleText: "Download appointment letter")
                              : helper.translateTextTitle(
                                  titleText: "Download offer letter"),
                          onPressed: () async {
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
                        ),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
