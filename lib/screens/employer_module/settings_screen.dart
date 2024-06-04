import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/share_pref_keys.dart';
import 'package:onboarding_app/constants/share_preference.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/constants/them_color_text.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, GeneralHelper helper, snapshot) {
      return Scaffold(
        backgroundColor: PickColors.bgColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: PickColors.whiteColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    helper.translateTextTitle(titleText: "Color Setting"),
                    style: CommonTextStyle().subMainHeadingTextStyle,
                  ),
                  PickHeightAndWidth.height10,
                  const Divider(),
                  PickHeightAndWidth.height10,
                  ListView.builder(
                    itemCount: GlobalList.settingDataList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                helper.translateTextTitle(
                                    titleText: GlobalList.settingDataList[index]
                                        ["title"]),
                                style: CommonTextStyle()
                                    .noteHeadingTextStyle
                                    .copyWith(
                                      color: PickColors.blackColor,
                                    ),
                              ),
                            ),
                            Text(
                              "#${helper.themColorData[GlobalList.settingDataList[index]["key"]].toRadixString(16).padLeft(8, "0")}",
                              style: CommonTextStyle()
                                  .noteHeadingTextStyle
                                  .copyWith(
                                    color: PickColors.blackColor,
                                  ),
                            ),
                            PickHeightAndWidth.width10,
                            InkWell(
                              onTap: () async {
                                // Temporary variable to hold the color selected by the picker
                                Color temporaryColor = Color(helper
                                        .themColorData[
                                    GlobalList.settingDataList[index]["key"]]);
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: PickColors.bgColor,
                                      title: Text(helper.translateTextTitle(
                                          titleText: "Pick a Color")),
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: temporaryColor,
                                          onColorChanged: (Color color) {
                                            // Update the temporary color variable
                                            temporaryColor = color;
                                          },
                                          // ignore: deprecated_member_use
                                          showLabel: true,
                                          pickerAreaHeightPercent: 0.8,
                                          hexInputBar: true,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        CommonMaterialButton(
                                          height: 50,
                                          width: 100,
                                          title: helper.translateTextTitle(
                                                  titleText: "Okay") ??
                                              "-",
                                          onPressed: () {
                                            // Update the list with the new color when ‘OK’ is pressed
                                            helper.themColorData[GlobalList
                                                    .settingDataList[index]
                                                ["key"]] = temporaryColor.value;
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ); // In case the dialog is dismissed, keep the current color
                              },
                              child: Container(
                                height: 30,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Color(helper.themColorData[GlobalList
                                      .settingDataList[index]["key"]]),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  PickHeightAndWidth.height10,
                  Center(
                    child: SizedBox(
                      width: checkPlatForm(context: context, platforms: [
                        CustomPlatForm.MOBILE,
                        CustomPlatForm.MOBILE_VIEW,
                        CustomPlatForm.TABLET,
                        CustomPlatForm.TABLET_VIEW,
                        CustomPlatForm.MIN_MOBILE_VIEW,
                        CustomPlatForm.MIN_MOBILE,
                      ])
                          ? SizeConfig.screenWidth
                          : SizeConfig.screenWidth! / 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: CommonMaterialButton(
                              color: Colors.transparent,
                              borderColor: PickColors.primaryColor,
                              title:
                                  helper.translateTextTitle(titleText: "Reset"),
                              style: CommonTextStyle()
                                  .buttonTextStyle
                                  .copyWith(color: PickColors.primaryColor),
                              onPressed: () async {
                                final helper = Provider.of<GeneralHelper>(
                                    context,
                                    listen: false);
                                helper.themColorData = {
                                  ThemColorText.primaryColorText:
                                      Color(0xffFE464B).value,
                                  ThemColorText.secondaryColorText:
                                      Color(0xffF4F6FA).value,
                                  ThemColorText.textColorText:
                                      Color(0xff1A1B1E).value
                                };
                                Shared_Preferences.prefSetString(
                                    SharedP.themColorListKey,
                                    jsonEncode(helper.themColorData));
                                setState(() {});
                                helper.updateThemColor();
                              },
                            ),
                          ),
                          PickHeightAndWidth.width10,
                          Expanded(
                            child: CommonMaterialButton(
                              title: helper.translateTextTitle(
                                      titleText: "Save") ??
                                  "-",
                              onPressed: () async {
                                await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return CommonConfirmationDialogBox(
                                      buttonTitle: helper.translateTextTitle(
                                          titleText: "Yes"),
                                      cancelButtonTitle: helper
                                          .translateTextTitle(titleText: "No"),
                                      isCancel: true,
                                      title: helper.translateTextTitle(
                                          titleText: "Alert"),
                                      subTitle:
                                          "Are you sure you want to change theme colors ?",
                                      onPressButton: () async {
                                        final helper =
                                            Provider.of<GeneralHelper>(context,
                                                listen: false);
                                        Shared_Preferences.prefSetString(
                                            SharedP.themColorListKey,
                                            jsonEncode(helper.themColorData));
                                        helper.updateThemColor();
                                        setState(() {});

                                        backToScreen(context: context);
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
