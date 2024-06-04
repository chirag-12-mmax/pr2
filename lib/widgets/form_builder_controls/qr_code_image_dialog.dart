import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/text_style.dart';

import 'package:onboarding_app/functions/toast_msg.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';

import 'package:onboarding_app/widgets/form_builder_controls/qr_code_multi_image.dart';
import 'package:provider/provider.dart';

class QRCodeMultiImageDialogWidget extends StatefulWidget {
  final String? title;
  final bool isIcon;
  final bool isCancel;
  final String? subTitle;
  final String? buttonTitle;
  final dynamic onPressButton;

  const QRCodeMultiImageDialogWidget({
    super.key,
    this.title,
    this.subTitle,
    this.buttonTitle,
    this.isIcon = false,
    this.isCancel = false,
    this.onPressButton,
  });

  @override
  State<QRCodeMultiImageDialogWidget> createState() =>
      _QRCodeMultiImageDialogWidgetState();
}

class _QRCodeMultiImageDialogWidgetState
    extends State<QRCodeMultiImageDialogWidget> {
  List<dynamic> pickedImagesList = [];
  final qrCodeFormKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, GeneralHelper helper, snapshot) {
      return SimpleDialog(
        title: widget.title != null
            ? Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.title ?? "-",
                        style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                              color: PickColors.blackColor,
                              fontSize: 20,
                            ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      backToScreen(context: context);
                    },
                    child: SvgPicture.asset(
                      alignment: Alignment.centerRight,
                      PickImages.cancelIcon,
                    ),
                  ),
                ],
              )
            : null,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: FormBuilder(
              key: qrCodeFormKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    width: 400,
                    child: Center(
                      child: QRCodeMultiImagePicker(
                          fieldName: "image",
                          isEnabled: true,
                          onFileChange: (value) async {
                            print("========${value}");
                            if ((value ?? []).length >
                                pickedImagesList.length) {
                              qrCodeFormKey.currentState!.save();
                              var tempImage =
                                  pickedImagesList.firstWhere((element) {
                                return element.name == value.last.name;
                              }, orElse: () => null);

                              if (tempImage != null) {
                                qrCodeFormKey.currentState!.value["image"]
                                    .remove(value.last);
                                showToast(
                                    message:
                                        "Please select a different file because this file already exists",
                                    isPositive: false,
                                    context: context);
                              }
                            }

                            setState(() {
                              pickedImagesList = value;
                            });
                          }),
                    ),
                  ),
                  Row(
                    children: [
                      if (widget.isCancel)
                        Expanded(
                          child: CommonMaterialButton(
                            borderColor: PickColors.primaryColor,
                            color: PickColors.whiteColor,
                            title: helper.translateTextTitle(
                                    titleText: "Cancel") ??
                                "-",
                            style: CommonTextStyle().buttonTextStyle.copyWith(
                                  color: PickColors.primaryColor,
                                ),
                            onPressed: () {
                              backToScreen(context: context);
                            },
                          ),
                        ),
                      if (widget.isCancel) PickHeightAndWidth.width10,
                      if (pickedImagesList.isNotEmpty)
                        Expanded(
                          child: CommonMaterialButton(
                            title: widget.buttonTitle ?? "-",
                            onPressed: () {
                              widget.onPressButton(pickedImagesList);
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
