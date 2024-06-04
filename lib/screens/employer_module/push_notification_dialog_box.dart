import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/functions/toast_msg.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/employer_module/employer_provider/dashboard_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/form_builder_controls/text_field_control.dart';
import 'package:provider/provider.dart';

class PushNotificationDialogBox extends StatefulWidget {
  final dynamic deviceIdList;
  const PushNotificationDialogBox({super.key, this.deviceIdList});

  @override
  State<PushNotificationDialogBox> createState() =>
      _PushNotificationDialogBoxState();
}

class _PushNotificationDialogBoxState extends State<PushNotificationDialogBox> {
  bool isLoading = false;
  final pushNotificationFormKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2(builder: (BuildContext context, GeneralHelper helper,
        AuthProvider authProvider, snapshot) {
      return SimpleDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        title: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  helper.translateTextTitle(titleText: "Push Notification"),
                  style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                        color: PickColors.blackColor,
                        fontSize: 20,
                      ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                backToScreen(context: context);
              },
              child: SvgPicture.asset(
                alignment: Alignment.centerRight,
                PickImages.cancelIcon,
              ),
            ),
          ],
        ),
        children: [
          SizedBox(
            width: 480,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : FormBuilder(
                    key: pushNotificationFormKey,
                    child: Column(
                      children: [
                        PickHeightAndWidth.height20,
                        CommonFormBuilderTextField(
                          maxLines: 4,
                          fieldName: "Message",
                          isRequired: true,
                          hint: "Type your message...",
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: helper.translateTextTitle(
                                    titleText: "Type your message first")),
                          ]),
                          onChanged: (value) {},
                          keyboardType: TextInputType.text,
                        ),
                        PickHeightAndWidth.height10,
                        CommonMaterialButton(
                          title: helper.translateTextTitle(
                                  titleText: "Send Notification") ??
                              "-",
                          onPressed: () async {
                            if (pushNotificationFormKey.currentState!
                                .validate()) {
                              final employerDashboardProvider =
                                  Provider.of<EmployerDashboardProvider>(
                                      context,
                                      listen: false);
                              //Save  Form Data
                              pushNotificationFormKey.currentState!.save();

                              var createdNotificationData = {
                                "deviceIdList": widget.deviceIdList,
                                "notificationMessage": pushNotificationFormKey
                                        .currentState!.value['Message'] ??
                                    ""
                              };

                              showOverlayLoader(context);

                              if (await employerDashboardProvider
                                  .sendPushNotificationToCandidateApiFunction(
                                      context: context,
                                      dataParameter: createdNotificationData)) {
                                backToScreen(context: context);
                                hideOverlayLoader();
                              } else {
                                hideOverlayLoader();
                              }
                            } else {
                              showToast(
                                  message: pushNotificationFormKey
                                              .currentState!.errors[
                                          pushNotificationFormKey
                                              .currentState!.errors.keys
                                              .toList()
                                              .first] ??
                                      "-",
                                  isPositive: false,
                                  context: context);
                            }
                          },
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
