import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';

@RoutePage()
class VideoIdKYCScreen extends StatefulWidget {
  const VideoIdKYCScreen({super.key});

  @override
  State<VideoIdKYCScreen> createState() => _VideoIdKYCScreenState();
}

class _VideoIdKYCScreenState extends State<VideoIdKYCScreen> {
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
                "Important!",
                style: CommonTextStyle().subMainHeadingTextStyle.copyWith(
                      color: PickColors.primaryColor,
                      fontSize: 20,
                    ),
              ),
              PickHeightAndWidth.height10,
              Text(
                "For best results, please follow these:",
                style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                      color: PickColors.blackColor,
                    ),
              ),
              PickHeightAndWidth.height20,
              Center(
                child: SvgPicture.asset(
                  PickImages.cardScanIcon,
                  height: 170,
                  color: PickColors.primaryColor,
                ),
              ),
              PickHeightAndWidth.height5,
              ListView.builder(
                shrinkWrap: true,
                itemCount: videoIdKycInfoList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      videoIdKycInfoList[index],
                      style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                            color: PickColors.blackColor,
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonMaterialButton(
        title: "SCAN DOCUMENT",
        borderRadius: 0.0,
        onPressed: () async {},
      ),
    );
  }
}
