import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_models/attribute_detail_model.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_provider/qr_code_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:onboarding_app/widgets/form_builder_controls/dropdown_control.dart';
import 'package:provider/provider.dart';

class CandidateAttributesScreen extends StatefulWidget {
  const CandidateAttributesScreen({super.key});

  @override
  State<CandidateAttributesScreen> createState() =>
      _CandidateAttributesScreenState();
}

class _CandidateAttributesScreenState extends State<CandidateAttributesScreen> {
  final _personalFormKey = GlobalKey<FormBuilderState>();
  List<FocusNode> _focusNode = [];

  @override
  void initState() {
    // TODO: implement initState
    initializeFormData();
    super.initState();
  }

  initializeFormData() {
    final qrCodeProvider = Provider.of<QRCodeProvider>(context, listen: false);
    if (qrCodeProvider.attributeFormData.isEmpty) {
      qrCodeProvider.candidateAttributeData!['attributeDefaultValues']
          .forEach((element) {
        Map<String, dynamic>? defaultAttribute = qrCodeProvider
            .candidateAttributeData!["attributeUnits"]
            .firstWhere((eleUnit) {
          return (eleUnit["attrUnitDesc"].toString() ==
              element["attrValue"].toString());
        }, orElse: () => null);

        qrCodeProvider.attributeFormData[element["attrCode"] ?? ""] =
            defaultAttribute;
      });
    }
    _focusNode = List<FocusNode>.generate(
        (qrCodeProvider.candidateAttributeData!["attributeDetails"] ?? [])
            .length,
        (int index) => FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer2(builder: (BuildContext context,
        QRCodeProvider qrCodeProvider, GeneralHelper helper, snapshot) {
      return FormBuilder(
        key: _personalFormKey,
        initialValue: qrCodeProvider.attributeFormData,
        onChanged: () {
          _personalFormKey.currentState!.save();

          qrCodeProvider.attributeFormData =
              _personalFormKey.currentState!.value;
        },
        child: Container(
          decoration: BoxDecoration(
            color: PickColors.whiteColor,
            // border: Border.all(width: 1, color: PickColors.whiteColor),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                helper.translateTextTitle(
                    titleText:
                        "Thank you! You have successfully scanned your code. We are pleased to process your application for the following"),
                textAlign: TextAlign.center,
                style: CommonTextStyle().noteHeadingTextStyle,
              ),
              PickHeightAndWidth.height25,
              StaggeredGrid.count(
                // crossAxisCount: 1,
                crossAxisCount: checkPlatForm(
                  context: context,
                  platforms: [
                    CustomPlatForm.MOBILE,
                    CustomPlatForm.MOBILE_VIEW,
                    CustomPlatForm.MIN_MOBILE,
                    CustomPlatForm.MIN_MOBILE_VIEW,
                  ],
                )
                    ? 1
                    : 2,
                crossAxisSpacing: 20.0,
                children: List.generate(
                    (qrCodeProvider
                                .candidateAttributeData!["attributeDetails"] ??
                            [])
                        .length, (index) {
                  return CommonFormBuilderDropdown(
                    focusNode: _focusNode[index],
                    fillColor: PickColors.whiteColor,
                    hintText: qrCodeProvider
                        .candidateAttributeData!["attributeDetails"]![index]
                            ["attrDesc"]
                        .toString(),
                    fieldName: qrCodeProvider
                        .candidateAttributeData!["attributeDetails"]![index]
                            ["attrCode"]
                        .toString(),
                    isRequired: qrCodeProvider.candidateAttributeData![
                            "attributeDetails"]![index]["isMandatory"] ??
                        false,
                    isEnabled: qrCodeProvider.candidateAttributeData![
                            "attributeDetails"]![index]["isEditable"] ??
                        false,
                    fullyDisable: !(qrCodeProvider.candidateAttributeData![
                            "attributeDetails"]![index]["isEditable"] ??
                        false),
                    isFromAttribute: true,
                    items: qrCodeProvider
                        .candidateAttributeData!["attributeUnits"]
                        .where((element) =>
                            element["attrId"].toString() ==
                            qrCodeProvider.candidateAttributeData![
                                    "attributeDetails"]![index]["attrId"]
                                .toString())
                        .toList(),
                  );
                }),
              ),
              PickHeightAndWidth.height40,
              SizedBox(
                width: checkPlatForm(context: context, platforms: [
                  CustomPlatForm.MOBILE,
                  CustomPlatForm.MOBILE_VIEW,
                  CustomPlatForm.MIN_MOBILE,
                  CustomPlatForm.MIN_MOBILE_VIEW,
                  CustomPlatForm.TABLET,
                  CustomPlatForm.TABLET_VIEW
                ])
                    ? SizeConfig.screenWidth
                    : SizeConfig.screenWidth! / 2,
                child: Row(
                  children: [
                    Expanded(
                      child: CommonMaterialButton(
                        color: Colors.transparent,
                        borderColor: PickColors.primaryColor,
                        title: helper.translateTextTitle(titleText: "Cancel") ??
                            "-",
                        style: CommonTextStyle()
                            .buttonTextStyle
                            .copyWith(color: PickColors.primaryColor),
                        onPressed: () async {
                          backToPreviousScreen(context: context);
                        },
                      ),
                    ),
                    PickHeightAndWidth.width10,
                    Expanded(
                      child: CommonMaterialButton(
                        title:
                            helper.translateTextTitle(titleText: "Proceed") ??
                                "-",
                        onPressed: () async {
                          if (_personalFormKey.currentState!.validate()) {
                            qrCodeProvider.updateQrCodeScreenIndex(
                                context: context,
                                tabIndex:
                                    qrCodeProvider.qrCodeSelectedTabIndex + 1);
                          } else {
                            await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return CommonConfirmationDialogBox(
                                    buttonTitle: helper.translateTextTitle(
                                        titleText: "Okay"),
                                    title: helper.translateTextTitle(
                                        titleText: "Alert"),
                                    subTitle:
                                        _personalFormKey.currentState!.errors[
                                                _personalFormKey
                                                    .currentState!.errors.keys
                                                    .toList()
                                                    .first] ??
                                            "-",
                                    onPressButton: () async {
                                      backToScreen(context: context);
                                      List<String?> rectList = (qrCodeProvider
                                                      .candidateAttributeData![
                                                  "attributeDetails"] ??
                                              [])
                                          .map((map) => map["attrCode"])
                                          .toList();
                                      print("LIST:  + $rectList");
                                      print("LIST:  + ${rectList.first}");
                                      _focusNode[rectList.indexOf(
                                              _personalFormKey
                                                  .currentState!.errors.keys
                                                  .toList()
                                                  .first)]
                                          .requestFocus();
                                    },
                                  );
                                });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
