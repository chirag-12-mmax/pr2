import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/widgets/drop_downs/common_dropdown.dart';
import 'package:provider/provider.dart';

class HeadImageWithLogoWidget extends StatelessWidget {
  const HeadImageWithLogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer(
        builder: (BuildContext context, GeneralHelper helper, snapshot) {
      return Container(
        height: checkPlatForm(context: context, platforms: [
          CustomPlatForm.MOBILE,
          CustomPlatForm.MIN_MOBILE,
        ])
            ? SizeConfig.screenHeight! * 0.15
            : SizeConfig.screenHeight! * 0.30,
        width: double.infinity,
        decoration: BoxDecoration(
          color: PickColors.whiteColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          image: const DecorationImage(
            image: AssetImage(PickImages.bgImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            checkPlatForm(context: context, platforms: [
              CustomPlatForm.MOBILE_VIEW,
              CustomPlatForm.MOBILE,
              CustomPlatForm.MIN_MOBILE_VIEW,
              CustomPlatForm.MIN_MOBILE,
            ])
                ? Container()
                : Expanded(child: Container()),
            Expanded(
              flex: checkPlatForm(context: context, platforms: [
                CustomPlatForm.MOBILE_VIEW,
                CustomPlatForm.MOBILE,
                CustomPlatForm.MIN_MOBILE_VIEW,
                CustomPlatForm.MIN_MOBILE,
              ])
                  ? 1
                  : checkPlatForm(context: context, platforms: [
                      CustomPlatForm.TABLET_VIEW,
                      CustomPlatForm.MIN_LAPTOP_VIEW,
                      CustomPlatForm.TABLET,
                    ])
                      ? 2
                      : 5,
              child: Align(
                alignment: checkPlatForm(context: context, platforms: [
                  CustomPlatForm.MOBILE_VIEW,
                  CustomPlatForm.MOBILE,
                  CustomPlatForm.MIN_MOBILE_VIEW,
                  CustomPlatForm.MIN_MOBILE,
                ])
                    ? Alignment.topLeft
                    : Alignment.topCenter,
                child: Padding(
                  padding: checkPlatForm(context: context, platforms: [
                    CustomPlatForm.MOBILE_VIEW,
                    CustomPlatForm.MOBILE,
                    CustomPlatForm.MIN_MOBILE_VIEW,
                    CustomPlatForm.MIN_MOBILE,
                  ])
                      ? const EdgeInsets.only(top: 10, left: 20)
                      : EdgeInsets.zero,
                  child: Image.asset(
                    PickImages.logo,
                    color: PickColors.whiteColor,
                    scale: checkPlatForm(context: context, platforms: [
                      CustomPlatForm.MOBILE_VIEW,
                      CustomPlatForm.MOBILE,
                      CustomPlatForm.MIN_MOBILE_VIEW,
                      CustomPlatForm.MIN_MOBILE,
                    ])
                        ? 2.5
                        : 2,
                  ),
                ),
              ),
            ),
            if (helper.languagesList.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20),
                  child: CommonDropDownWithoutSearch(
                    borderColor: PickColors.hintColor,
                    isExpanded: true,
                    isRequired: true,
                    hintText: 'Select Language',
                    initialValue: helper.selectedLanguage ??
                        (helper.languagesList.firstWhere(
                            (element) =>
                                (element.shortName.toString().toLowerCase() ==
                                    'english'),
                            orElse: () => helper.languagesList.first)),
                    onChanged: (value) async {
                      await helper.getAllLanguagesDataFromURLFunction(
                          languageFileURl: value.languageFileURL!,
                          isFromSecondary: false,
                          context: context);

                      helper.selectedLanguage = value;
                    },
                    name: 'Select Language',
                    items: helper.languagesList
                        .map((languageData) => DropdownMenuItem(
                              value: languageData,
                              child: Text(languageData.name ?? ""),
                            ))
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
