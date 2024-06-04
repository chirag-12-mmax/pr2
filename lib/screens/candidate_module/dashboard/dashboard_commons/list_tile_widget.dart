import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';

class ListTitleWidget extends StatelessWidget {
  final dynamic leadingIcon;
  final dynamic trailingIcon;
  final String title;
  final dynamic onTap;
  final Color? backGroundColor;
  final String? subTitleText;
  final double vertical;
  const ListTitleWidget({
    super.key,
    this.subTitleText,
    this.backGroundColor,
    this.leadingIcon,
    this.trailingIcon,
    this.vertical = 0.0,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backGroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: vertical),
        child: Row(
          children: [
            SvgPicture.asset(
              leadingIcon,
              color: PickColors.blackColor,
              height: 25,
              width: 25,
            ),
            PickHeightAndWidth.width10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    style: CommonTextStyle().subMainHeadingTextStyle.copyWith(
                        fontSize: 15,
                        fontWeight: checkPlatForm(context: context, platforms: [
                          CustomPlatForm.MOBILE,
                        ])
                            ? FontWeight.normal
                            : FontWeight.bold),
                  ),
                  subTitleText != null
                      ? Text(subTitleText!,
                          style: CommonTextStyle().noteHeadingTextStyle)
                      : const SizedBox()
                ],
              ),
            ),
            SvgPicture.asset(trailingIcon)
          ],
        ),
      ),
    );
  }
}
