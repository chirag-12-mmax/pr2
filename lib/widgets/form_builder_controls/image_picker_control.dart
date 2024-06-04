import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/services/image_picker.dart';
import 'package:provider/provider.dart';

class ImagePickerControl extends StatefulWidget {
  const ImagePickerControl({
    super.key,
    required this.fieldName,
    this.bgColor,
    this.isEnabled = true,
    this.isRequired = false,
    this.onFileChange,
    this.isCandidatePhotoLabel = false,
  });

  final String fieldName;
  final Color? bgColor;
  final bool isEnabled;
  final bool isCandidatePhotoLabel;
  final bool isRequired;
  final dynamic onFileChange;

  @override
  State<ImagePickerControl> createState() => _ImagePickerControlState();
}

class _ImagePickerControlState extends State<ImagePickerControl> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, GeneralHelper helper, snapshot) {
      return FormBuilderField(
          name: widget.fieldName,
          validator: FormBuilderValidators.compose([
            if (widget.isRequired)
              FormBuilderValidators.required(
                  errorText: helper.translateTextTitle(
                      titleText:
                          "Profile Image is Mandatory Please Select Profile picture.")),
          ]),
          onChanged: widget.onFileChange,
          builder: (FormFieldState<dynamic> field) {
            print("============My Value===${field.value ?? []}============");

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () async {
                    if ((field.value ?? []).isEmpty ||
                        ((field.value.last ?? "") == "")) {
                      XFile? pickedImage = await CustomImagePicker.show(
                        context,
                        !checkPlatForm(context: context, platforms: [
                          CustomPlatForm.MIN_MOBILE,
                          CustomPlatForm.MOBILE,
                          CustomPlatForm.TABLET,
                        ]),
                      );

                      // List<XFile?> imagesList = [];
                      // if (field.value != null) {
                      //   imagesList.addAll(field.value);
                      // }
                      // imagesList.add(pickedImage);
                      field.didChange([pickedImage]);
                    }
                  },
                  child: MouseRegion(
                    hitTestBehavior: HitTestBehavior.deferToChild,
                    cursor: SystemMouseCursors.click,
                    child: (field.value ?? []).isEmpty ||
                            ((field.value.last ?? "") == "")
                        ? Container(
                            constraints:
                                BoxConstraints(maxHeight: 120, maxWidth: 120),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.bgColor ?? PickColors.bgColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                PickImages.editPerson,
                                fit: BoxFit.contain,
                                color: PickColors.hintColor,
                                alignment: Alignment.center,
                              ),
                            ))
                        : Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    maxHeight: 120, maxWidth: 120),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: checkPlatForm(
                                                  context: context,
                                                  platforms: [
                                                    CustomPlatForm.MIN_MOBILE,
                                                    CustomPlatForm.MOBILE,
                                                    CustomPlatForm.TABLET,
                                                  ]) &&
                                              !field.value.last.path.contains(
                                                  'Documents/Recruitment/CandidatePhoto')
                                          ? FileImage(
                                              File(field.value.last.path))
                                          : NetworkImage(field.value.last.path)
                                              as ImageProvider,
                                    ),
                                    color:
                                        widget.bgColor ?? PickColors.bgColor),
                              ),
                              Positioned(
                                top: -10,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    field.didChange([]);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.7),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    height: 22,
                                    width: 22,
                                    child: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.white,
                                    ),
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
    });
  }
}
