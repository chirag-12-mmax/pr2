import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/text_style.dart';

class DocumentsStatusWidget extends StatelessWidget {
  final dynamic icon;
  final String? count;
  final String? title;
  final Color? color;
  final Color? textColor;
  const DocumentsStatusWidget({
    super.key,
    this.icon,
    this.count,
    this.title,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration:  BoxDecoration(
              color: PickColors.whiteColor,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              icon,
              height: 20,
              width: 20,
            ),
          ),
          PickHeightAndWidth.width15,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count ?? "",
                  style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
                PickHeightAndWidth.height5,
                Text(
                  title ?? "",
                  style: CommonTextStyle().textFieldLabelTextStyle.copyWith(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
