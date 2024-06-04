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
class AadhaarAuthenticationScreen extends StatefulWidget {
  const AadhaarAuthenticationScreen({super.key});

  @override
  State<AadhaarAuthenticationScreen> createState() =>
      _AadhaarAuthenticationScreenState();
}

class _AadhaarAuthenticationScreenState
    extends State<AadhaarAuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: PickColors.primaryColor,
        title: const Text("Aadhaar Authentication"),
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
                PickImages.zingHrLogo
                // scale: 5,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "How would you like to upload the XML?",
                    style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                          color: PickColors.blackColor,
                        ),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: aadhaarAuthenticationDataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ChooseMethodBoxWidget(
                    title: aadhaarAuthenticationDataList[index]["title"],
                    subTitle: aadhaarAuthenticationDataList[index]["subTitle"],
                    icon: aadhaarAuthenticationDataList[index]["icon"],
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
