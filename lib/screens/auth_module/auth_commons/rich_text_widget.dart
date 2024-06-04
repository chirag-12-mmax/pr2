import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';

class RichTextWidget extends StatelessWidget {
  const RichTextWidget({
    super.key,
    this.mainTitle,
    this.subTitle,
    this.subTitle2,
    this.subTitle3,
    this.subTitle4,
    this.mainTitleColor,
    this.subTitleColor,
    this.recognizer,
    this.fontWeight,
    this.textAlign,
    this.mainTitleStyle,
    this.subTitleStyle,
    this.subTitle2Style,
  });

  final String? mainTitle;
  final String? subTitle;
  final String? subTitle2;
  final String? subTitle3;
  final String? subTitle4;
  final Color? mainTitleColor;
  final Color? subTitleColor;
  final TextAlign? textAlign;
  final GestureRecognizer? recognizer;
  final FontWeight? fontWeight;
  final TextStyle? mainTitleStyle;
  final TextStyle? subTitleStyle;
  final TextStyle? subTitle2Style;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RichText(
      // maxLines: 2,
      textAlign: textAlign ?? TextAlign.center,
      text: TextSpan(
        text: mainTitle,
        style: mainTitleStyle ??
            CommonTextStyle().noteHeadingTextStyle.copyWith(
                  color: mainTitleColor ?? PickColors.blackColor,
                  fontFamily: "Cera Pro",
                ),
        children: [
          TextSpan(
            recognizer: recognizer,
            text: subTitle,
            style: subTitleStyle ??
                CommonTextStyle().noteHeadingTextStyle.copyWith(
                      color: subTitleColor ?? PickColors.primaryColor,
                      fontFamily: "Cera Pro",
                    ),
          ),
          TextSpan(
            recognizer: recognizer,
            text: subTitle2,
            style: subTitle2Style ??
                CommonTextStyle().noteHeadingTextStyle.copyWith(
                      color: subTitleColor ?? PickColors.blackColor,
                      fontFamily: "Cera Pro",
                    ),
          ),
          TextSpan(
            recognizer: recognizer,
            text: subTitle3,
            style: subTitleStyle ??
                CommonTextStyle().noteHeadingTextStyle.copyWith(
                      color: subTitleColor ?? PickColors.primaryColor,
                      fontFamily: "Cera Pro",
                    ),
          ),
          TextSpan(
            recognizer: recognizer,
            text: subTitle4,
            style: mainTitleStyle ??
                CommonTextStyle().noteHeadingTextStyle.copyWith(
                      color: subTitleColor ?? PickColors.blackColor,
                      fontFamily: "Cera Pro",
                    ),
          ),
        ],
      ),
    );
  }
}
