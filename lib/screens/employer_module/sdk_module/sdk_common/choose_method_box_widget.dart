import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/text_style.dart';

class ChooseMethodBoxWidget extends StatelessWidget {
  const ChooseMethodBoxWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  final String title;
  final String subTitle;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: PickColors.whiteColor,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0.0, 1.0),
                blurRadius: 3,
                color: Color.fromRGBO(0, 0, 0, 0.16),
              )
            ]),
        child: Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: CommonTextStyle().subMainHeadingTextStyle.copyWith(
                          color: PickColors.primaryColor,
                        ),
                  ),
                  PickHeightAndWidth.height10,
                  Text(
                    subTitle,
                    style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                          color: PickColors.blackColor,
                        ),
                  ),
                ],
              ),
            ),
            PickHeightAndWidth.width10,
            SvgPicture.asset(
              icon,
              color: PickColors.primaryColor,
              height: 45,
            )
          ],
        ),
      ),
    );
  }
}
