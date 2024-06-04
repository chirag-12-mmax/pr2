import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/widgets/common_otp_field.dart';
import 'package:onboarding_app/widgets/text_fields/common_textfield.dart';

CommonTextFieldWithBorder getCompanyCodeField(GeneralHelper helper,
    TextEditingController controller, BuildContext context) {
  return CommonTextFieldWithBorder(
    prefix: Padding(
      padding: const EdgeInsets.all(12),
      child: SvgPicture.asset(
        PickImages.noteIcon,
        height: 25,
        width: 25,
      ),
    ),
    filled: true,
    isAutoFocus: true,

    fillColor: PickColors.whiteColor,
    hoverColor: PickColors.whiteColor,
    textInputAction: TextInputAction.next,
    bottom: 18.0,
    // onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
    isRequired: true,
    isInRow: false,

    textFieldKey: helper.translateTextTitle(titleText: "Company Code") ?? "-",
    labelText: helper.translateTextTitle(titleText: "Company Code") ?? "-",
    hint: helper.translateTextTitle(titleText: "Company Code") ?? "-",
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'\s')), // Deny spaces
    ],

    controller: controller,
    onChanged: (value) {},
    keyboardType: TextInputType.text,
  );
}

CommonTextFieldWithBorder getApplicantIdField(GeneralHelper helper,
    TextEditingController controller, BuildContext context) {
  return CommonTextFieldWithBorder(
    prefix: Padding(
      padding: const EdgeInsets.all(12),
      child: SvgPicture.asset(
        PickImages.myProfileIcon,
        height: 25,
        width: 25,
      ),
    ),
    isRequired: true,
    filled: true,
    bottom: 18.0,
    hoverColor: PickColors.whiteColor,
    textInputAction: TextInputAction.next,
    fillColor: PickColors.whiteColor,
    // onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
    textFieldKey: helper.translateTextTitle(titleText: "Applicant ID") ?? "-",
    labelText: helper.translateTextTitle(titleText: "Applicant ID") ?? "-",
    hint: helper.translateTextTitle(titleText: "Applicant ID") ?? "-",
    controller: controller,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'\s')), // Deny spaces
    ],

    onChanged: (value) {},
    keyboardType: TextInputType.text,
  );
}

CommonTextFieldWithBorder getPasswordField(
    GeneralHelper helper,
    TextEditingController controller,
    bool obscure,
    dynamic onSuffixTap,
    BuildContext context) {
  return CommonTextFieldWithBorder(
      prefix: Padding(
        padding: const EdgeInsets.all(12),
        child: SvgPicture.asset(
          PickImages.lockIcon,
          height: 25,
          width: 25,
        ),
      ),
      isRequired: true,
      obscure: obscure,
      onSuffixTap: onSuffixTap,
      filled: true,
      bottom: 18.0,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      hoverColor: PickColors.whiteColor,
      fillColor: PickColors.whiteColor,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')), // Deny spaces
      ],
      textFieldKey: helper.translateTextTitle(titleText: "Password") ?? "-",
      labelText: helper.translateTextTitle(titleText: "Password") ?? "-",
      hint: helper.translateTextTitle(titleText: "Password") ?? "-",
      controller: controller,
      onChanged: (value) {},
      keyboardType: TextInputType.text);
}

CommonTextFieldWithBorder getEmployeeCodeField(GeneralHelper helper,
    TextEditingController controller, BuildContext context) {
  return CommonTextFieldWithBorder(
    prefix: Padding(
      padding: const EdgeInsets.all(12),
      child: SvgPicture.asset(
        PickImages.myProfileIcon,
        height: 25,
        width: 25,
      ),
    ),
    isRequired: true,
    isInRow: false,
    bottom: 18.0,
    filled: true,
    fillColor: PickColors.whiteColor,
    hoverColor: PickColors.whiteColor,
    textInputAction: TextInputAction.next,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'\s')), // Deny spaces
    ],
    textFieldKey: helper.translateTextTitle(titleText: "Employee Code") ?? "-",
    labelText: helper.translateTextTitle(titleText: "Employee Code") ?? "-",
    hint: helper.translateTextTitle(titleText: "Employee Code") ?? "-",
    controller: controller,
    onChanged: (value) {},
    keyboardType: TextInputType.text,
  );
}

CustomPinCodeView getOtpCodeField(
    {required GeneralHelper helper,
    required TextEditingController controller,
    required BuildContext newContext,
    required bool isPassword,
    double? pinBoxHeight,
    double? pinBoxWidth,
    double horizontal = 4.0,
    required Color pinBoxColor,
    required bool autoFocus,
    int? pinBoxLength = 5,
    bool hasError = false,
    dynamic onTextChanged,
    String? labelText}) {
  return CustomPinCodeView(
    horizontal: horizontal,
    newContext: newContext,
    autoFocus: autoFocus,
    pinBoxHeight: pinBoxHeight,
    pinBoxWidth: pinBoxWidth,
    pinBoxColor: pinBoxColor,
    isRequired: true,
    labelText: labelText,
    borderColor: Colors.transparent,
    textEditingController: controller,
    pinLength: pinBoxLength ?? 5,
    hasError: hasError,
    isPassword: isPassword,
    hideCharacter: false,
    wrapAlignment: WrapAlignment.center,
    onTextChanged: onTextChanged,
    onDone: (text) {},
  );
}
