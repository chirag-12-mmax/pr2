import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';

class JobDescriptionDetailsWidget extends StatelessWidget {
  final String? title;
  final String? titleValue;
  const JobDescriptionDetailsWidget({
    super.key,
    this.title,
    this.titleValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: PickColors.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "",
            style: CommonTextStyle().subMainHeadingTextStyle,
          ),
          PickHeightAndWidth.height15,
          HtmlWidget(
            titleValue ?? "",
          ),
        ],
      ),
    );
  }
}
