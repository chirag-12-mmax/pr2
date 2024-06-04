import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_providers/profile_provider.dart';
import 'package:provider/provider.dart';

class CommonSearchTextField extends StatefulWidget {
  const CommonSearchTextField({
    super.key,
    required this.searchFunction,
    this.onItemSelected,
    required this.hintText,
    this.isDisabled = false,
    this.customOnEditingComplete,
    this.fieldController,
    this.prefix,
    this.initialValue,
    this.isAutoFill = false,
    this.isClear = false,
    this.maxWidth,
    this.onTapSuffix,
    this.fillColor,
    this.isRequired = false,
    this.fullyDisable = false,
    required this.fieldName,
  });
  final FutureOr<Iterable<ItemModel>> Function(TextEditingValue) searchFunction;

  final dynamic onItemSelected;
  final dynamic prefix;
  final String hintText;
  final bool isDisabled;
  final TextEditingController? fieldController;
  final Function()? customOnEditingComplete;
  final String? initialValue;
  final bool isAutoFill;
  final double? maxWidth;
  final dynamic onTapSuffix;
  final bool isClear;
  final bool? fillColor;
  final bool isRequired;
  final bool fullyDisable;
  final String fieldName;

  @override
  State<CommonSearchTextField> createState() => _CommonSearchTextFieldState();
}

class _CommonSearchTextFieldState extends State<CommonSearchTextField> {
  double _getTextFieldWidth() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder:
        (BuildContext context, ProfileProvider profileProvider, snapshot) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          child: Autocomplete<ItemModel>(
              optionsBuilder: widget.searchFunction,
              initialValue: TextEditingValue(text: widget.initialValue ?? ""),
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                controller = widget.fieldController ?? controller;

                if (widget.isAutoFill) {
                  controller.text = widget.initialValue ?? "";
                }
                return Container(
                  child: TextField(
                    controller: widget.fieldController ?? controller,
                    focusNode: focusNode,
                    enabled: !widget.isDisabled,
                    style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                        color: widget.fullyDisable == true
                            ? PickColors.blackColor.withOpacity(0.2)
                            : PickColors.blackColor),
                    onEditingComplete: widget.customOnEditingComplete,
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                    // ],
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      // suffix: widget.prefix,

                      // contentPadding:
                      //     EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      isDense: true,
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
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: (controller.text).toString().trim() != ""
                            ? InkWell(
                                onTap: () {
                                  controller.clear();
                                  widget.onTapSuffix();
                                },
                                child: Icon(
                                  Icons.cancel,
                                  color: PickColors.hintColor,
                                ))
                            : null,
                      ),

                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(widget.hintText,
                              style: CommonTextStyle()
                                  .noteHeadingTextStyle
                                  .copyWith(
                                      fontSize: 15,
                                      color: PickColors.blackColor
                                          .withOpacity(0.5))),
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
                    ),
                  ),
                );
              },
              onSelected: widget.onItemSelected,
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: 200, maxWidth: _getTextFieldWidth()
                          // maxWidth: 168 * 2,
                          ), //RELEVANT CHANGE: added maxWidth
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ItemModel option = options.elementAt(index);
                          return InkWell(
                            onTap: () {
                              onSelected(option);
                            },
                            child: Builder(builder: (BuildContext context) {
                              final bool highlight =
                                  AutocompleteHighlightedOption.of(context) ==
                                      index;
                              if (highlight) {
                                SchedulerBinding.instance
                                    .addPostFrameCallback((Duration timeStamp) {
                                  Scrollable.ensureVisible(context,
                                      alignment: 0.5);
                                });
                              }
                              return Container(
                                color: highlight
                                    ? Theme.of(context).focusColor
                                    : null,
                                padding: const EdgeInsets.all(16.0),
                                child: Text(option.title.toString()),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              displayStringForOption: (ItemModel option) =>
                  widget.isClear ? "" : option.title.toString()),
        ),
      );
    });
  }
}

class ItemModel {
  final dynamic title;
  final dynamic id;
  final String? code;

  ItemModel({required this.title, required this.id, this.code});
}
