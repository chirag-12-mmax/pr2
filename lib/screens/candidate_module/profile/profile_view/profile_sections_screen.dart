import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_common/profile_common_tab_bar_widget.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_models/configuration_model.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_providers/profile_provider.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_view/profile_form_screen.dart';
import 'package:provider/provider.dart';

late TabsRouter subSectionRouter;

@RoutePage()
class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen(
      {super.key,
      @PathParam('tabName') this.tabName = "-",
      this.obApplicantID});

  final String tabName;
  final String? obApplicantID;

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen>
    with WidgetsBindingObserver {
  List<FieldConfigDetails> listOfSections = [];
  FieldConfigDetails? currentSelectedSection;
  TabDetails? currentTabDetail;
  bool isLoading = false;
  ScrollController profileTabBarScrollController = ScrollController();
  final ValueNotifier<bool> _showLeftArrow = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _showRightArrow = ValueNotifier<bool>(false);
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initializeTabs();

    super.initState();
  }

  Future<void> initializeTabs() async {
    setState(() {
      isLoading = true;
    });
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    currentTabDetail = profileProvider.profileConfigurationDetails!.tabDetails!
        .firstWhere((element) => element.fieldCode == widget.tabName);
    if (currentTabDetail != null) {
      listOfSections = profileProvider
          .profileConfigurationDetails!.fieldConfigDetails!
          .where((element) =>
              (element.tabId == currentTabDetail!.tabId) &&
              (element.control == "sec") &&
              (element.viewFlag ?? false))
          .toList();
      currentSelectedSection = listOfSections.first;
    }

    _handleScrollButtonsVisibility();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void didChangeMetrics() {
    _handleScrollButtonsVisibility();
    super.didChangeMetrics();
  }

  void _handleScrollButtonsVisibility() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _showLeftArrow.value = profileTabBarScrollController.position.pixels >
          profileTabBarScrollController.position.minScrollExtent;

      _showRightArrow.value = profileTabBarScrollController.position.pixels <
          profileTabBarScrollController.position.maxScrollExtent;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PickColors.bgColor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Consumer(
                builder:
                    (BuildContext context, GeneralHelper helper, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          color: PickColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                helper!.translateTextTitle(
                                    titleText:
                                        currentTabDetail!.fieldName.toString()),
                                style:
                                    CommonTextStyle().subMainHeadingTextStyle,
                              ),
                              PickHeightAndWidth.height10,
                              const Divider(),
                              PickHeightAndWidth.height10,
                              Container(
                                height: 35,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ValueListenableBuilder<bool>(
                                        valueListenable: _showLeftArrow,
                                        builder: (context, value, child) {
                                          if (value) {
                                            return InkWell(
                                              child: Icon(
                                                  Icons.chevron_left_rounded),
                                              onTap: () {
                                                profileTabBarScrollController
                                                    .animateTo(
                                                  profileTabBarScrollController
                                                          .position.pixels -
                                                      100,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeInOut,
                                                );
                                              },
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                    Expanded(
                                      child: NotificationListener<
                                          ScrollNotification>(
                                        onNotification: (notification) {
                                          _handleScrollButtonsVisibility();

                                          return false; // Return false to allow the notification to continue to be dispatched.
                                        },
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          controller:
                                              profileTabBarScrollController,
                                          shrinkWrap: true,
                                          children: List.generate(
                                              listOfSections.length, (index) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  left:
                                                      index == 0 ? 0.0 : 10.0),
                                              child: Row(
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
                                                    onTapTab: () {
                                                      setState(() {
                                                        currentSelectedSection =
                                                            listOfSections[
                                                                index];
                                                      });
                                                    },
                                                    index: index,
                                                    isDisable: false,
                                                    currentStepIndex:
                                                        listOfSections.indexOf(
                                                            currentSelectedSection!),
                                                    stepIndex: index,
                                                    stepText:
                                                        listOfSections[index]
                                                                .fieldName ??
                                                            "-",
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                    ValueListenableBuilder<bool>(
                                        valueListenable: _showRightArrow,
                                        builder: (context, value, child) {
                                          if (value) {
                                            print("WHENN");
                                            return InkWell(
                                              child: const Icon(
                                                  Icons.chevron_right_rounded),
                                              onTap: () {
                                                profileTabBarScrollController
                                                    .animateTo(
                                                  profileTabBarScrollController
                                                          .position.pixels +
                                                      100,
                                                  duration: Duration(
                                                      milliseconds: 500),
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
                              PickHeightAndWidth.height20,
                              PersonalScreen(
                                  currentSelectedSection:
                                      currentSelectedSection!,
                                  currentTabDetail: currentTabDetail),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
