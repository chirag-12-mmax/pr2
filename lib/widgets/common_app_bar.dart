import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';

PreferredSizeWidget commonAppBarWidget(
    {required String title,
    required BuildContext context,
    required GlobalKey<ScaffoldState> scaffoldKey}) {
  return AppBar(
    toolbarHeight: 70,
    elevation: 0,
    backgroundColor: PickColors.whiteColor,
    automaticallyImplyLeading: false,
    centerTitle: false,
    title: Text(title, style: CommonTextStyle().mainHeadingTextStyle),
    leading: (checkPlatForm(context: context, platforms: [
      CustomPlatForm.MOBILE_VIEW,
      CustomPlatForm.MOBILE,
      CustomPlatForm.TABLET_VIEW,
      CustomPlatForm.MIN_MOBILE_VIEW,
      CustomPlatForm.MIN_MOBILE,
    ]))
        ? InkWell(
            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            },
            child: Icon(
              Icons.menu,
              color: PickColors.blackColor,
            ),
          )
        : InkWell(
            onTap: () {
              backToPreviousScreen(context: context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: PickColors.blackColor,
            ),
          ),
  );
}

PreferredSizeWidget commonSimpleAppBarWidget({
  required String title,
  ShapeBorder? shape,
}) {
  return AppBar(
    toolbarHeight: 70,
    elevation: 0,
    backgroundColor: PickColors.whiteColor,
    automaticallyImplyLeading: false,
    centerTitle: true,
    shape: shape,
    // const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.only(
    //     bottomLeft: Radius.circular(20),
    //     bottomRight: Radius.circular(20),
    //   ),
    // ),
    title: Text(
      title,
      style: CommonTextStyle().subMainHeadingTextStyle,
    ),
    leading: InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: SvgPicture.asset(
          PickImages.backButton,
        ),
      ),
    ),
  );
}
