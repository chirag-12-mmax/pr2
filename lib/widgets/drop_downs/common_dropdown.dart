import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:provider/provider.dart';

class CommonDropDownWithoutSearch extends StatefulWidget {
  const CommonDropDownWithoutSearch({
    Key? key,
    this.labelText,
    required this.hintText,
    required this.name,
    required this.items,
    this.fillColor,
    required this.isExpanded,
    required this.borderColor,
    this.constraints,
    this.height,
    this.validator,
    this.onChanged,
    this.isDisabled = false,
    this.initialValue,
    this.isInRow = false,
    required this.isRequired,
    this.selectedItemBuilder,
  }) : super(key: key);
  final String? labelText;
  final String hintText;
  final String name;
  final dynamic items;
  final bool isExpanded;
  final Color? fillColor;
  final Color borderColor;
  final BoxConstraints? constraints;
  final dynamic height;
  final dynamic validator;
  final dynamic onChanged;
  final bool isDisabled;
  final dynamic initialValue;
  final dynamic selectedItemBuilder;
  final bool isInRow;
  final bool isRequired;

  @override
  State<CommonDropDownWithoutSearch> createState() =>
      _CommonDropDownWithoutSearchState();
}

class _CommonDropDownWithoutSearchState
    extends State<CommonDropDownWithoutSearch> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, GeneralHelper helper, snapshot) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (widget.isRequired != null)
            //   TextFieldLabelWidget(
            //       title: widget.name, isRequired: widget.isRequired ?? false),
            // if (widget.isRequired != null)
            //   const SizedBox(
            //     height: 10,
            //   ),
            IgnorePointer(
              ignoring: widget.isDisabled,
              child: DropdownButtonFormField<dynamic>(
                validator: widget.validator ??
                    (textValue) {
                      if (textValue == null) {
                        if (widget.isRequired) {
                          return "${widget.hintText} ${helper.translateTextTitle(titleText: " Can't be Empty")}";
                        } else {
                          return null;
                        }
                      }
                    },
                isExpanded: widget.isExpanded,
                icon: Icon(
                  Icons.expand_more,
                  color: PickColors.primaryColor,
                ),
                value: widget.initialValue,
                style: widget.isDisabled
                    ? TextStyle(
                        color: PickColors.blackColor,
                        fontWeight: FontWeight.w100,
                        fontSize: 15,
                      )
                    : null,
                decoration: InputDecoration(
                  constraints: widget.constraints,
                  helperText: widget.isInRow ? "" : null,
                  fillColor: widget.fillColor ?? PickColors.bgColor,
                  labelText: widget.labelText,
                  filled: true,
                  errorStyle: const TextStyle(
                    fontWeight: FontWeight.w100,
                    overflow: TextOverflow.visible,
                    fontSize: 10,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: PickColors.primaryColor),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: PickColors.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: PickColors.hintColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: widget.borderColor),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: widget.borderColor),
                  ),
                  hintText: widget.hintText,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  // isDense: false,
                  hintStyle: CommonTextStyle()
                      .noteHeadingTextStyle
                      .copyWith(fontSize: 13),
                ),
                items: widget.items,
                selectedItemBuilder: widget.selectedItemBuilder,
                onChanged: widget.onChanged,
              ),
            ),
          ],
        ),
      );
    });
  }
}
