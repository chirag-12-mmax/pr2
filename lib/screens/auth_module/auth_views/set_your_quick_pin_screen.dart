// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_device_info.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/functions/toast_msg.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/common_fields.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/head_image_with_logo_widget.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/request_otp.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SetYourQuickPinScreen extends StatefulWidget {
  final String applicationId;
  final String subscriptionId;
  final String verificationCode;
  const SetYourQuickPinScreen(
      {super.key,
      required this.applicationId,
      required this.subscriptionId,
      required this.verificationCode});

  @override
  State<SetYourQuickPinScreen> createState() => _SetYourQuickPinScreenState();
}

class _SetYourQuickPinScreenState extends State<SetYourQuickPinScreen> {
  TextEditingController setYourQuickPinOtpCodeController =
      TextEditingController();
  TextEditingController confirmYourQuickPinOtpCodeController =
      TextEditingController();
  bool isButtonLoading = false;
  bool hasError = false;
  String errorText = "Quick pin can't be blank";
  final setQuickPinFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer2(builder: (BuildContext context, GeneralHelper helper,
        AuthProvider authProvider, snapshot) {
      return Scaffold(
        backgroundColor: PickColors.bgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: setQuickPinFormKey,
              child: Column(
                children: [
                  //================== Head Image With Logo Width ==================================//
                  const HeadImageWithLogoWidget(),

                  PickHeightAndWidth.height40,
                  Container(
                    constraints: const BoxConstraints(minWidth: 400),
                    width: SizeConfig.screenWidth! * 0.40,
                    padding: EdgeInsets.symmetric(
                      horizontal: checkPlatForm(context: context, platforms: [
                        CustomPlatForm.MOBILE,
                        CustomPlatForm.MOBILE_VIEW,
                        CustomPlatForm.MIN_MOBILE_VIEW,
                        CustomPlatForm.MIN_MOBILE,
                      ])
                          ? 20
                          : 0.0,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          checkPlatForm(context: context, platforms: [
                        CustomPlatForm.MOBILE,
                        CustomPlatForm.MIN_MOBILE,
                      ])
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                      children: [
                        Text(
                          helper.translateTextTitle(
                                  titleText: "Set your quick pin") ??
                              "-",
                          style: CommonTextStyle().mainHeadingTextStyle,
                        ),
                        PickHeightAndWidth.height20,
                        Text(
                          helper.translateTextTitle(
                              titleText: "Please set your Quick Pin")!,
                          style: CommonTextStyle().noteHeadingTextStyle,
                        ),
                        PickHeightAndWidth.height20,
                        getOtpCodeField(
                          helper: helper,
                          newContext: context,
                          autoFocus: true,
                          isPassword: true,
                          controller: setYourQuickPinOtpCodeController,
                          pinBoxColor: PickColors.whiteColor,
                          horizontal: 6.0,
                          pinBoxHeight: 60,
                          hasError: hasError,
                          pinBoxLength: 4,
                          pinBoxWidth: 60,
                          onTextChanged: (text) {},
                          labelText: helper.translateTextTitle(
                                  titleText: "Enter your quick pin") ??
                              "-",
                        ),
                        if (hasError)
                          Text(
                            errorText,
                            style:
                                CommonTextStyle().noteHeadingTextStyle.copyWith(
                                      fontWeight: FontWeight.w100,
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                          ),
                        PickHeightAndWidth.height15,
                        getOtpCodeField(
                          helper: helper,
                          autoFocus: true,
                          isPassword: true,
                          pinBoxLength: 4,
                          newContext: context,
                          hasError: hasError,
                          controller: confirmYourQuickPinOtpCodeController,
                          pinBoxColor: PickColors.whiteColor,
                          horizontal: 6.0,
                          pinBoxHeight: 60,
                          pinBoxWidth: 60,
                          onTextChanged: (text) {},
                          labelText: helper.translateTextTitle(
                                  titleText: "Confirm your quick pin") ??
                              "-",
                        ),
                        if (hasError)
                          Text(
                            errorText,
                            style:
                                CommonTextStyle().noteHeadingTextStyle.copyWith(
                                      fontWeight: FontWeight.w100,
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                          ),
                        PickHeightAndWidth.height20,
                        CommonMaterialButton(
                          title:
                              helper.translateTextTitle(titleText: "Set PIN") ??
                                  "-",
                          isLoading: isButtonLoading,
                          onPressed: () async {
                            final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);

                            if (setYourQuickPinOtpCodeController.text.length ==
                                    4 ||
                                confirmYourQuickPinOtpCodeController
                                        .text.length ==
                                    4) {
                              setState(() {
                                hasError = false;
                              });
                            } else {
                              setState(() {
                                hasError = true;
                              });
                            }
                            if (!hasError) {
                              showOverlayLoader(context);
                              if (setYourQuickPinOtpCodeController.text ==
                                  confirmYourQuickPinOtpCodeController.text) {
                                if (await authProvider.setQuickPinApiFunction(
                                    context: context,
                                    requestData: RequestOtpModel(
                                        deviceId:
                                            CurrentDeviceInformation.deviceId,
                                        deviceManufacturerName:
                                            CurrentDeviceInformation
                                                .deviceMenuFracturesName,
                                        deviceOS:
                                            CurrentDeviceInformation.deviceOS,
                                        obApplicantId: widget.applicationId,
                                        subscriptionName: widget.subscriptionId,
                                        source: "mobile",
                                        applicationVersion:
                                            CurrentDeviceInformation
                                                .deviceVersion,
                                        playerId:
                                            CurrentDeviceInformation.deviceId,
                                        quickPin:
                                            setYourQuickPinOtpCodeController
                                                .text,
                                        confirmQuickPin:
                                            confirmYourQuickPinOtpCodeController
                                                .text,
                                        verificationCode:
                                            widget.verificationCode))) {
                                  hideOverlayLoader();
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CommonConfirmationDialogBox(
                                        buttonTitle: helper.translateTextTitle(
                                            titleText: "Okay"),
                                        isIcon: true,
                                        onPressButton: () {
                                          backToScreen(context: context);
                                          backToScreen(context: context);
                                          backToScreen(context: context);
                                        },
                                        subTitle: helper.translateTextTitle(
                                            titleText:
                                                "Quick PIN setup has been successfully done."),
                                        title: helper.translateTextTitle(
                                            titleText: "Success"),
                                      );
                                    },
                                  );
                                } else {
                                  hideOverlayLoader();
                                }
                              } else {
                                showToast(
                                    context: context,
                                    isPositive: false,
                                    message: helper.translateTextTitle(
                                        titleText: "Quick Pin Must Be Match"));
                              }
                              hideOverlayLoader();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
