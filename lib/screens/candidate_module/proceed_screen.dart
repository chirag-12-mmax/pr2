import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/common_profile_info_widget.dart';

import 'package:provider/provider.dart';

@RoutePage()
class ProceedScreen extends StatefulWidget {
  const ProceedScreen({super.key});

  @override
  State<ProceedScreen> createState() => _ProceedScreenState();
}

class _ProceedScreenState extends State<ProceedScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer(
          builder: (BuildContext context, GeneralHelper helper, snapshot) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CommonProfileInfoWidget(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        "On behalf of the entire company, I'd like to say that it brings me great pleasure to formally offer you the position of Senior Sales Officer at our company.",
                        textAlign: TextAlign.center,
                        style:
                            CommonTextStyle().textFieldLabelTextStyle.copyWith(
                                  color: PickColors.blackColor,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      PickHeightAndWidth.height30,
                      SvgPicture.asset(
                        PickImages.congratulationsImg,
                      ),
                      PickHeightAndWidth.height30,
                      Text(
                        "A huge Congratulations to you!",
                        style:
                            CommonTextStyle().textFieldLabelTextStyle.copyWith(
                                  color: PickColors.blackColor,
                                  fontWeight: FontWeight.normal,
                                ),
                      ),
                      PickHeightAndWidth.height180,
                      CommonMaterialButton(
                        title:
                            helper.translateTextTitle(titleText: "Proceed") ??
                                "-",
                        onPressed: () async {},
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
