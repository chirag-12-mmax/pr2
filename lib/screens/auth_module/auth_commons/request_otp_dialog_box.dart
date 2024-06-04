// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';

import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/text_style.dart';

import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/common_fields.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/rich_text_widget.dart';

import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class RequestOtpDialogBox extends StatefulWidget {
  final String? applicationId;
  final String? subscriptionId;
  final dynamic onSubmitOTP;
  final int otpLength;
  final dynamic onResendOTP;
  // final DialogKey dialogKey;
  const RequestOtpDialogBox({
    super.key,
    required this.applicationId,
    required this.subscriptionId,
    required this.onSubmitOTP,
    this.onResendOTP,
    this.otpLength = 5,

    // required this.dialogKey
  });

  @override
  State<RequestOtpDialogBox> createState() => _RequestOtpDialogBoxState();
}

class _RequestOtpDialogBoxState extends State<RequestOtpDialogBox> {
  int start = 180;
  late Timer timer;

  String code = "";

  bool hasError = false;
  String errorText = "Please Enter Otp";

  TextEditingController requestOtpCodeController = TextEditingController();

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  Future<void> getAutoSms() async {
    await SmsAutoFill().listenForCode();
  }

  startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, GeneralHelper helper, snapshot) {
      return SimpleDialog(
        title: GestureDetector(
          onTap: () {
            backToScreen(context: context);
          },
          child: SvgPicture.asset(
            alignment: Alignment.centerRight,
            PickImages.cancelIcon,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                if (start != 0)
                  RichTextWidget(
                    fontWeight: FontWeight.normal,
                    mainTitleColor: PickColors.primaryColor,
                    subTitleColor: PickColors.blackColor,
                    mainTitle: "$start ",
                    subTitle: helper.translateTextTitle(
                            titleText: "secs remaining to regenerate OTP") ??
                        "-",
                  ),
                PickHeightAndWidth.height20,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: getOtpCodeField(
                        helper: helper,
                        autoFocus: true,
                        newContext: context,
                        hasError: hasError,
                        isPassword: false,
                        pinBoxLength: widget.otpLength,
                        controller: requestOtpCodeController,
                        pinBoxColor: PickColors.bgColor,
                      ),
                    ),
                    if (hasError && start != 0)
                      Text(
                        errorText,
                        style: CommonTextStyle()
                            .noteHeadingTextStyle
                            .copyWith(color: PickColors.primaryColor),
                      ),
                    if (start == 0)
                      InkWell(
                        onTap: () async {
                          requestOtpCodeController.clear();
                          final authProvider =
                              Provider.of<AuthProvider>(context, listen: false);
                          if (widget.applicationId != null &&
                              widget.subscriptionId != null) {
                            if (await authProvider.generateOtpApiFunction(
                                applicationId: widget.applicationId!,
                                context: context,
                                subscriptionId: widget.subscriptionId!,
                                helper: helper)) {
                              setState(() {
                                start = 180;
                                startTimer();
                              });
                            }
                          } else {
                            await widget.onResendOTP();
                            setState(() {
                              start = 180;
                              startTimer();
                            });
                          }
                        },
                        child: Center(
                          child: Text(
                            helper.translateTextTitle(
                                    titleText: "resend OTP") ??
                                "-",
                            style: CommonTextStyle()
                                .noteHeadingTextStyle
                                .copyWith(color: PickColors.successColor),
                          ),
                        ),
                      ),
                  ],
                ),
                PickHeightAndWidth.height20,
                Row(
                  children: [
                    Expanded(
                      child: CommonMaterialButton(
                        borderColor: PickColors.primaryColor,
                        color: PickColors.whiteColor,
                        title: helper.translateTextTitle(titleText: "Cancel") ??
                            "-",
                        style: CommonTextStyle().buttonTextStyle.copyWith(
                              color: PickColors.primaryColor,
                            ),
                        onPressed: () {
                          backToScreen(context: context);
                        },
                      ),
                    ),
                    PickHeightAndWidth.width10,
                    Expanded(
                      child: CommonMaterialButton(
                        title: helper.translateTextTitle(titleText: "Verify") ??
                            "",
                        onPressed: () async {
                          if (requestOtpCodeController.text.length <
                              widget.otpLength) {
                            setState(() {
                              hasError = true;
                            });
                          } else {
                            setState(() {
                              hasError = false;
                            });
                          }
                          if (!hasError) {
                            widget.onSubmitOTP(requestOtpCodeController.text);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );
    });
  }
}
