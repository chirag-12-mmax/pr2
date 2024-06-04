import 'dart:convert';

import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';

import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/employer_module/employer_dashboard/employer_dashboard_common/employer_dashboard_category_widget.dart';
import 'package:onboarding_app/screens/employer_module/employer_provider/dashboard_provider.dart';

import 'package:provider/provider.dart';

@RoutePage()
class AddNewCandidateScreen extends StatefulWidget {
  const AddNewCandidateScreen({super.key});

  @override
  State<AddNewCandidateScreen> createState() => _AddNewCandidateScreenState();
}

class _AddNewCandidateScreenState extends State<AddNewCandidateScreen> {
  @override
  void initState() {
    super.initState();
    // initializeData();
  }

  void initializeData() {
    if (checkPlatForm(context: context, platforms: [
      CustomPlatForm.TABLET_VIEW,
      CustomPlatForm.TABLET,
      CustomPlatForm.MOBILE_VIEW,
      CustomPlatForm.MOBILE,
      CustomPlatForm.MIN_MOBILE_VIEW,
      CustomPlatForm.MIN_MOBILE,
    ])) {
    } else {
      GlobalList.addNewCandidateDataList.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: PickColors.bgColor,
      body: Consumer2(builder: (BuildContext context, GeneralHelper helper,
          EmployerDashboardProvider employerDashboardProvider, snapshot) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  height: 300,
                  // padding: const EdgeInsets.all(15),
                  // constraints: const BoxConstraints(minHeight: 200),
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: PickColors.whiteColor,
                  ),
                  child: Image.asset(
                    PickImages.candidateBgImage,
                    fit: checkPlatForm(context: context, platforms: [
                      CustomPlatForm.TABLET_VIEW,
                      CustomPlatForm.TABLET,
                      CustomPlatForm.MOBILE_VIEW,
                      CustomPlatForm.MOBILE,
                      CustomPlatForm.MIN_MOBILE_VIEW,
                      CustomPlatForm.MIN_MOBILE,
                    ])
                        ? BoxFit.cover
                        : BoxFit.fitHeight,
                    height: 300,
                    // width: 200,
                  ),
                ),
                PickHeightAndWidth.height20,
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: GlobalList.addNewCandidateDataList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 90,
                      crossAxisCount:
                          checkPlatForm(context: context, platforms: [
                        CustomPlatForm.TABLET_VIEW,
                        CustomPlatForm.TABLET,
                        CustomPlatForm.MOBILE_VIEW,
                        CustomPlatForm.MOBILE,
                        CustomPlatForm.MIN_MOBILE_VIEW,
                        CustomPlatForm.MIN_MOBILE,
                      ])
                              ? 1
                              : 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () async {
                        moveToNextScreenWithRoute(
                            context: context,
                            routePath: GlobalList.addNewCandidateDataList[index]
                                ["path"]);
                        //}
                      },
                      child: EmployerDashboardCategoryWidget(
                        color: GlobalList.addNewCandidateDataList[index]
                            ["color"],
                        icon: GlobalList.addNewCandidateDataList[index]["icon"],
                        title: GlobalList.addNewCandidateDataList[index]
                            ["title"],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

String getHashString() {
  // Your input values
  String clientCode = 'CNER6217';
  String apiKey = "CRb3PL08";
  String requestId = Random().nextInt(999999999).toString();
  ;
  print("=========Request Id : ${requestId}");
  String salt = 'jvJB3690';

  // Create the Hash-Sequence string
  String hashSequence = '$clientCode|$requestId|$apiKey|$salt';

  // Calculate the SHA-256 hash
  String hash = sha256.convert(utf8.encode(hashSequence)).toString();

  // Print the result
  print('Hash-Sequence: $hashSequence');
  print('Hash: $hash');
  return hash;
}
