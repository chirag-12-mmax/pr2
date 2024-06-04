import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';

class CommonTabWidget extends StatelessWidget {
  final int stepIndex;
  final String stepText;
  final int currentStepIndex;
  final dynamic onTapTab;
  const CommonTabWidget({
    Key? key,
    required this.stepIndex,
    required this.stepText,
    required this.currentStepIndex,
    required this.onTapTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Expanded(
      child: InkWell(
        onTap: onTapTab,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: checkPlatForm(context: context, platforms: [
            CustomPlatForm.MOBILE_VIEW,
            CustomPlatForm.MOBILE,
          ])
                  ? 10
                  : 18),
          decoration: BoxDecoration(
            borderRadius: stepIndex == 0
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  )
                : const BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
            color: currentStepIndex == stepIndex
                ? PickColors.primaryColor
                : PickColors.bgColor,
            border: Border.all(
              color: PickColors.primaryColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              stepText,
              style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                    color: currentStepIndex == stepIndex
                        ? PickColors.whiteColor
                        : PickColors.primaryColor,
                    fontWeight: currentStepIndex == stepIndex
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
