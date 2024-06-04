// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_device_info.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/common_fields.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/footer_widget.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/head_image_with_logo_widget.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/request_otp_dialog_box.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/rich_text_widget.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/request_otp.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:provider/provider.dart';
import '../../../constants/navigation/app_router.gr.dart';

@RoutePage()
class SetQuickPinScreen extends StatefulWidget {
  const SetQuickPinScreen({super.key});

  @override
  State<SetQuickPinScreen> createState() => _SetQuickPinScreenState();
}

class _SetQuickPinScreenState extends State<SetQuickPinScreen> {
  TextEditingController setQuickPinCompanyCodeController =
      TextEditingController();
  TextEditingController setQuickPinApplicantIdController =
      TextEditingController();
  final sendOtpForQuickPinFormKey = GlobalKey<FormState>();

  bool isButtonLoading = false;

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
              key: sendOtpForQuickPinFormKey,
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
                                  titleText: "Set Quick PIN") ??
                              "-",
                          style: CommonTextStyle().mainHeadingTextStyle,
                        ),
                        PickHeightAndWidth.height20,
                        Text(
                          helper.translateTextTitle(
                              titleText:
                                  "Please enter your credentials to set Quick Pin"),
                          style: CommonTextStyle().noteHeadingTextStyle,
                        ),
                        PickHeightAndWidth.height20,
                        getCompanyCodeField(
                            helper, setQuickPinCompanyCodeController, context),
                        getApplicantIdField(
                            helper, setQuickPinApplicantIdController, context),
                        PickHeightAndWidth.height20,
                        CommonMaterialButton(
                          title: helper.translateTextTitle(
                                  titleText: "Request OTP") ??
                              "-",
                          // isLoading: isButtonLoading,
                          onPressed: () async {
                            final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);
                            if (sendOtpForQuickPinFormKey.currentState!
                                .validate()) {
                              //Set Dynamic Base URL
                              await authProvider
                                  .setServerConfigurationURLFunction(
                                      subscription:
                                          setQuickPinCompanyCodeController.text,
                                      context: context);

                              showOverlayLoader(context);

                              if (await authProvider
                                  .requestOtpForSetQuickPinApiFunction(
                                      context: context,
                                      requestData: RequestOtpModel(
                                        deviceId:
                                            CurrentDeviceInformation.deviceId,
                                        deviceManufacturerName:
                                            CurrentDeviceInformation
                                                .deviceMenuFracturesName,
                                        deviceOS:
                                            CurrentDeviceInformation.deviceOS,
                                        obApplicantId:
                                            setQuickPinApplicantIdController
                                                .text,
                                        subscriptionName:
                                            setQuickPinCompanyCodeController
                                                .text,
                                      ))) {
                                hideOverlayLoader();
                                await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return RequestOtpDialogBox(
                                      applicationId:
                                          setQuickPinApplicantIdController.text,
                                      onSubmitOTP: (enteredOTP) async {
                                        showOverlayLoader(context);
                                        if (await authProvider
                                            .verifyOtpForSetQuickPinApiFunction(
                                          context: context,
                                          requestData: RequestOtpModel(
                                              deviceId: CurrentDeviceInformation
                                                  .deviceId,
                                              deviceManufacturerName:
                                                  CurrentDeviceInformation
                                                      .deviceMenuFracturesName,
                                              deviceOS: CurrentDeviceInformation
                                                  .deviceOS,
                                              obApplicantId:
                                                  setQuickPinApplicantIdController
                                                      .text,
                                              subscriptionName:
                                                  setQuickPinCompanyCodeController
                                                      .text,
                                              source: "mobile",
                                              verificationCode: enteredOTP),
                                        )) {
                                          hideOverlayLoader();
                                          backToScreen(context: context);
                                          moveToNextScreen(
                                              context: context,
                                              pageRoute: SetYourQuickPinScreen(
                                                  applicationId:
                                                      setQuickPinApplicantIdController
                                                          .text,
                                                  subscriptionId:
                                                      setQuickPinCompanyCodeController
                                                          .text,
                                                  verificationCode:
                                                      enteredOTP));
                                        } else {
                                          hideOverlayLoader();
                                        }
                                      },
                                      subscriptionId:
                                          setQuickPinCompanyCodeController.text,
                                    );
                                  },
                                );
                              } else {
                                hideOverlayLoader();
                              }
                              hideOverlayLoader();
                            }
                          },
                        ),
                        if (checkPlatForm(context: context, platforms: [
                          CustomPlatForm.MOBILE,
                          CustomPlatForm.TABLET,
                          CustomPlatForm.MIN_MOBILE,
                        ]))
                          PickHeightAndWidth.height30,
                        if (checkPlatForm(context: context, platforms: [
                          CustomPlatForm.MOBILE,
                          CustomPlatForm.TABLET,
                          CustomPlatForm.MIN_MOBILE,
                        ]))
                          Center(
                            child: RichTextWidget(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  backToPreviousScreen(context: context);
                                },
                              mainTitleColor: PickColors.hintColor,
                              subTitleColor: PickColors.blackColor,
                              mainTitle: helper.translateTextTitle(
                                  titleText: "Back To") + " ",

                              subTitle: helper.translateTextTitle(
                                      titleText: "Login") ??
                                  "-",
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const FooterWidget(),
      );
    });
  }
}
