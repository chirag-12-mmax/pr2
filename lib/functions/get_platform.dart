// ignore: duplicate_ignore
// ignore: constant_identifier_names
// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

enum CustomPlatForm {
  WEB,
  MOBILE,
  MOBILE_VIEW,
  MIN_MOBILE,
  MIN_MOBILE_VIEW,
  TABLET,
  TABLET_VIEW,
  MIN_LAPTOP_VIEW,
  LARGE_LAPTOP_VIEW,
}

CustomPlatForm getCurrentPlatForm({required BuildContext context}) {
  SizeConfig().init(context);

  if (SizeConfig.screenWidth! <= 320) {
    if (kIsWeb) {
      return CustomPlatForm.MIN_MOBILE_VIEW;
    } else {
      return CustomPlatForm.MIN_MOBILE;
    }
  } else if (SizeConfig.screenWidth! <= 425) {
    if (kIsWeb) {
      return CustomPlatForm.MOBILE_VIEW;
    } else {
      return CustomPlatForm.MOBILE;
    }
  } else if (SizeConfig.screenWidth! <= 768) {
    if (kIsWeb) {
      return CustomPlatForm.TABLET_VIEW;
    } else {
      return CustomPlatForm.TABLET;
    }
  } else if (SizeConfig.screenWidth! <= 1024) {
    return CustomPlatForm.MIN_LAPTOP_VIEW;
  } else if (SizeConfig.screenWidth! <= 1440) {
    return CustomPlatForm.LARGE_LAPTOP_VIEW;
  } else {
    return CustomPlatForm.WEB;
  }
}

bool checkPlatForm(
    {required BuildContext context, required List<CustomPlatForm> platforms}) {
  if (platforms.contains(getCurrentPlatForm(context: context))) {
    return true;
  } else {
    return false;
  }
}
