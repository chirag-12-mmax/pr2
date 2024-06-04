import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';

@RoutePage()
class TakeSelfieScreen extends StatefulWidget {
  const TakeSelfieScreen({super.key});

  @override
  State<TakeSelfieScreen> createState() => _TakeSelfieScreenState();
}

class _TakeSelfieScreenState extends State<TakeSelfieScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: PickColors.primaryColor,
        title: const Text("Video ID KYC"),
        leading: InkWell(
          onTap: () {
            backToScreen(context: context);
          },
          child: Icon(Icons.arrow_back_ios, color: PickColors.whiteColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Blink Eyes To Take a Selfie!",
                style: CommonTextStyle().subMainHeadingTextStyle.copyWith(
                      color: PickColors.primaryColor,
                      fontSize: 20,
                    ),
              ),
              PickHeightAndWidth.height30,
              Center(
                child: SvgPicture.asset(
                  PickImages.selfieIcon,
                  height: 230,
                ),
              ),
              PickHeightAndWidth.height30,
              Text(
                "For best results, please follow these:",
                style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                      color: PickColors.blackColor,
                      fontSize: 18,
                    ),
              ),
              PickHeightAndWidth.height15,
              Text(
                "Make sure your face fits in the circle.",
                style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                      color: PickColors.blackColor,
                    ),
              ),
              PickHeightAndWidth.height10,
              Text(
                "Blink your eyes multiple times to capture the selfie.",
                style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                      color: PickColors.blackColor,
                    ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonMaterialButton(
        title: "TAKE SELFIE",
        borderRadius: 0.0,
        onPressed: () async {},
      ),
    );
  }
}
