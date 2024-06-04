import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:provider/provider.dart';

class ProceedToWidget extends StatelessWidget {
  const ProceedToWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2(builder: (BuildContext context, GeneralHelper helper,
        AuthProvider authProvider, snapshot) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: PickColors.whiteColor,
            ),
            width: SizeConfig.screenWidth,
            child: Column(
              children: [
                Text(
                  "${helper.translateTextTitle(titleText: "Welcome")} ${authProvider.applicantInformation!.candidateFirstName.toString()} !",
                  style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                        color: PickColors.primaryColor,
                      ),
                ),
                PickHeightAndWidth.height20,
                Image.asset(
                  PickImages.hiredIcon,
                  height: 100,
                  width: 100,
                ),
                PickHeightAndWidth.height20,
                Text(
                  authProvider.applicantInformation!.designation.toString(),
                  style: CommonTextStyle().textFieldLabelTextStyle.copyWith(
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ),
          PickHeightAndWidth.height40,
          Text(
            authProvider.applicantInformation!.statusScreenMessage.toString(),
            textAlign: TextAlign.center,
            style: CommonTextStyle().textFieldLabelTextStyle.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
          ),
          PickHeightAndWidth.height80,
          Container(
            constraints: const BoxConstraints(minWidth: 350),
            width: SizeConfig.screenWidth! * 0.20,
            child: CommonMaterialButton(
              title: helper.translateTextTitle(titleText: "Proceed") ?? "-",
              onPressed: () async {
                final helper =
                    Provider.of<GeneralHelper>(context, listen: false);

                if (authProvider.candidateCurrentStage ==
                    CandidateStages.OFFER_ACCEPTANCE) {
                  authProvider.changeForFirstTime();
                } else {
                  moveToNextScreenWithRoute(
                      context: context, routePath: AppRoutesPath.DOCUMENT);
                  //Change Selection Of Drawer When Back to Old Screen
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    helper.setSelectedDrawerPagePath(
                        pagePath: AppRoutesPath.DOCUMENT);
                  });
                }
              },
            ),
          ),
        ],
      );
    });
  }
}
