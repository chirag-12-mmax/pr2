import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';

class InformationTextWidget extends StatelessWidget {
  const InformationTextWidget({
    Key? key,
    required this.textString,
    this.leadingIconString,
  }) : super(key: key);
  final String textString;
  final String? leadingIconString;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          leadingIconString ?? PickImages.information,
          height: 15,
          width: 15,
          color: PickColors.hintColor,
        ),
        PickHeightAndWidth.width10,
        Expanded(
          child: Text(
            textString,
            style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
            textAlign: TextAlign.left,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        )
      ],
    );
  }
}
