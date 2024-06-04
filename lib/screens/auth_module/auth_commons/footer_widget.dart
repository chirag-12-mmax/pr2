import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:provider/provider.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer(
      builder: (BuildContext context, GeneralHelper helper, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              helper.translateTextTitle(titleText: "Powered by") ?? "",
              style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                    color: PickColors.blackColor,
                    fontFamily: "Cera Pro",
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                PickImages.zingHrLogo,
                height: 60,
                width: 60,
              ),
            ),
            Text(
              "v 5.1.0.12",
              style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                    color: PickColors.blackColor,
                    fontFamily: "Cera Pro",
                  ),
            )
          ],
        );
      },
    );
  }
}
