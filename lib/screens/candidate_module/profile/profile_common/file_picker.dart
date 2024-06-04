import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';

import 'package:onboarding_app/constants/text_style.dart';

class UploadDocumentDesignWidget extends StatelessWidget {
  final dynamic onTapUpload;
  final String documentText;
  final String? uploadedFileName;
  final String hintText;
  const UploadDocumentDesignWidget({
    Key? key,
    required this.hintText,
    this.onTapUpload,
    required this.documentText,
    this.uploadedFileName,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(10),
      color: PickColors.hintColor,
      child: InkWell(
        onTap: onTapUpload,
        child: Container(
          height: 45,
          decoration: BoxDecoration(
              color: PickColors.whiteColor,
              borderRadius: BorderRadius.circular(10)),
          child: uploadedFileName == null || uploadedFileName == ""
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            hintText,
                            style: CommonTextStyle()
                                .noteHeadingTextStyle
                                .copyWith(fontSize: 13),
                          ),
                          SvgPicture.asset(
                            PickImages.filePickerIcon,
                            height: 35,
                          ),
                        ],
                      ),
                    ),

                    // documentText != ""
                    //     ? SizedBox(
                    //         height: 10,
                    //       )
                    //     : Container(),
                    // documentText != ""
                    //     ? Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           SvgPicture.asset(
                    //             PickImages.addIcon,
                    //             height: 20,
                    //           ),
                    //           SizedBox(
                    //             width: SizeConfig.screenWidth! * 0.02,
                    //           ),
                    //           Flexible(
                    //             child: Text(
                    //               documentText,
                    //               textAlign: TextAlign.center,
                    //               style: CommonTextStyle().subMainHeadingTextStyle,
                    //             ),
                    //           )
                    //         ],
                    //       )
                    //     : Container(),
                  ],
                )
              : Center(
                  child: Text(uploadedFileName ?? "",
                      style: CommonTextStyle().mainHeadingTextStyle),
                ),
        ),
      ),
    );
  }
}
