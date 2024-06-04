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

@RoutePage()
class SdkDashboardScreen extends StatefulWidget {
  const SdkDashboardScreen({super.key});

  @override
  State<SdkDashboardScreen> createState() => _SdkDashboardScreenState();
}

class _SdkDashboardScreenState extends State<SdkDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: PickColors.primaryColor,
        title: const Text("Select Government ID"),
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
              PickHeightAndWidth.height20,
              GridView.builder(
                shrinkWrap: true,
                itemCount: sdkDataList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        moveToNextScreenWithRoute(
                            context: context,
                            routePath: sdkDataList[index]["path"]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: PickColors.whiteColor,
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0.0, 1.0),
                                blurRadius: 3,
                                color: Color.fromRGBO(0, 0, 0, 0.16),
                              )
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              sdkDataList[index]["icon"],
                              color: PickColors.primaryColor,
                              height: 60,
                            ),
                            PickHeightAndWidth.height10,
                            Text(
                              sdkDataList[index]["title"],
                              style: CommonTextStyle().buttonTextStyle.copyWith(
                                    color: PickColors.primaryColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                  ),
                            )
                          ],
                        ),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
