import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:provider/provider.dart';

class QrCodeUploadImageWidget extends StatefulWidget {
  final String fieldName;
  final String? title;
  final dynamic icon;
  final bool isEnabled;
  final bool isRequired;
  final Color? color;
  final Function(List<PlatformFile>?)? onChanged;
  const QrCodeUploadImageWidget(
      {super.key,
      required this.fieldName,
      required this.isEnabled,
      required this.isRequired,
      this.color,
      this.icon,
      this.title,
      this.onChanged});

  @override
  State<QrCodeUploadImageWidget> createState() =>
      _QrCodeUploadImageWidgetState();
}

class _QrCodeUploadImageWidgetState extends State<QrCodeUploadImageWidget> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer(builder: (context, GeneralHelper helper, snapshot) {
      return FormBuilderFilePicker(
        name: widget.fieldName,
        previewImages: false,
        allowMultiple: false,
        enabled: widget.isEnabled,
        withData: true,
        validator: FormBuilderValidators.compose([
          if (widget.isRequired)
            FormBuilderValidators.required(
                errorText: "${widget.fieldName} is Mandatory"),
        ]),
        onChanged: widget.onChanged,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          // suffix: null,
          // counter: Container(),
        ),
        customFileViewerBuilder: (files, filesSetter) {
          return Container();
        },
        typeSelectors: [
          TypeSelector(
            type: FileType.any,
            selector: Container(
              width: SizeConfig.screenWidth! * 0.15,
              constraints: BoxConstraints(
                minWidth: checkPlatForm(context: context, platforms: [
                  CustomPlatForm.TABLET,
                  CustomPlatForm.TABLET_VIEW,
                ])
                    ? 140
                    : checkPlatForm(context: context, platforms: [
                        CustomPlatForm.MOBILE,
                        CustomPlatForm.MOBILE_VIEW,
                      ])
                        ? 123
                        : 90,
              ),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: PickColors.bgColor,
              ),
              child: Column(
                children: [
                  SvgPicture.asset(
                    PickImages.addFileIcon,
                    height: 40,
                    width: 40,
                  ),
                  PickHeightAndWidth.height15,
                  Text(
                    helper.translateTextTitle(titleText: "Add File") ?? "-",
                    style: CommonTextStyle().textFieldLabelTextStyle.copyWith(
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
            ),
            // SvgPicture.asset(PickImages.addIcon,
            //     width: 19, colorFilter: widget.colorFilter),
          ),
        ],
      );
    });
  }
}
