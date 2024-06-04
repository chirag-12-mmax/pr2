import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/text_style.dart';

class ProfileRowInfoWidget extends StatelessWidget {
  final String? title;
  final dynamic icon;
  const ProfileRowInfoWidget({
    super.key,
    this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          height: 17,
        ),
        PickHeightAndWidth.width10,
        Expanded(
          child: Text(
            title ?? "",
            style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                  fontSize: 13,
                ),
          ),
        ),
      ],
    );
  }
}
