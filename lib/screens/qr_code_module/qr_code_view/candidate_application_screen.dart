// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_device_info.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/request_otp_dialog_box.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_provider/qr_code_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:onboarding_app/widgets/form_builder_controls/text_field_control.dart';
import 'package:onboarding_app/widgets/information_text_widget.dart';
import 'package:provider/provider.dart';

@RoutePage()
class CandidateApplicationScreen extends StatefulWidget {
  const CandidateApplicationScreen({super.key});

  @override
  State<CandidateApplicationScreen> createState() =>
      _CandidateApplicationScreenState();
}

class _CandidateApplicationScreenState
    extends State<CandidateApplicationScreen> {
  final _candidateApplicationFormKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer2(builder: (BuildContext context,
        QRCodeProvider qrCodeProvider, GeneralHelper helper, snapshot) {
      return Scaffold(
        backgroundColor: PickColors.bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: PickColors.whiteColor,
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              replaceNextScreenWithRoute(
                  context: context, routePath: AppRoutesPath.LOGIN);
            },
            child: Icon(Icons.arrow_back_ios, color: PickColors.blackColor),
          ),
          title: Text(
            helper.translateTextTitle(titleText: "Candidate Application"),
            style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                  fontSize: 24,
                ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  constraints: const BoxConstraints(minHeight: 200),
                  width: SizeConfig.screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: PickColors.whiteColor,
                  ),
                  child: SvgPicture.asset(
                    PickImages.verificationImage,
                    height: 250,
                    // width: 200,
                  ),
                ),
              ),
              PickHeightAndWidth.height35,
              FormBuilder(
                key: _candidateApplicationFormKey,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 450),
                  width: SizeConfig.screenWidth! * 0.42,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        helper.translateTextTitle(titleText: "Verification"),
                        style: CommonTextStyle().subMainHeadingTextStyle,
                      ),
                      PickHeightAndWidth.height15,
                      Text(
                        helper.translateTextTitle(
                                titleText:
                                    "Please login using your mobile number or email id. You shall receive an SMS or Email notification with verification code. Please enter the code to login.") ??
                            "-",
                        style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                              color: PickColors.blackColor,
                            ),
                      ),
                      PickHeightAndWidth.height30,
                      Row(
                        children: [
                          Expanded(
                            child: CommonFormBuilderTextField(
                              bottom: 2,
                              isOnlyUppercase: false,
                              fillColor: true,
                              isRequired: false,
                              fieldName: "country_code",
                              fullyDisable: qrCodeProvider.isMobileDisabled,
                              hint: helper.translateTextTitle(titleText: "CC"),
                              maxCharLength: 3,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],
                              onChanged: (value) {
                                if (value.toString().trim() != "") {
                                  setState(() {
                                    qrCodeProvider.isEmailDisabled = true;
                                  });
                                } else {
                                  setState(() {
                                    qrCodeProvider.isEmailDisabled = false;
                                  });
                                }
                              },
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          PickHeightAndWidth.width10,
                          Expanded(
                            flex: 4,
                            child: CommonFormBuilderTextField(
                              bottom: 2,
                              isOnlyUppercase: false,
                              fillColor: true,
                              fieldName: "mobile",
                              maxCharLength: 11,
                              fullyDisable: qrCodeProvider.isMobileDisabled,
                              isRequired: false,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],
                              hint: helper.translateTextTitle(
                                  titleText: "Mobile"),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.minLength(7,
                                    allowEmpty: true,
                                    errorText: helper.translateTextTitle(
                                        titleText:
                                            "Please Enter Valid Number")),
                              ]),
                              onChanged: (value) {
                                if (value.toString().trim() != "") {
                                  setState(() {
                                    qrCodeProvider.isEmailDisabled = true;
                                  });
                                } else {
                                  setState(() {
                                    qrCodeProvider.isEmailDisabled = false;
                                  });
                                }
                              },
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                      PickHeightAndWidth.height10,
                      InformationTextWidget(
                          textString: helper.translateTextTitle(
                              titleText: "Please check your sms for OTP")),
                      PickHeightAndWidth.height25,
                      Center(
                        child: Text(
                          helper.translateTextTitle(titleText: "OR"),
                          style:
                              CommonTextStyle().noteHeadingTextStyle.copyWith(
                                    color: PickColors.blackColor,
                                  ),
                        ),
                      ),
                      PickHeightAndWidth.height25,
                      CommonFormBuilderTextField(
                        bottom: 2,
                        isOnlyUppercase: false,
                        fillColor: true,
                        fieldName: "email",
                        fullyDisable: qrCodeProvider.isEmailDisabled,
                        hint: helper.translateTextTitle(titleText: "Email ID"),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp('[+]')),
                        ],
                        validator: FormBuilderValidators.compose([
                          (value) {
                            if ((value ?? "").toString().trim() != "") {
                              // Custom validator using the provided regular expression
                              RegExp regex = RegExp(
                                r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                              );
                              if (value != null && !regex.hasMatch(value)) {
                                return 'Please Enter Valid Email Address';
                              }
                              return null;
                            } else {
                              return null;
                            }
                          },
                        ]),
                        onChanged: (value) {
                          if (value.toString().trim() != "") {
                            setState(() {
                              qrCodeProvider.isMobileDisabled = true;
                            });
                          } else {
                            setState(() {
                              qrCodeProvider.isMobileDisabled = false;
                            });
                          }
                        },
                        isRequired: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      PickHeightAndWidth.height10,
                      InformationTextWidget(
                        textString: helper.translateTextTitle(
                            titleText: "Please check your email for OTP"),
                      ),
                      PickHeightAndWidth.height30,
                      CommonMaterialButton(
                        title: helper.translateTextTitle(
                                titleText: "Request OTP") ??
                            "-",
                        onPressed: () async {
                          if (_candidateApplicationFormKey.currentState!
                              .validate()) {
                            _candidateApplicationFormKey.currentState!.save();

                            if ((!qrCodeProvider.isMobileDisabled &&
                                !qrCodeProvider.isEmailDisabled)) {
                              await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return CommonConfirmationDialogBox(
                                    buttonTitle: helper.translateTextTitle(
                                        titleText: "Okay"),
                                    title: helper.translateTextTitle(
                                        titleText: "Alert"),
                                    subTitle: helper.translateTextTitle(
                                        titleText:
                                            "Please enter any of (Mobile/Email) detail to proceed."),
                                    onPressButton: () async {
                                      backToScreen(context: context);
                                    },
                                  );
                                },
                              );
                            } else {
                              //Set Data For Further Use

                              if (qrCodeProvider.isEmailDisabled) {
                                if ((_candidateApplicationFormKey.currentState!
                                                    .value["country_code"] ??
                                                "")
                                            .toString()
                                            .trim() ==
                                        "" ||
                                    (_candidateApplicationFormKey.currentState!
                                                    .value["mobile"] ??
                                                "")
                                            .toString()
                                            .trim() ==
                                        "") {
                                  await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return CommonConfirmationDialogBox(
                                        buttonTitle: helper.translateTextTitle(
                                            titleText: "Okay"),
                                        title: helper.translateTextTitle(
                                            titleText: "Alert"),
                                        subTitle: helper.translateTextTitle(
                                            titleText:
                                                "Please enter ${(_candidateApplicationFormKey.currentState!.value["country_code"] ?? "").toString().trim() == "" ? "CC" : "Mobile"} detail to proceed."),
                                        onPressButton: () async {
                                          backToScreen(context: context);
                                        },
                                      );
                                    },
                                  );
                                  return;
                                }
                              }

                              //Request OTP For Create Candidate
                              qrCodeProvider.emailIdForQrCandidate =
                                  _candidateApplicationFormKey
                                      .currentState!.value["email"];
                              qrCodeProvider.countryCodeForQrCandidate =
                                  _candidateApplicationFormKey
                                      .currentState!.value["country_code"];
                              qrCodeProvider.mobileNumberForQrCandidate =
                                  _candidateApplicationFormKey
                                      .currentState!.value["mobile"];

                              showOverlayLoader(context);
                              if (await qrCodeProvider
                                  .sendOTPForQRcodeCandidateApiFunction(
                                      context: context,
                                      dataParameter: {
                                    "subscriptionName":
                                        qrCodeProvider.qrCodeSubscription,
                                    "requisitionId":
                                        qrCodeProvider.qrRequisitionId,
                                    "mobileNumber": _candidateApplicationFormKey
                                        .currentState!.value["mobile"],
                                    "emailId": _candidateApplicationFormKey
                                        .currentState!.value["email"],
                                    "zingId": "",
                                    "countryCode": _candidateApplicationFormKey
                                        .currentState!.value["country_code"],
                                    "isMobile": qrCodeProvider.isEmailDisabled,
                                    "_": DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                  })) {
                                hideOverlayLoader();
                                //Open OTP Dialog

                                await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return RequestOtpDialogBox(
                                      applicationId: null,
                                      subscriptionId: null,
                                      onResendOTP: () async {
                                        showOverlayLoader(context);
                                        if (await qrCodeProvider
                                            .sendOTPForQRcodeCandidateApiFunction(
                                                context: context,
                                                dataParameter: {
                                              "subscriptionName": qrCodeProvider
                                                  .qrCodeSubscription,
                                              "requisitionId": qrCodeProvider
                                                  .qrRequisitionId,
                                              "mobileNumber":
                                                  _candidateApplicationFormKey
                                                      .currentState!
                                                      .value["mobile"],
                                              "emailId":
                                                  _candidateApplicationFormKey
                                                      .currentState!
                                                      .value["email"],
                                              "zingId": "",
                                              "countryCode":
                                                  _candidateApplicationFormKey
                                                      .currentState!
                                                      .value["country_code"],
                                              "isMobile": qrCodeProvider
                                                  .isEmailDisabled,
                                              "_": DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString(),
                                            })) {
                                          hideOverlayLoader();
                                        } else {
                                          hideOverlayLoader();
                                        }
                                      },
                                      onSubmitOTP: (enteredOTP) async {
                                        showOverlayLoader(context);

                                        if (await qrCodeProvider
                                            .verifyOTPForQRcodeCandidateApiService(
                                                context: context,
                                                dataParameter: {
                                              "subscriptionName": qrCodeProvider
                                                  .qrCodeSubscription,
                                              "obApplicantId": qrCodeProvider
                                                  .qrObApplicantID,
                                              "verificationCode": enteredOTP,
                                              "deviceId":
                                                  CurrentDeviceInformation
                                                      .deviceId,
                                              "applicationVersion": "4.0.3",
                                              "mobileNumber":
                                                  _candidateApplicationFormKey
                                                      .currentState!
                                                      .value["mobile"],
                                              "emailId":
                                                  _candidateApplicationFormKey
                                                      .currentState!
                                                      .value["email"],
                                              "countryCode":
                                                  _candidateApplicationFormKey
                                                      .currentState!
                                                      .value["country_code"],
                                              "isMobile": qrCodeProvider
                                                  .isEmailDisabled,
                                              "zingId": "",
                                              "otpToken": qrCodeProvider
                                                  .otpTokenForCandidate
                                            })) {
                                          hideOverlayLoader();
                                          backToScreen(context: context);
                                          moveToNextScreenWithRoute(
                                              context: context,
                                              routePath: AppRoutesPath
                                                  .QR_CODE_REQUISITION);
                                        } else {
                                          hideOverlayLoader();
                                        }
                                      },
                                    );
                                  },
                                );
                              } else {
                                hideOverlayLoader();
                              }
                            }
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
                                  subTitle: _candidateApplicationFormKey
                                              .currentState!.errors[
                                          _candidateApplicationFormKey
                                              .currentState!.errors.keys
                                              .toList()
                                              .first] ??
                                      "-",
                                  onPressButton: () async {
                                    backToScreen(context: context);
                                  },
                                );
                              },
                            );
                          }
                        },
                      ),
                      PickHeightAndWidth.height20,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
