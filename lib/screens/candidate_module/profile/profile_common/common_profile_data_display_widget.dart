import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_models/configuration_model.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_services/logical_functions.dart';

class CommonProfileDataDisplayWidget extends StatefulWidget {
  final dynamic listItemData;
  final dynamic onTapDelete;
  final dynamic onTapUpdate;
  final FieldConfigDetails? currentSelectedSection;
  const CommonProfileDataDisplayWidget({
    super.key,
    required this.listItemData,
    this.onTapDelete,
    this.onTapUpdate,
    required this.currentSelectedSection,
  });

  @override
  State<CommonProfileDataDisplayWidget> createState() =>
      _CommonProfileDataDisplayWidgetState();
}

class _CommonProfileDataDisplayWidgetState
    extends State<CommonProfileDataDisplayWidget> {
  dynamic itemData;
  @override
  void initState() {
    itemData = Map.from(widget.listItemData);
    printDebug(textString: "==========================ItemData....${itemData}");
    itemData.removeWhere((key, value) {
      return (getTitleKeyForMultiDataWidget(
                  sectionId:
                      widget.currentSelectedSection!.recFieldCode.toString()) ==
              key) ||
          "nominationTypeId" == key;
    });
    if (itemData.keys.toList().contains("Is Tilldate Checked")) {
      itemData
          .removeWhere((key, value) => key == "From Date" || key == "To Date");
      itemData["Date"] = (widget.listItemData["From Date"] ?? "-") +
          " - " +
          (widget.listItemData["To Date"] ?? "-");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: PickColors.bgColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.listItemData[getTitleKeyForMultiDataWidget(
                              sectionId: widget
                                  .currentSelectedSection!.recFieldCode
                                  .toString())] !=
                          null
                      ? "${widget.listItemData[getTitleKeyForMultiDataWidget(sectionId: widget.currentSelectedSection!.recFieldCode.toString())][1]} : ${(widget.listItemData[getTitleKeyForMultiDataWidget(sectionId: widget.currentSelectedSection!.recFieldCode.toString())][0]) ?? "-"}"
                      : "-",
                  // "${getTitleKeyForMultiDataWidget(sectionId: widget.currentSelectedSection!.recFieldCode.toString())[0]}${getTitleKeyForMultiDataWidget(sectionId: widget.currentSelectedSection!.recFieldCode.toString())[1].split(",").map((element) {
                  //       return (widget.listItemData[element] ?? "-");
                  //     }).toList().join(" - ")}",
                  style: CommonTextStyle().textFieldLabelTextStyle.copyWith(
                        color: PickColors.primaryColor,
                      ),
                ),
              ),
              if (widget.onTapUpdate != null)
                InkWell(
                  onTap: widget.onTapUpdate,
                  child: SvgPicture.asset(
                    PickImages.editIcon,
                  ),
                ),
              if (widget.onTapDelete != null) PickHeightAndWidth.width10,
              if (widget.onTapDelete != null)
                InkWell(
                  onTap: widget.onTapDelete,
                  child: SvgPicture.asset(
                    PickImages.deleteIcon,
                  ),
                ),
            ],
          ),
          PickHeightAndWidth.height15,
          StaggeredGrid.count(
            mainAxisSpacing: 10.0,
            crossAxisCount: checkPlatForm(
              context: context,
              platforms: [
                CustomPlatForm.MOBILE,
                CustomPlatForm.MOBILE_VIEW,
                CustomPlatForm.MIN_MOBILE_VIEW,
                CustomPlatForm.MIN_MOBILE,
              ],
            )
                ? 1
                : 2,
            children: List.generate(
              itemData.keys.toList().length,
              (index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " ${itemData.keys.toList()[index] == "isTilldateChecked" ? "Currently Working" : itemData[itemData.keys.toList()[index]][1]}: ",
                      style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                            color: PickColors.blackColor,
                            fontFamily: "Cera Pro",
                          ),
                    ),
                    Expanded(
                      child: Text(
                        itemData[itemData.keys.toList()[index]]
                            .first
                            .toString(),
                        style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                              color: PickColors.primaryColor,
                              fontFamily: "Cera Pro",
                            ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
