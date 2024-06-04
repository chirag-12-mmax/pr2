import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_providers/candidate_provider.dart';

import 'package:onboarding_app/screens/candidate_module/connect/connect_views/chat_screen.dart';
import 'package:onboarding_app/widgets/build_logo_profile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class EmployerChatListScreen extends StatefulWidget {
  const EmployerChatListScreen({super.key});

  @override
  State<EmployerChatListScreen> createState() => _EmployerChatListScreenState();
}

class _EmployerChatListScreenState extends State<EmployerChatListScreen> {
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

    await candidateProvider.getEmployeeListForCandidateApiFunction(
        context: context);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: PickColors.bgColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Consumer(builder: (BuildContext context,
              CandidateProvider candidateProvider, snapshot) {
              return candidateProvider.listOfEmployerForChat.isEmpty
                  ? Center(child: SvgPicture.asset(PickImages.oopsImage))
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: candidateProvider.listOfEmployerForChat.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: PickColors.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                BuildLogoProfileImageWidget(
                                  height: 50,
                                  width: 50,
                                  imagePath: "",
                                  titleName: candidateProvider
                                      .listOfEmployerForChat[index]
                                      .employeeName,
                                ),
                                // Container(
                                //   height: 50,
                                //   width: 50,
                                //   decoration: BoxDecoration(
                                //     border: Border.all(
                                //       width: 2,
                                //       color: PickColors.primaryColor,
                                //     ),
                                //     shape: BoxShape.circle,
                                //   ),
                                // ),
                                PickHeightAndWidth.width25,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              ("${candidateProvider.listOfEmployerForChat[index].salutation ?? ""} ${candidateProvider.listOfEmployerForChat[index].employeeName ?? ""}")
                                                  .toUpperCase(),
                                              style: CommonTextStyle()
                                                  .buttonTextStyle
                                                  .copyWith(
                                                    color:
                                                        PickColors.blackColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              final authProvider =
                                                  Provider.of<AuthProvider>(
                                                      context,
                                                      listen: false);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => ChatScreen(
                                                    // selectedEmployer:
                                                    //     candidateProvider
                                                    //             .listOfEmployerForChat[
                                                    //         index],
                                                    currentUserRoomId:
                                                        "${authProvider.currentUserAuthInfo!.subscriptionId}_${authProvider.currentUserAuthInfo!.obApplicantId.toString()}"
                                                            .toLowerCase(),
                                                    toUserRoomId:
                                                        "${authProvider.currentUserAuthInfo!.subscriptionId}_${candidateProvider.listOfEmployerForChat[index]!.employeeCode}"
                                                            .toLowerCase(),
                                                    toUserName: candidateProvider
                                                            .listOfEmployerForChat[
                                                                index]
                                                            .employeeName ??
                                                        "",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Icon(
                                              Icons.message_outlined,
                                              color: PickColors.primaryColor,
                                            ),
                                          ),
                                          PickHeightAndWidth.width10,
                                          InkWell(
                                            onTap: () {
                                              // To create email with params
                                              final Uri emailLaunchUri = Uri(
                                                scheme: 'mailto',
                                                path: candidateProvider
                                                    .listOfEmployerForChat[
                                                        index]
                                                    .officialEmail
                                                    .toString(),
                                                queryParameters: {
                                                  'subject': "",
                                                  'body': ""
                                                },
                                              );

                                              launchUrl(Uri.parse(
                                                  emailLaunchUri.toString()));
                                            },
                                            child: Icon(
                                              Icons.email_outlined,
                                              color: PickColors.primaryColor,
                                            ),
                                          )
                                        ],
                                      ),
                                      PickHeightAndWidth.height10,
                                      Text(
                                        candidateProvider
                                                .listOfEmployerForChat[index]
                                                .designation ??
                                            "",
                                        style: CommonTextStyle()
                                            .textFieldLabelTextStyle
                                            .copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                              color: PickColors.hintColor,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
            }),
    );
  }
}
