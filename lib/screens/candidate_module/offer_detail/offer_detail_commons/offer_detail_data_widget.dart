import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';

class OfferDetailDataWidget extends StatelessWidget {
  final Color? backgroundColor;
  final String mainTitle;
  final dynamic icon;
  final List dataList;
  final dynamic secondHeadingData;
  final bool isSpaceBetween;
  final bool isSecondHeading;

  const OfferDetailDataWidget({
    super.key,
    this.backgroundColor,
    required this.mainTitle,
    this.icon,
    required this.dataList,
    this.isSpaceBetween = true,
    this.isSecondHeading = false,
    this.secondHeadingData,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: backgroundColor ?? PickColors.whiteColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: PickColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      icon,
                      color: PickColors.whiteColor,
                    ),
                  ),
                ),
                PickHeightAndWidth.width10,
                Expanded(
                  child: Text(
                    mainTitle,
                    style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                          overflow: TextOverflow.ellipsis,
                          fontSize: SizeConfig.screenWidth! * 0.01 < 16
                              ? 16
                              : SizeConfig.screenWidth! * 0.01,
                        ),
                  ),
                )
              ],
            ),
            PickHeightAndWidth.height10,
            Divider(
              thickness: 1,
              color: PickColors.hintColor,
            ),
            if (isSecondHeading)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: isSpaceBetween
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.start,
                children: [
                  Text(
                    secondHeadingData["title"],
                    style: CommonTextStyle()
                        .textFieldLabelTextStyle
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  // PickHeightAndWidth.width10,
                  Text(
                    secondHeadingData["titleValue"],
                    style: CommonTextStyle()
                        .textFieldLabelTextStyle
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  // Container()
                ],
              ),
            if (isSecondHeading) Divider(),
            ListView.builder(
              shrinkWrap: true,
              itemCount: dataList.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: isSpaceBetween
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.start,
                    children: [
                      Text(
                        dataList[index]["title"] +
                            (isSpaceBetween ? "" : " : "),
                        style: CommonTextStyle().textFieldLabelTextStyle,
                      ),
                      // PickHeightAndWidth.width10,
                      Text(
                        dataList[index]["titleValue"],
                        style: CommonTextStyle().textFieldLabelTextStyle,
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
