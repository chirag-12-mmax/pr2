import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_providers/profile_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class ProfileStatusWidget extends StatefulWidget {
  const ProfileStatusWidget({super.key});
  @override
  State<ProfileStatusWidget> createState() => _ProfileStatusWidgetState();
}

class _ProfileStatusWidgetState extends State<ProfileStatusWidget> {
  // double percent = 90;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer2(builder: (BuildContext context,
        ProfileProvider profileProvider, GeneralHelper helper, snapshot) {
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
                radius: SizeConfig.screenWidth! * 0.014 < 25
                    ? 25
                    : SizeConfig.screenWidth! * 0.014,
                lineWidth: SizeConfig.screenWidth! * 0.002 < 6.0
                    ? 6.0
                    : SizeConfig.screenWidth! * 0.002,
                animation: true,
                percent: getProfileCompletionPercentage(
                        profileProvider: profileProvider) /
                    100,
                backgroundColor: PickColors.primaryColor.withOpacity(0.3),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: PickColors.primaryColor,
              ),
              SizedBox(
                width: SizeConfig.width17,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${helper.translateTextTitle(titleText: "Your profile is")} ${getProfileCompletionPercentage(profileProvider: profileProvider).round()}% ${helper.translateTextTitle(titleText: "completed")}",
                      style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                            color: PickColors.blackColor,
                          ),
                    ),
                    PickHeightAndWidth.height5,
                    Text(
                      helper.translateTextTitle(
                          titleText:
                              "Completing your profile will improve your profile visibility."),
                      textAlign: TextAlign.start,
                      style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

double getProfileCompletionPercentage(
    {required ProfileProvider profileProvider}) {
  int totalCount = 0;
  int completionCount = 0;
  profileProvider.candidateProfileStatusInformation!.tabWiseStatus!
      .forEach((element) {
    totalCount += element.totalCount ?? 0;
    completionCount += element.doneCount ?? 0;
  });

  return (completionCount / totalCount) * 100;
}
