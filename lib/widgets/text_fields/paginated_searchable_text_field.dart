import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/widgets/text_fields/custom_searchable_widget.dart';

class PaginatedSearchableDropdown extends StatefulWidget {
  const PaginatedSearchableDropdown({
    super.key,
    this.onPaginatedRequest,
    this.totalRecordCount,
    this.onChangeValue,
    required this.hintText,
    this.dropDownHeight,
    this.initialValue,
    this.margin,
    this.isEnable = true,
    this.rightPadding,
    this.leftPadding,
    this.isAddNewFunctionality = false,
    this.dropDownController,
  });
  final dynamic onPaginatedRequest;
  final int? totalRecordCount;
  final dynamic onChangeValue;
  final String hintText;
  final double? dropDownHeight;
  final EdgeInsetsGeometry? margin;
  final SearchableDropdownMenuItem<dynamic>? initialValue;
  final double? rightPadding;
  final double? leftPadding;

  final bool isEnable;
  final bool isAddNewFunctionality;
  final SearchableDropdownController? dropDownController;

  @override
  State<PaginatedSearchableDropdown> createState() =>
      _PaginatedSearchableDropdownState();
}

class _PaginatedSearchableDropdownState
    extends State<PaginatedSearchableDropdown> {
  SearchableDropdownController controller = SearchableDropdownController();

  bool isLoading = false;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    setState(() {
      isLoading = true;
    });
    (widget.dropDownController ?? controller).selectedItem.value =
        widget.initialValue;
    (widget.dropDownController ?? controller).paginatedRequest =
        widget.onPaginatedRequest;
    (widget.dropDownController ?? controller).requestItemCount =
        widget.totalRecordCount ?? 0;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? CustomSearchableDropdown<dynamic>.paginated(
            hintText: Text(
              widget.hintText,
              style:  TextStyle(
                color: PickColors.hintColor,
                fontWeight: FontWeight.w100,
                fontSize: 15,
              ),
            ),
            isEnabled: widget.isEnable,
            controller: (widget.dropDownController ?? controller),
            leftPadding: widget.leftPadding,
            rightPadding: widget.rightPadding,
            margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 10),
            backgroundDecoration: (child) {
              return Container(
                height: widget.dropDownHeight,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: PickColors.hintColor)),
                child: child,
              );
            },
            paginatedRequest: widget.onPaginatedRequest,
            isAddNewFunctionality: widget.isAddNewFunctionality,
            requestItemCount: widget.totalRecordCount,
            onChanged: widget.onChangeValue,
          )
        : Container();
  }
}
