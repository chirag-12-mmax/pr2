import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_providers/candidate_provider.dart';
import 'package:onboarding_app/screens/candidate_module/web_drawer_screen.dart';
import 'package:onboarding_app/screens/employer_module/web_employer_main_screen.dart';
import 'package:onboarding_app/widgets/common_app_bar.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';

// late TabsRouter tabsRouter;

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    context.router.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer3(builder: (BuildContext context,
        GeneralHelper helper,
        AuthProvider authProvider,
        CandidateProvider candidateProvider,
        snapshot) {
      return WillPopScope(
        onWillPop: () async {
          bool canPop = false;
          await showDialog(
              context: context,
              builder: (context) {
                return CommonConfirmationDialogBox(
                  isCancel: true,
                  buttonTitle:
                      helper.translateTextTitle(titleText: "Yes") ?? "-",
                  cancelButtonTitle:
                      helper.translateTextTitle(titleText: "No") ?? "-",
                  title: helper.translateTextTitle(titleText: "Confirmation") ??
                      "-",
                  subTitle: helper.translateTextTitle(
                          titleText: "Are you sure you want to exit ?") ??
                      "-",
                  onPressButton: () async {
                    canPop = true;
                    SystemNavigator.pop();
                  },
                );
              });
          return canPop;
        },
        child: Scaffold(
          backgroundColor: PickColors.bgColor,
          key: scaffoldKey,
          drawer: Drawer(
            child: DrawerScreen(
              scaffoldKey: scaffoldKey,
            ),
          ),
          body: SafeArea(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (checkPlatForm(context: context, platforms: [
                        CustomPlatForm.WEB,
                        CustomPlatForm.LARGE_LAPTOP_VIEW,
                        CustomPlatForm.MIN_LAPTOP_VIEW,
                      ])) &&
                      !(candidateProvider.isYoutubeFullScreen)
                  ? Expanded(
                      child: DrawerScreen(
                      scaffoldKey: scaffoldKey,
                    ))
                  : Container(),
              Expanded(
                  flex: checkPlatForm(context: context, platforms: [
                    CustomPlatForm.LARGE_LAPTOP_VIEW,
                  ])
                      ? 5
                      : checkPlatForm(context: context, platforms: [
                          CustomPlatForm.MIN_LAPTOP_VIEW,
                        ])
                          ? 4
                          : 6,
                  child: MasterPageScreen(
                    bodyPage: const AutoRouter(),
                    scaffoldKey: scaffoldKey,
                    appBarTitle: convertToSentenceCase(
                        helper: helper,
                        titleText: context.router.currentPath
                                .toString()
                                .contains("my_profile")
                            ? "my_profile"
                            : (context.router.currentPath
                                        .toString()
                                        .contains("offer-detail") &&
                                    authProvider.candidateCurrentStage ==
                                        CandidateStages.POST_JOINING_CHECK_LIST)
                                ? "Appointment Details"
                                : context.router.currentPath
                                    .toString()
                                    .split("/")
                                    .last),
                  ))
            ],
          )),
        ),
      );
    });
  }
}

// String convertToSentenceCase({required String titleText}) {
//   return titleText.toString().trim() != ""
//       ? titleText.toUpperCase().replaceAll("-", " ").replaceAll("_", " ")
//       : "-";
// }

class MasterPageScreen extends StatefulWidget {
  final Widget bodyPage;
  final String appBarTitle;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const MasterPageScreen({
    Key? key,
    required this.bodyPage,
    required this.appBarTitle,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  State<MasterPageScreen> createState() => _MasterPageScreenState();
}

class _MasterPageScreenState extends State<MasterPageScreen> {
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
        CandidateProvider candidateProvider, snapshot) {
      return Scaffold(
        backgroundColor: PickColors.bgColor,
        appBar: !(candidateProvider.isYoutubeFullScreen)
            ? commonAppBarWidget(
                context: context,
                title: widget.appBarTitle,
                scaffoldKey: widget.scaffoldKey)
            : null,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : widget.bodyPage,
      );
    });
  }
}
