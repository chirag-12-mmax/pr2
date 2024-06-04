import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';

class ProfileCommonTabBar extends StatelessWidget {
  final int stepIndex;
  final String stepText;
  final int currentStepIndex;
  final dynamic onTapTab;
  final int? index;
  final bool isDisable;
  const ProfileCommonTabBar({
    Key? key,
    required this.stepIndex,
    required this.stepText,
    this.index,
    required this.currentStepIndex,
    required this.onTapTab,
    required this.isDisable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: onTapTab,
      splashColor: Colors.transparent,
      child: Column(
        children: [
          Text(
            stepText,
            style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                  color: currentStepIndex != stepIndex
                      ? isDisable
                          ? PickColors.hintColor
                          : PickColors.blackColor
                      : PickColors.primaryColor,
                  fontWeight: currentStepIndex == stepIndex
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
          ),
          PickHeightAndWidth.height10,
          Container(
            height: 2,
            width: 50,
            color: currentStepIndex != stepIndex
                ? Colors.transparent
                : PickColors.primaryColor,
          )
        ],
      ),
    );
  }
}
