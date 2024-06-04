import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/generate_logo_name.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/widgets/network_image_builder.dart';

class BuildLogoProfileImageWidget extends StatefulWidget {
  final String? imagePath;
  final String? titleName;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final BorderRadiusGeometry? borderRadius;
  final bool isColors;
  BuildLogoProfileImageWidget(
      {super.key,
      required this.imagePath,
      required this.titleName,
      this.borderRadius,
      this.isColors = false,
      this.height,
      this.fit,
      this.width});

  @override
  State<BuildLogoProfileImageWidget> createState() =>
      _BuildLogoProfileImageWidgetState();
}

class _BuildLogoProfileImageWidgetState
    extends State<BuildLogoProfileImageWidget> {
  @override
  Widget build(BuildContext context) {
    return (widget.imagePath != null && widget.imagePath != "")
        ? NetWorkImageBuilder(
            fit: widget.fit,
            borderRadius: widget.borderRadius,
            height: widget.height ?? 40,
            width: widget.width ?? 40,
            imageUrl: widget.imagePath!,
          )
        : Container(
            height: widget.height ?? 40,
            width: widget.width ?? 40,
            // padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
              color: widget.isColors
                  ? PickColors.primaryColor.withOpacity(0.3)
                  : PickColors.bgColor,
            ),
            child: Center(
              child: Text(
                getLogoFromName(firstName: widget.titleName) ?? "",
                style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                    fontSize: (widget.height ?? 40) / 2,
                    color: widget.isColors
                        ? PickColors.primaryColor
                        : Color(0x80808080)),
              ),
            ),
          );
  }
}
