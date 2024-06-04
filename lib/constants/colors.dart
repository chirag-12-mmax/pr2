// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class PickColors {
  static late Color bgColor;
  static late Color primaryColor;
  static late Color lightPrimaryColor;
  static late Color hintColor;
  static late Color whiteColor;
  static late Color blackColor;
  static late Color successColor;
  static late Color greenColor;
  static late Color lightGreenColor;
  static late Color skyColor;
  static late Color lightSkyColor;
  static late Color yellowColor;
  static late Color lightYellowColor;
  static late Color purpleColor;
  static late Color orangeColor;
  static late Color lightColor;
  static late Color pinkColor;
  static late Color lightBlueColor;
  static late Color woodColor;
  static late Color navyBlueColor;
  static late Color lightSuccessColor;
  static late Color darkGreenColor;
// Color(0xffFE464B);

  static setThemColors(
      {Color? newPrimaryColor, Color? secondaryColor, Color? textColor}) {
    bgColor = secondaryColor ?? Color(0xffF4F6FA);
    primaryColor = newPrimaryColor ?? Color(0xffFE464B);
    lightPrimaryColor = Color(0xffFFDFDF);
    hintColor = Color(0xffA1A5C1);
    whiteColor = Color(0xffFFFFFF);
    blackColor = textColor ?? Color(0xff1A1B1E);
    successColor = Color(0xff23AF6F);
    greenColor = Color(0xff08A190);
    lightGreenColor = Color(0xffCFEFEB);
    skyColor = Color(0xff58BFF3);
    lightSkyColor = Color(0xffE1F4FE);
    yellowColor = Color(0xffFEC54B);
    lightYellowColor = Color(0xffFFF4DE);
    purpleColor = Color(0xffB09FFF);
    orangeColor = Color(0xffFF9364);
    lightColor = Color(0xffD5EBF8);
    pinkColor = Color(0xffEE23FF);
    lightBlueColor = Color(0xff29D2D2);
    woodColor = Color(0xffA96B6B);
    navyBlueColor = Color(0xff5A8EE1);
    lightSuccessColor = Color(0xff45B956);
    darkGreenColor = Color(0xff00AF98);
  }
}
