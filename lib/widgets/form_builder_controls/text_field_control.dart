import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/text_style.dart';

// CommonFormBuilderTextField
class CommonFormBuilderTextField extends StatefulWidget {
  const CommonFormBuilderTextField({
    Key? key,
    this.hint,
    this.fullyDisable = false,
    this.validator,
    this.suffix,
    this.fillColor,
    this.keyboardType,
    this.bottom,
    // this.maxLength,
    this.onChanged,
    this.onSuffixTap,
    this.maxLines,
    this.inputFormatters,
    this.isInRow = false,
    required this.fieldName,
    this.isObSecure = false,
    required this.isRequired,
    this.maxCharLength,
    this.textController,
    this.isOnlyUppercase = false,
  }) : super(key: key);
  final String fieldName;
  final String? hint;
  final String? Function(String?)? validator;
  final dynamic suffix;
  final dynamic keyboardType;
  final bool fullyDisable;
  // final int? maxLength;
  final dynamic onChanged;

  final dynamic onSuffixTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool isInRow;
  final int? maxLines;
  final bool isObSecure;
  final bool? fillColor;
  final bool isRequired;
  final double? bottom;
  final bool isOnlyUppercase;

  final int? maxCharLength;
  final TextEditingController? textController;

  @override
  State<CommonFormBuilderTextField> createState() =>
      _CommonFormBuilderTextFieldState();
}

class _CommonFormBuilderTextFieldState
    extends State<CommonFormBuilderTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.bottom ?? 15),
      child: IgnorePointer(
        ignoring: widget.fullyDisable,
        child: FormBuilderTextField(
          name: widget.fieldName,
          controller: widget.textController,
          enabled: !widget.fullyDisable,
          readOnly: widget.fullyDisable == true ? true : false,
          obscureText: widget.isObSecure,
          style: CommonTextStyle().noteHeadingTextStyle.copyWith(
              color: widget.fullyDisable == true
                  ? PickColors.blackColor.withOpacity(0.2)
                  : PickColors.blackColor),
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines ?? 1,
          maxLength: widget.maxCharLength,
          validator: widget.validator,
          textInputAction: TextInputAction.next,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatters,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          valueTransformer:
              widget.isOnlyUppercase ? (value) => value?.toUpperCase() : null,
          decoration: InputDecoration(
            hoverColor: widget.fillColor == true
                ? PickColors.whiteColor
                : PickColors.whiteColor,
            filled: true,
            fillColor: widget.fillColor == true
                ? widget.fullyDisable == true
                    ? PickColors.bgColor
                    : PickColors.whiteColor
                : widget.fullyDisable == true
                    ? PickColors.bgColor
                    : PickColors.whiteColor,
            // helperText: widget.isInRow ? "" : null,
            suffixIconConstraints: const BoxConstraints(),
            prefixIconConstraints: const BoxConstraints(),
            // errorStyle: TextStyle(height: 0),
            // error: Container(),
            errorStyle: const TextStyle(
              fontSize: 0,
              height: 0.01,
            ),
            // errorText: '',

            // hintStyle: CommonTextStyle().noteHeadingTextStyle.copyWith(
            //     fontSize: 13,
            //     color: widget.fullyDisable == true
            //         ? PickColors.hintColor.withOpacity(0.2)
            //         : PickColors.hintColor),
            counterText: '',
            // counter: Container(
            //   height: 0,
            // ),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    (widget.hint ?? "-"),
                    style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                        fontSize: 15,
                        color: widget.fullyDisable == true
                            ? PickColors.blackColor.withOpacity(0.5)
                            : PickColors.blackColor.withOpacity(0.5)),
                  ),
                ),
                if (widget.isRequired)
                  Text(
                    '*',
                    style: CommonTextStyle()
                        .noteHeadingTextStyle
                        .copyWith(fontSize: 15, color: PickColors.primaryColor),
                  ),
              ],
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            suffixIcon: widget.suffix,

            // hintText: widget.hint,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: PickColors.successColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
            ),
          ),
        ),
      ),
    );
  }
}
