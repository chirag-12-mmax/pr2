import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/widgets/textfield_label_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:pin_code_text_field/pin_code_text_field.dart';

// ignore: must_be_immutable
class CustomPinCodeView extends StatelessWidget {
  CustomPinCodeView(
      {super.key,
      this.textEditingController,
      this.pinLength = 4,
      this.hasError = false,
      this.hideCharacter = true,
      this.onTextChanged,
      this.onDone,
      this.pinBoxWidth,
      this.pinBoxHeight,
      this.wrapAlignment = WrapAlignment.center,
      this.textColor,
      this.labelText,
      this.pinBoxColor = Colors.white,
      this.isRequired = true,
      required this.borderColor,
      required this.autoFocus,
      this.horizontal = 4.0,
      this.fontSize,
      required this.newContext,
      required this.isPassword});
  final TextEditingController? textEditingController;
  final int pinLength;
  final bool hasError;
  final double? pinBoxWidth;
  final double? pinBoxHeight;
  final bool hideCharacter;
  Function(String)? onTextChanged;
  Function(String)? onDone;
  final WrapAlignment wrapAlignment;

  final Color? textColor;
  final Color borderColor;
  final double? fontSize;
  final String? labelText;
  final bool isRequired;
  final bool autoFocus;
  final Color pinBoxColor;
  final double horizontal;
  final bool isPassword;
  final BuildContext newContext;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null)
            TextFieldLabelWidget(
              isRequired: isRequired,
              title: labelText ?? '-',
            ),
          if (labelText != null)
            const SizedBox(
              height: 10,
            ),
          Align(
            alignment: Alignment.center,
            child: Container(
              // height: 100,
              width: 300,
              child: PinCodeTextField(
                appContext: newContext,
                autoDisposeControllers: false,

                length: pinLength,
                animationCurve: Curves.bounceInOut,
                autoFocus: autoFocus,
                pastedTextStyle: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
                // length: 6,
                obscureText: isPassword,

                obscuringCharacter: '*',
                blinkWhenObscuring: true,
                // obscuringWidget: Center(child: Container()),
                animationType: AnimationType.fade,
                // validator: (v) {
                //   if (v!.length < 3) {
                //     return "I'm from validator";
                //   } else {
                //     return null;
                //   }
                // },
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: pinLength != 6 ? pinBoxHeight ?? 50 : 50,
                    fieldWidth: pinLength != 6 ? pinBoxWidth ?? 50 : 40,
                    selectedFillColor: Colors.white,
                    // activeColor: Colors,
                    activeFillColor: Colors.white,

                    // activeColor: Colors.green,
                    disabledColor: Colors.teal,
                    inactiveColor: pinBoxColor,
                    errorBorderColor: Colors.red,
                    inactiveFillColor: pinBoxColor,
                    selectedColor: PickColors.successColor),
                cursorColor: Colors.black,
                animationDuration: const Duration(milliseconds: 300),

                enableActiveFill: true,
                onChanged: onTextChanged,
                // onCompleted: onDone,
                onSubmitted: onDone,
                // errorAnimationController: errorController,
                controller: textEditingController,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
