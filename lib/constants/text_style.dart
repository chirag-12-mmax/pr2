import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/size_config.dart';

class CommonTextStyle {
  TextStyle mainHeadingTextStyle = TextStyle(
    fontSize: SizeConfig.mainFontSize,
    color: PickColors.blackColor,
    fontWeight: FontWeight.bold,
  );

  TextStyle subMainHeadingTextStyle = TextStyle(
    fontSize: SizeConfig.subMainFontSize,
    color: PickColors.blackColor,
    fontWeight: FontWeight.bold,
  );

  TextStyle noteHeadingTextStyle = TextStyle(
    fontSize: 15,
    color: PickColors.hintColor,
    fontWeight: FontWeight.normal,
  );

  TextStyle buttonTextStyle = TextStyle(
    fontSize: 15,
    color: PickColors.whiteColor,
    fontWeight: FontWeight.w600,
  );

  TextStyle textFieldLabelTextStyle = TextStyle(
    fontSize: 14,
    color: PickColors.blackColor,
    fontWeight: FontWeight.w600,
  );
}
