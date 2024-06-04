import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/screens/candidate_module/dashboard/dashboard_commons/status_widget.dart';
import 'package:onboarding_app/widgets/build_logo_profile.dart';

class CommonProfileInfoWidget extends StatelessWidget {
  final bool isStatusWidget;
  const CommonProfileInfoWidget({
    super.key,
    this.isStatusWidget = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PickColors.whiteColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome!",
                      style: CommonTextStyle().noteHeadingTextStyle,
                    ),
                    PickHeightAndWidth.height5,
                    Text(
                      "Magnus Bergsten",
                      style: CommonTextStyle().subMainHeadingTextStyle,
                    )
                  ],
                ),
                BuildLogoProfileImageWidget(
                  height: 60,
                  width: 60,
                  borderRadius: BorderRadius.circular(12),
                  imagePath: "",
                  titleName: "Rutvik Kachhadiya",
                ),
              ],
            ),
            isStatusWidget
                ? PickHeightAndWidth.height10
                : PickHeightAndWidth.height0,
            isStatusWidget ? const StatusWidget() : Container(),
          ],
        ),
      ),
    );
  }
}
