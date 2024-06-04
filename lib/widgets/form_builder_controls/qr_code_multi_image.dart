import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/services/image_picker.dart';
import 'package:provider/provider.dart';

class QRCodeMultiImagePicker extends StatefulWidget {
  const QRCodeMultiImagePicker({
    super.key,
    required this.fieldName,
    this.bgColor,
    this.isEnabled = true,
    this.isRequired = false,
    this.onFileChange,
  });

  final String fieldName;
  final Color? bgColor;
  final bool isEnabled;
  final bool isRequired;
  final dynamic onFileChange;

  @override
  State<QRCodeMultiImagePicker> createState() => _QRCodeMultiImagePickerState();
}

class _QRCodeMultiImagePickerState extends State<QRCodeMultiImagePicker> {
  final ValueNotifier<bool> _showLeftArrow = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _showRightArrow = ValueNotifier<bool>(false);
  ScrollController yourScrollController = ScrollController();

  void _handleScrollButtonsVisibility() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _showLeftArrow.value = yourScrollController.position.pixels >
          yourScrollController.position.minScrollExtent;

      _showRightArrow.value = yourScrollController.position.pixels <
          yourScrollController.position.maxScrollExtent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, GeneralHelper helper, snapshot) {
      // final yourScrollController = ScrollController();
      return FormBuilderField(
          name: widget.fieldName,
          validator: FormBuilderValidators.compose([
            if (widget.isRequired)
              FormBuilderValidators.required(
                  errorText: helper.translateTextTitle(
                      titleText:
                          "Profile Image is Mandatory Please Select Profile")),
          ]),
          onChanged: widget.onFileChange,
          builder: (FormFieldState<dynamic> field) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: () async {
                          XFile? pickedImage = await CustomImagePicker.show(
                            context,
                            true,
                          );

                          List<XFile?> imagesList = [];
                          if (field.value != null) {
                            imagesList.addAll(field.value);
                          }
                          imagesList.add(pickedImage);
                          field.didChange(imagesList);
                          _handleScrollButtonsVisibility();
                        },
                        child: Container(
                          child: const Icon(
                            Icons.camera_enhance,
                            color: Colors.red,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if ((field.value ?? []).isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          flex: checkPlatForm(context: context, platforms: [
                            CustomPlatForm.MIN_LAPTOP_VIEW,
                            CustomPlatForm.MIN_MOBILE,
                            CustomPlatForm.MOBILE,
                            CustomPlatForm.MOBILE_VIEW
                          ])
                              ? 2
                              : 1,
                          child: ValueListenableBuilder<bool>(
                              valueListenable: _showLeftArrow,
                              builder: (context, value, child) {
                                if (value) {
                                  return GestureDetector(
                                    onTap: () {
                                      yourScrollController.animateTo(
                                        yourScrollController.position.pixels -
                                            100,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          Colors.grey.withOpacity(.7),
                                      child: const Icon(
                                          Icons.chevron_left_rounded,
                                          color: Colors.white),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 12,
                          child: SizedBox(
                            height: 100,
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                                _handleScrollButtonsVisibility();
                                return false; // Return false to allow the notification to continue to be dispatched.
                              },
                              child: ListView.builder(
                                  itemCount: field.value.length,
                                  controller: yourScrollController,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 3.0, right: 5),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: 130,
                                            width: 115,
                                            child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: checkPlatForm(
                                                      context: context,
                                                      platforms: [
                                                    CustomPlatForm.MIN_MOBILE,
                                                    CustomPlatForm.MOBILE,
                                                    CustomPlatForm.TABLET,
                                                  ])
                                                  ? Image.file(File(
                                                      field.value[index].path))
                                                  : Image.network(
                                                      field.value[index].path),
                                            ),
                                          ),
                                          PositionedDirectional(
                                            top: 0,
                                            end: 0,
                                            child: InkWell(
                                              onTap: () {
                                                // state.focus();

                                                // (field.value[index].path).toList()..removeAt(index);
                                                print(
                                                    "REMOVE ${field.value[index].path}");

                                                field.value.removeAt(index);

                                                field.didChange(
                                                  field.value,
                                                );
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(.7),
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
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: checkPlatForm(context: context, platforms: [
                            CustomPlatForm.MIN_LAPTOP_VIEW,
                            CustomPlatForm.MIN_MOBILE,
                            CustomPlatForm.MOBILE,
                            CustomPlatForm.MOBILE_VIEW
                          ])
                              ? 2
                              : 1,
                          child: ValueListenableBuilder<bool>(
                              valueListenable: _showRightArrow,
                              builder: (context, value, child) {
                                if (value) {
                                  return GestureDetector(
                                    onTap: () {
                                      yourScrollController.animateTo(
                                        yourScrollController.position.pixels +
                                            100,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Colors.grey.withOpacity(.7),
                                      child: const Icon(
                                          Icons.chevron_right_rounded,
                                          color: Colors.white),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ),
                      ],
                    ),
                ],
              ),
            );
          });
    });
  }
}
