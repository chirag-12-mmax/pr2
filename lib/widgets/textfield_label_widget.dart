import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/text_style.dart';

class TextFieldLabelWidget extends StatelessWidget {
  const TextFieldLabelWidget({
    Key? key,
    required this.title,
    required this.isRequired,
    this.testStyle,
  }) : super(key: key);
  final String title;
  final bool isRequired;
  final TextStyle? testStyle;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: title + " ",
        style: testStyle ??
            CommonTextStyle().noteHeadingTextStyle.copyWith(
                  color: PickColors.blackColor,
                  fontFamily: "Cera Pro",
                  fontWeight: FontWeight.normal,
                ),
        children: isRequired
            ? [
                TextSpan(
                  text: "*",
                  style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                        color: PickColors.primaryColor,
                      ),
                ),
              ]
            : [],
      ),
    );
  }
}
