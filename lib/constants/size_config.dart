import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;

  static double? screenWidth; 
  static double? screenHeight;
  static double? mainFontSize;
  static double? subMainFontSize;
  static double? width17;
  static double? width70;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);

    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    mainFontSize = screenWidth! * 0.015 < 24 ? 24 : screenWidth! * 0.015;
    subMainFontSize = screenWidth! * 0.01 < 18 ? 18 : screenWidth! * 0.01;
    width17 = screenWidth! * 0.01 < 17 ? 17 : screenWidth! * 0.01;
    width70 = screenWidth! * 0.0009 < 70 ? 70 : screenWidth! * 0.0009;
  }
}
