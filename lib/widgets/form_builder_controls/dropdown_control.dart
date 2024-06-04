import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/widgets/form_builder_controls/custom_dropdown/clear_button_prop.dart';
import 'package:onboarding_app/widgets/form_builder_controls/custom_dropdown/custom_dropdown_search.dart';
import 'package:onboarding_app/widgets/form_builder_controls/custom_dropdown/dropdown_button_prop.dart';
import 'package:onboarding_app/widgets/form_builder_controls/custom_dropdown/dropdown_decore_prop.dart';
import 'package:onboarding_app/widgets/form_builder_controls/custom_dropdown/propups.dart';
import 'package:onboarding_app/widgets/form_builder_controls/custom_dropdown/textfield_prop.dart';

// CommonFormBuilderDropdown
class CommonFormBuilderDropdown extends StatefulWidget {
  const CommonFormBuilderDropdown({
    Key? key,
    this.hintText,
    this.onChanged,
    this.focusNode,
    this.fillColor,
    this.fullyDisable = false,
    this.menuMaxHeight,
    required this.items,
    this.isInRow = false,
    required this.fieldName,
    required this.isRequired,
    this.isEnabled = true,
    this.isFromAttribute = false,
    this.onCrossIconChange,
  }) : super(key: key);

  final String fieldName;
  final List<dynamic> items;
  final String? hintText;
  final dynamic onChanged;
  final Color? fillColor;
  final bool fullyDisable;
  final bool isInRow;
  final bool isRequired;
  final bool isEnabled;
  final double? menuMaxHeight;
  final bool isFromAttribute;
  final FocusNode? focusNode;
  final dynamic onCrossIconChange;

  @override
  State<CommonFormBuilderDropdown> createState() =>
      _CommonFormBuilderDropdownState();
}

class _CommonFormBuilderDropdownState extends State<CommonFormBuilderDropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: FormBuilderField(
          name: widget.fieldName,
          validator: FormBuilderValidators.compose([
            if (widget.isRequired)
              FormBuilderValidators.required(
                  errorText: "${widget.hintText} is Mandatory"),
          ]),
          onChanged: widget.onChanged,
          enabled: widget.isEnabled,
          focusNode: widget.focusNode,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<dynamic> field) {
            return DropdownSearch<dynamic>(
                autoValidateMode: AutovalidateMode.onUserInteraction,
                popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      //  autofocus: false,
                      decoration: InputDecoration(
                        filled: true,
                        suffixIconConstraints: const BoxConstraints(),
                        prefixIconConstraints: const BoxConstraints(),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                        fillColor: PickColors.whiteColor,
                        hintText: "Search Item here...",
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: PickColors.successColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.5)),
                        ),
                      ),
                    )),
                items: widget.items,
                enabled: widget.isEnabled,
                clearButtonProps: ClearButtonProps(
                  icon: Icon(
                    Icons.search,
                    color: PickColors.primaryColor,
                  ),
                ),
                dropdownButtonProps: DropdownButtonProps(
                  // hoverColor: Colors.transparent,
                  splashRadius: 1,
                  // padding: EdgeInsets.all(13),
                  focusNode: widget.focusNode,

                  icon: InkWell(
                    onTap: field.value != null
                        ? () {
                            setState(() {
                              field.setValue(null);
                            });
                            if (widget.onCrossIconChange != null) {
                              widget.onCrossIconChange();
                            }
                          }
                        : null,
                    child: Icon(
                      field.value != null ? Icons.close : Icons.expand_more,
                      color: widget.fullyDisable == true ||
                              (widget.isEnabled == false)
                          ? PickColors.primaryColor.withOpacity(0.3)
                          : PickColors.primaryColor,
                    ),
                  ),
                ),
                validator: FormBuilderValidators.compose([
                  if (widget.isRequired)
                    FormBuilderValidators.required(
                        errorText: "${widget.hintText} is Mandatory"),
                ]),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    filled: true,

                    fillColor: (widget.fullyDisable || !widget.isEnabled)
                        ? PickColors.bgColor
                        : widget.fillColor ?? PickColors.whiteColor,
                    // hintText: widget.hintText,
                    // labelText: widget.hintText,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            widget.hintText ?? "-",
                            style: CommonTextStyle()
                                .noteHeadingTextStyle
                                .copyWith(
                                    fontSize: 15,
                                    color: widget.fullyDisable == true
                                        ? PickColors.blackColor.withOpacity(0.5)
                                        : PickColors.blackColor
                                            .withOpacity(0.5)),
                          ),
                        ),
                        if (widget.isRequired)
                          Text(
                            '*',
                            style: CommonTextStyle()
                                .noteHeadingTextStyle
                                .copyWith(
                                    fontSize: 15,
                                    color: PickColors.primaryColor),
                          ),
                      ],
                    ),
                    errorStyle: const TextStyle(
                      fontSize: 0,
                      height: 0.01,
                    ),
                    hintStyle: CommonTextStyle()
                        .noteHeadingTextStyle
                        .copyWith(fontSize: 15, color: PickColors.hintColor),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: widget.focusNode != null
                              ? widget.focusNode!.hasFocus
                                  ? Colors.red
                                  : Colors.grey.withOpacity(0.5)
                              : Colors.grey.withOpacity(0.5)),
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
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.5)),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.5)),
                    ),
                    //
                  ),
                ),
                onChanged: (value) {
                  try {
                    field.didChange(value);
                  } catch (e) {
                    printDebug(
                        textString: "================Error: ${e.toString()}");
                  }
                },
                selectedItem: field.value,
                itemAsString: (item) {
                  return widget.isFromAttribute
                      ? item["attrUnitDesc"].toString()
                      : widget.fieldName.split("_").first == "familyId"
                          ? ("${item[item.keys.toList()[1]]}${item["familyRelation"] != null ? "(${item["familyRelation"]})" : ""}")
                          : widget.fieldName == "ReferenceCode"
                              ? item.requisitionTitle
                              : item.keys.toList().contains("description")
                                  ? item["description"]
                                  : item[item.keys.toList()[1]].toString();
                });
          }),
    );
  }
}
