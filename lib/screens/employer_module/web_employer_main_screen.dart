import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/employer_module/employer_drawer_screen.dart';
import 'package:onboarding_app/widgets/common_app_bar.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';

@RoutePage()
class EmployerMainScreen extends StatefulWidget {
  const EmployerMainScreen({super.key});

  @override
  State<EmployerMainScreen> createState() => _EmployerMainScreenState();
}

class _EmployerMainScreenState extends State<EmployerMainScreen> {
  final GlobalKey<ScaffoldState> employerScaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    printDebug(textString: "=============${context.router.currentPath}");
    SizeConfig().init(context);
    return Consumer(
        builder: (BuildContext context, GeneralHelper helper, snapshot) {
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
          key: employerScaffoldKey,
          drawer: Drawer(
            child: EmployerDrawerScreen(
              employerScaffoldKey: employerScaffoldKey,
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
              ]))
                  ? Expanded(
                      child: EmployerDrawerScreen(
                      employerScaffoldKey: employerScaffoldKey,
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
                  child: EmployerMasterPageScreen(
                    bodyPage: const AutoRouter(),
                    scaffoldKey: employerScaffoldKey,
                    appBarTitle: convertToSentenceCase(
                        helper: helper,
                        titleText: context.router.currentPath
                                .toString()
                                .contains("my_profile")
                            ? "my_profile"
                            : context.router.currentPath
                                    .toString()
                                    .contains("candidate-upload")
                                ? "Candidate List "
                                : context.router.currentPath
                                        .toString()
                                        .contains("add-new-candidate-form")
                                    ? "Add New Candidate"
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

String convertToSentenceCase(
    {required String titleText, required GeneralHelper helper}) {
  print("====================Title Text.......${titleText}");
  titleText = titleText == "dashboard"
      ? "Home"
      : titleText == "recent-Chat"
          ? "Recent Chats"
          : titleText;
  titleText = helper.translateTextTitle(
      titleText: titleText == "add-new-candidate"
          ? "Add new candidate"
          : capitalizeEachWord(
              titleText.trim().replaceAll("-", " ").replaceAll("_", " ")));
  return titleText.toString().trim() != ""
      ? titleText.toUpperCase().replaceAll("-", " ").replaceAll("_", " ")
      : "-";
}

String capitalizeEachWord(String input) {
  List<String> words = input.split(' ');

  for (int i = 0; i < words.length; i++) {
    String word = words[i];
    words[i] = word[0].toUpperCase() + word.substring(1).toLowerCase();
  }

  return words.join(' ');
}

class EmployerMasterPageScreen extends StatefulWidget {
  final Widget bodyPage;
  final String appBarTitle;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const EmployerMasterPageScreen({
    Key? key,
    required this.bodyPage,
    required this.appBarTitle,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  State<EmployerMasterPageScreen> createState() =>
      _EmployerMasterPageScreenState();
}

class _EmployerMasterPageScreenState extends State<EmployerMasterPageScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, GeneralHelper helper, snapshot) {
      return Scaffold(
        appBar: commonAppBarWidget(
            context: context,
            title: widget.appBarTitle,
            scaffoldKey: widget.scaffoldKey),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : widget.bodyPage,
      );
    });
  }
}
