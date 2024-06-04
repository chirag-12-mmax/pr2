import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/text_style.dart';

// CommonFormBuilderCheckbox
class CommonFormBuilderCheckbox extends StatefulWidget {
  const CommonFormBuilderCheckbox({
    Key? key,
    this.title,
    this.validator,
    this.onChanged,
    this.leftPadding = 0.0,
    required this.fieldName,
    this.isRequired = false,
    this.isEnabled = true,
  }) : super(key: key);

  final FormFieldValidator? validator;
  final dynamic onChanged;
  final String? title;
  final String fieldName;
  final bool isRequired;
  final bool isEnabled;
  final double leftPadding;

  @override
  State<CommonFormBuilderCheckbox> createState() =>
      _CommonFormBuilderCheckboxState();
}

class _CommonFormBuilderCheckboxState extends State<CommonFormBuilderCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: FormBuilderCheckbox(
        activeColor: PickColors.primaryColor,
        onChanged: widget.onChanged,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          // if (widget.isRequired)
          //   FormBuilderValidators.required(
          //       errorText: widget.title == "Is Highest Qualification"
          //           ? "Highest Qualification is Mandatory"
          //           : "${widget.title} is Mandatory"),
          // if (widget.isRequired)
          //   (checkedValue) {
          //     if (!(checkedValue ?? false)) {
          //       return "${widget.title} is Mandatory";
          //     } else {
          //       return null;
          //     }
          //   }
        ]),
        name: widget.fieldName,
        enabled: widget.isEnabled,
        decoration: const InputDecoration(
          errorStyle: const TextStyle(
            fontSize: 0,
            height: 0.01,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                widget.title ?? "",
              ),
            ),
            if (widget.isRequired)
              Text(
                '*',
                style: CommonTextStyle()
                    .noteHeadingTextStyle
                    .copyWith(fontSize: 13, color: PickColors.primaryColor),
              ),
          ],
        ),
      ),
    );
  }
}
