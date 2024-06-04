import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/text_style.dart';

class CommonMaterialButton extends StatefulWidget {
  const CommonMaterialButton({
    Key? key,
    required this.title,
    this.style,
    this.onPressed,
    this.color,
    this.height,
    this.width,
    this.borderColor,
    this.isButtonDisable = false,
    this.isLoading = false,
    this.borderRadius,
    this.verticalPadding,
  }) : super(key: key);

  final String title;
  final TextStyle? style;
  final dynamic onPressed;
  final Color? color;
  final double? width;
  final double? height;
  final Color? borderColor;
  final bool isButtonDisable;
  final bool isLoading;
  final double? borderRadius;
  final double? verticalPadding;

  @override
  State<CommonMaterialButton> createState() => _CommonMaterialButtonState();
}

class _CommonMaterialButtonState extends State<CommonMaterialButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: MaterialButton(
        color: widget.isButtonDisable
            ? widget.color?.withOpacity(0.2) ??
                PickColors.primaryColor.withOpacity(0.4)
            : widget.color ?? PickColors.primaryColor,
        // minWidth: widget.width,
        elevation: 0,
        height: widget.height,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
            side: BorderSide(
                color: (widget.isButtonDisable
                        ? widget.borderColor?.withOpacity(0.4)
                        : widget.borderColor) ??
                    Colors.transparent,
                width: 1)),
        onPressed: !widget.isButtonDisable ? widget.onPressed : () {},
        child: MouseRegion(
          cursor: !widget.isButtonDisable
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 0, vertical: widget.verticalPadding ?? 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    textAlign: TextAlign.center,
                    widget.title,
                    style: (widget.isButtonDisable
                            ? widget.style?.copyWith(
                                color: widget.style?.color?.withOpacity(0.4))
                            : widget.style) ??
                        CommonTextStyle().buttonTextStyle,
                  ),
                ),
                if (widget.isLoading)
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: SizedBox(
                      height: 13,
                      width: 13,
                      child: CircularProgressIndicator(
                        color: PickColors.whiteColor,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
