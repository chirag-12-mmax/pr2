import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/text_style.dart';

class EmployerDashboardCategoryWidget extends StatelessWidget {
  const EmployerDashboardCategoryWidget({
    super.key,
    this.title,
    this.icon,
    this.color,
  });

  final String? title;
  final dynamic icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            height: 56,
            width: 56,
          ),
          PickHeightAndWidth.width15,
          Expanded(
            child: Text(
              title ?? "",
              style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: PickColors.whiteColor,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
