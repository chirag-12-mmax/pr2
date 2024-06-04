import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/screens/employer_module/sdk_module/sdk_common/choose_method_box_widget.dart';

@RoutePage()
class AadhaarChooseMethodScreen extends StatefulWidget {
  const AadhaarChooseMethodScreen({super.key});

  @override
  State<AadhaarChooseMethodScreen> createState() =>
      _AadhaarChooseMethodScreenState();
}

class _AadhaarChooseMethodScreenState extends State<AadhaarChooseMethodScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: PickColors.primaryColor,
        title: const Text("Choose Method"),
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
              // SvgPicture.network(
              Image.asset(
                PickImages.zingHrLogo,
                // scale: 5,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "How would you like to do your KYC?",
                    style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                          color: PickColors.blackColor,
                        ),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: aadhaarChooseMethodDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      moveToNextScreenWithRoute(
                          context: context,
                          routePath: aadhaarChooseMethodDataList[index]
                              ["path"]);
                    },
                    child: ChooseMethodBoxWidget(
                      title: aadhaarChooseMethodDataList[index]["title"],
                      subTitle: aadhaarChooseMethodDataList[index]["subTitle"],
                      icon: aadhaarChooseMethodDataList[index]["icon"],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
