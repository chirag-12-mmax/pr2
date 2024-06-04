import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/candidate_module/documents/documents_views/document_web_screen.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_common/profile_common_tab_bar_widget.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_provider/qr_code_provider.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_view/acknowledgement_screen.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_view/basic_details_screen.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_view/candidate_attributes_screen.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_view/resume_details_screen.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_view/video_resume_screen.dart';
import 'package:provider/provider.dart';

@RoutePage()
class QRCodeFormsScreen extends StatefulWidget {
  const QRCodeFormsScreen({super.key});

  @override
  State<QRCodeFormsScreen> createState() => _QRCodeFormsScreenState();
}

class _QRCodeFormsScreenState extends State<QRCodeFormsScreen> {
  bool isLoading = false;

  final ValueNotifier<bool> _showLeftArrow = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _showRightArrow = ValueNotifier<bool>(false);
  ScrollController qrCodeTabBarScrollController = ScrollController();

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  initializeData() async {
    setState(() {
      isLoading = true;
    });

    final qrCodeProvider = Provider.of<QRCodeProvider>(context, listen: false);
    // if (qrCodeProvider.candidateOTPDetail != null) {
    await qrCodeProvider.getAttributeDataByReQuisitionApiFunction(
        context: context,
        dataParameter: {
          "subscriptionName": qrCodeProvider.qrCodeSubscription,
          "requisitionId": qrCodeProvider.qrRequisitionId,
          "obApplicantId": (qrCodeProvider.qrObApplicantID ?? "") != ""
              ? qrCodeProvider.qrObApplicantID
              : (qrCodeProvider.previousObApplicantId ?? "") != ""
                  ? qrCodeProvider.previousObApplicantId
                  : "",
          "otpToken": qrCodeProvider.otpTokenForCandidate ?? "",
          "employeeCode": "",
          "_": DateTime.now().millisecondsSinceEpoch.toString(),
        });

    // }

    if (qrCodeProvider.candidateAttributeData == null ||
        qrCodeProvider.candidateAttributeData!["attributeDetails"]!.isEmpty) {
      GlobalList.qrCodeTabList
          .removeWhere((element) => element["id"].toString() == "0");
    }
    if (qrCodeProvider.jobDescriptionData != null) {
      if (!(qrCodeProvider.jobDescriptionData!.isVideoInterviewApplicable ??
          false)) {
        GlobalList.qrCodeTabList
            .removeWhere((element) => element["id"].toString() == "3");
      }
    }
    GlobalList.qrCodeTabList.first["isVisited"] = true;
    qrCodeProvider.qrCodeSelectedTabIndex = 0;
    qrCodeProvider.candidateProfileImageName = null;
    qrCodeProvider.candidateProfileImageURl = null;
    qrCodeProvider.candidateImageResume = null;
    qrCodeProvider.candidateImageResumeName = null;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final helper = Provider.of<GeneralHelper>(context, listen: false);
    return Scaffold(
      backgroundColor: PickColors.bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: PickColors.whiteColor,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            backToScreen(context: context);
          },
          child: Icon(Icons.arrow_back_ios, color: PickColors.blackColor),
        ),
        title:
            Text(helper.translateTextTitle(titleText: "Candidate Application"),
                style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                      fontSize: 24,
                    )),
      ),
      body: Consumer2(builder: (BuildContext context,
          QRCodeProvider qrCodeProvider, GeneralHelper helper, snapshot) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : qrCodeProvider.candidateAttributeData == null
                    ? Container()
                    : Column(
                        children: [
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                ValueListenableBuilder<bool>(
                                    valueListenable: _showLeftArrow,
                                    builder: (context, value, child) {
                                      if (value) {
                                        return InkWell(
                                          child:
                                              Icon(Icons.chevron_left_rounded),
                                          onTap: () {
                                            qrCodeTabBarScrollController
                                                .animateTo(
                                              qrCodeTabBarScrollController
                                                      .position.pixels -
                                                  100,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: NotificationListener<
                                            ScrollNotification>(
                                        onNotification: (notification) {
                                          _showLeftArrow.value =
                                              qrCodeTabBarScrollController
                                                      .position.pixels >
                                                  0;
                                          _showRightArrow.value =
                                              qrCodeTabBarScrollController
                                                      .position.pixels <
                                                  qrCodeTabBarScrollController
                                                      .position.maxScrollExtent;

                                          return false; // Return false to allow the notification to continue to be dispatched.
                                        },
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          controller:
                                              qrCodeTabBarScrollController,
                                          itemCount:
                                              GlobalList.qrCodeTabList.length,
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  index == 0
                                                      ? const SizedBox()
                                                      : VerticalDivider(
                                                          endIndent: 10,
                                                          color: PickColors
                                                              .hintColor,
                                                        ),
                                                  PickHeightAndWidth.width10,
                                                  ProfileCommonTabBar(
                                                    isDisable: !(GlobalList
                                                            .qrCodeTabList[
                                                        index]["isVisited"]),
                                                    onTapTab: () {
                                                      if (GlobalList
                                                              .qrCodeTabList[
                                                          index]["isVisited"]) {
                                                        qrCodeProvider
                                                            .updateQrCodeScreenIndex(
                                                                context:
                                                                    context,
                                                                tabIndex:
                                                                    index);
                                                      }
                                                    },
                                                    currentStepIndex: qrCodeProvider
                                                        .qrCodeSelectedTabIndex,
                                                    stepIndex: index,
                                                    stepText: GlobalList
                                                            .qrCodeTabList[
                                                        index]["title"],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )),
                                  ),
                                ),
                                ValueListenableBuilder<bool>(
                                    valueListenable: _showRightArrow,
                                    builder: (context, value, child) {
                                      if (value) {
                                        return InkWell(
                                          child: const Icon(
                                              Icons.chevron_right_rounded),
                                          onTap: () {
                                            qrCodeTabBarScrollController
                                                .animateTo(
                                              qrCodeTabBarScrollController
                                                      .position.pixels +
                                                  100,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                              ],
                            ),
                          ),
                          PickHeightAndWidth.height30,
                          GlobalList.qrCodeTabList[qrCodeProvider.qrCodeSelectedTabIndex]
                                      ["id"] ==
                                  0
                              ? const CandidateAttributesScreen()
                              : GlobalList.qrCodeTabList[qrCodeProvider
                                          .qrCodeSelectedTabIndex]["id"] ==
                                      1
                                  ? const ResumeDetailsScreen()
                                  : GlobalList.qrCodeTabList[qrCodeProvider
                                              .qrCodeSelectedTabIndex]["id"] ==
                                          2
                                      ? const BasicDetailsScreen()
                                      : GlobalList.qrCodeTabList[qrCodeProvider
                                                  .qrCodeSelectedTabIndex]["id"] ==
                                              3
                                          ? const VideoResumeScreen()
                                          : GlobalList.qrCodeTabList[qrCodeProvider.qrCodeSelectedTabIndex]["id"] == 4
                                              ? DocumentsScreenWidget(
                                                  obApplicantID: qrCodeProvider
                                                          .qrObApplicantID ??
                                                      "",
                                                  isFromQrCode: true,
                                                )
                                              : GlobalList.qrCodeTabList[qrCodeProvider.qrCodeSelectedTabIndex]["id"] == 5
                                                  ? const AcknowledgementScreen()
                                                  : Container(),
                        ],
                      ),
          ),
        );
      }),
    );
  }
}
