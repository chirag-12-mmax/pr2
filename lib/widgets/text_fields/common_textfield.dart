import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/constants/validation_keys.dart';
import 'package:onboarding_app/functions/check_valid_url.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/widgets/textfield_label_widget.dart';
import 'package:provider/provider.dart';

// CommonTextFieldWithBorder
class CommonTextFieldWithBorder extends StatefulWidget {
  const CommonTextFieldWithBorder(
      {Key? key,
      this.label,
      this.hint,
      this.controller,
      this.validator,
      this.suffix,
      this.prefix,
      this.obscure,
      this.keyboardType,
      this.maxLength,
      this.onSaved,
      this.onFieldSubmitted,
      this.onChanged,
      this.textInputAction,
      this.isEnable,
      this.maxLines,
      this.minLines,
      this.fillColor,
      this.filled,
      this.onEditingComplete,
      this.height,
      this.onSuffixTap,
      this.borderRadius,
      this.inputFormatters,
      this.textFieldKey,
      this.isRequired = true,
      this.canMatchString,
      this.isInRow = false,
      this.isTimeTextField = false,
      this.labelText,
      this.hoverColor,
      this.bottom = 15,
      this.sizedBx,
      this.isAutoFocus = false})
      : super(key: key);

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final dynamic suffix;
  final dynamic prefix;
  final bool? obscure;
  final dynamic keyboardType;
  final Color? fillColor;
  final bool? filled;
  final int? maxLength;
  final Function(String? value)? onSaved;
  final Function(String? value)? onFieldSubmitted;
  final dynamic onChanged;
  final bool? isEnable;
  final int? minLines;
  final int? maxLines;
  final double? height;
  final dynamic onSuffixTap;
  final BorderRadius? borderRadius;
  final Function()? onEditingComplete;
  final String? textFieldKey;
  final bool isRequired;
  final bool isTimeTextField;
  final String? canMatchString;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool isInRow;
  final double? sizedBx;
  final String? labelText;
  final Color? hoverColor;
  final double bottom;
  final bool isAutoFocus;

  @override
  State<CommonTextFieldWithBorder> createState() =>
      _CommonTextFieldWithBorderState();
}

class _CommonTextFieldWithBorderState extends State<CommonTextFieldWithBorder> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, GeneralHelper helper, snapshot) {
      return Padding(
        padding: EdgeInsets.only(bottom: widget.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null)
              TextFieldLabelWidget(
                isRequired: widget.isRequired,
                title: widget.labelText ?? '-',
              ),
            if (widget.labelText != null)
              SizedBox(
                height: widget.sizedBx ?? 10,
              ),
            SizedBox(
              height: widget.height,
              child: TextFormField(
                autocorrect: true,
                enabled: widget.isEnable,
                autofocus: widget.isAutoFocus,
                onSaved: widget.onSaved,
                style: (!(widget.isEnable ?? true)) && !(widget.isTimeTextField)
                    ? CommonTextStyle().noteHeadingTextStyle
                    : null,
                keyboardType: widget.keyboardType,
                maxLength: widget.maxLength,
                controller: widget.controller,
                validator: widget.validator ??
                    (textValue) {
                      return validateTextFieldByKey(
                          textKey: widget.textFieldKey ?? "",
                          isRequired: widget.isRequired,
                          helper: helper,
                          textFieldValue: textValue,
                          matchValue: widget.canMatchString);
                    },
                obscureText: widget.obscure ?? false,
                textInputAction: widget.textInputAction ?? TextInputAction.next,
                onChanged: widget.onChanged,
                onFieldSubmitted: widget.onFieldSubmitted,
                onEditingComplete: widget.onEditingComplete,
                inputFormatters: widget.inputFormatters,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hoverColor: widget.hoverColor ?? PickColors.bgColor,
                  filled: widget.filled ?? true,
                  fillColor: widget.fillColor ?? PickColors.bgColor,
                  helperText: widget.isInRow ? "" : null,
                  // isDense: true,
                  suffixIconConstraints: const BoxConstraints(),
                  prefixIconConstraints: const BoxConstraints(),
                  errorStyle: const TextStyle(
                    fontWeight: FontWeight.w100,
                    overflow: TextOverflow.visible,
                    fontSize: 12,
                  ),
                  hintStyle: CommonTextStyle()
                      .noteHeadingTextStyle
                      .copyWith(fontSize: 13),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  suffixIcon: widget.obscure != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: widget.onSuffixTap,
                              child: widget.obscure!
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: PickColors.hintColor,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: PickColors.hintColor,
                                    )),
                        )
                      : widget.suffix,
                  prefixIcon: widget.prefix,
                  labelText: widget.label,
                  hintText: widget.hint,
                  errorBorder: OutlineInputBorder(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(8),
                    borderSide: BorderSide(color: PickColors.successColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius:
                        widget.borderRadius ?? BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

String? validateTextFieldByKey(
    {required String textKey,
    required String? textFieldValue,
    required bool isRequired,
    String? matchValue,
    required GeneralHelper helper}) {
  String? validationError;
  //Regular Expression
  RegExp emailExpression = RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  // RegExp mobileExpression =
  //     RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)');

  RegExp gstNumberPattern = RegExp(
      "^([0-9]{2}[a-zA-Z]{4}([a-zA-Z]{1}|[0-9]{1})[0-9]{4}[a-zA-Z]{1}([a-zA-Z]|[0-9]){3}){0,15}\$");

  // RegExp AadharCardExpression =
  //     RegExp(r'^[2-9]{1}[0-9]{3}\\s[0-9]{4}\\s[0-9]{4}$');

  RegExp panCardExpression = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

  RegExp drivingLicense = RegExp(
      r'^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}$');

  RegExp fullName = RegExp('[a-zA-Z]');

  // RegExp pinCodeExpression = RegExp("^[1-9]{1}[0-9]{2}\\s{0,1}[0-9]{3}\$");

  RegExp passwordExpression =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  RegExp ifscCodeExpression = RegExp("^[A-Z]{4}[0][A-Z0-9]{6}");

  // RegExp validLinkExpression = RegExp(
  //     r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?");

  if (textFieldValue == null || textFieldValue.isEmpty) {
    if (isRequired) {
      validationError =
          "$textKey ${helper.translateTextTitle(titleText: " Can't be Empty")}";
    } else {
      validationError = null;
    }
  } else if (textKey == ValidationKey.emailKey) {
    if (emailExpression.hasMatch(textFieldValue)) {
      validationError = null;
    } else {
      validationError = "Please Enter Valid Email";
    }
  } else if (textKey == ValidationKey.mobileNumberKey) {
    if (textFieldValue.length == 10) {
      validationError = null;
    } else {
      validationError = "Please Enter Valid Mobile Number";
    }
  } else if (textKey == ValidationKey.urlLinkKey) {
    if (checkUrlLink(url: textFieldValue)) {
      validationError = null;
    } else {
      validationError = "Please Enter Valid URL";
    }
  } else if (textKey == ValidationKey.dateKey) {
    // if (getValidDateFromString(dateText: textFieldValue) != null) {
    //   validationError = null;
    // } else {
    //   validationError = "Please Enter Valid Date";
    // }
  } else if (textKey == ValidationKey.gstKey) {
    if (gstNumberPattern.hasMatch(textFieldValue)) {
      validationError = null;
    } else {
      validationError = "Please Enter Valid GST Number";
    }
  } else if (textKey == ValidationKey.adharCardKey) {
    if (textFieldValue.length == 12) {
      validationError = null;
    } else {
      validationError = "Please Enter Valid Adhar Card Number";
    }
  } else if (textKey == ValidationKey.panCardKey) {
    if (panCardExpression.hasMatch(textFieldValue)) {
      validationError = null;
    } else {
      validationError = "Please Enter Valid Pan Card Number";
    }
  } else if (textKey == ValidationKey.drivingLicenseKey) {
    if (drivingLicense.hasMatch(textFieldValue)) {
      validationError = null;
    } else {
      validationError = "Please Enter Valid Driving License Number";
    }
  } else if (textKey == ValidationKey.pinCodeKey) {
    if (textFieldValue.length <= 10 && textFieldValue.length >= 6) {
      validationError = null;
    } else {
      validationError = "Please Enter Valid Pin Code";
    }
  } else if (textKey == ValidationKey.reEnteredPassword) {
    if (textFieldValue == matchValue) {
      validationError = null;
    } else {
      validationError = "Password Must Be Match";
    }
  } else if (textKey == ValidationKey.IFSCCodeValueKey) {
    if (ifscCodeExpression.hasMatch(textFieldValue)) {
      validationError = null;
    } else {
      validationError = "Enter Valid IFSC Code";
    }
  } else if (textKey == ValidationKey.fullName) {
    if (fullName.hasMatch(textFieldValue)) {
      validationError = null;
    } else {
      validationError = "Enter Valid Full Name";
    }
  } else {
    validationError = null;
  }

  return validationError;
}
