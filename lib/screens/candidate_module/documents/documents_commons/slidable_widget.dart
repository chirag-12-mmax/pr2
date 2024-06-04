import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/launch_url.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/rich_text_widget.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_models/document_data_model.dart';
import 'package:onboarding_app/widgets/form_builder_controls/file_upload_widget.dart';
import 'package:provider/provider.dart';

class SlidableWidget extends StatefulWidget {
  const SlidableWidget(
      {super.key,
      required this.documentData,
      this.onTapDelete,
      this.onTapReview,
      this.onTapAddButton,
      this.helper,
      this.onTapViewButton,
      required this.onTapDeleteDisable,
      required this.onTapReviewDisable,
      required this.onTapAddButtonDisable,
      required this.onTapViewButtonDisable,
      required this.isFromNoDocument});
  final DocumentDataModel documentData;
  final dynamic onTapDelete;
  final dynamic onTapReview;
  final GeneralHelper? helper;
  final dynamic onTapAddButton;
  final dynamic onTapViewButton;
  final bool onTapDeleteDisable;
  final bool onTapReviewDisable;
  final bool onTapAddButtonDisable;
  final bool onTapViewButtonDisable;
  final bool isFromNoDocument;

  @override
  State<SlidableWidget> createState() => _SlidableWidgetState();
}

class _SlidableWidgetState extends State<SlidableWidget> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      // endActionPane: checkPlatForm(context: context, platforms: [
      //   CustomPlatForm.MOBILE,
      //   CustomPlatForm.MOBILE_VIEW,
      //   CustomPlatForm.TABLET,
      //   CustomPlatForm.TABLET_VIEW,
      // ])
      //     ? ActionPane(
      //         motion: const DrawerMotion(),
      //         dismissible: DismissiblePane(onDismissed: () {}),
      //         children: [
      //           SlidableAction(
      //             borderRadius: const BorderRadius.only(
      //               bottomRight: Radius.circular(10),
      //               topRight: Radius.circular(10),
      //             ),
      //             onPressed: (context) {
      //               widget.onTapDelete();
      //             },
      //             backgroundColor: PickColors.primaryColor,
      //             foregroundColor: PickColors.whiteColor,
      //             icon: Icons.delete_outline,
      //           ),
      //         ],
      //       )
      //     : null,
      child: Container(
        padding: checkPlatForm(context: context, platforms: [
          CustomPlatForm.MOBILE,
          CustomPlatForm.MOBILE_VIEW,
          CustomPlatForm.MIN_MOBILE_VIEW,
          CustomPlatForm.MIN_MOBILE,
        ])
            ? const EdgeInsets.only(left: 10, right: 10, top: 10)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
              color: PickColors.hintColor.withOpacity(0.3), width: 1),
          color: PickColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                if (!widget.isFromNoDocument)
                  Container(
                    height: 40,
                    width: 40,
                    // padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: PickColors.primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        widget.documentData.uploadedDocumentCount.toString(),
                        style: CommonTextStyle().buttonTextStyle,
                      ),
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: RichTextWidget(
                              textAlign: TextAlign.start,
                              mainTitle:
                                  widget.documentData.isMandatory ?? false
                                      ? "* "
                                      : "",
                              subTitle:
                                  widget.documentData.documentName.toString(),
                              mainTitleStyle: CommonTextStyle()
                                  .textFieldLabelTextStyle
                                  .copyWith(
                                    color: PickColors.primaryColor,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Cera Pro",
                                  ),
                              subTitleStyle: CommonTextStyle()
                                  .subMainHeadingTextStyle
                                  .copyWith(
                                    fontSize: 16,
                                    fontFamily: "Cera Pro",
                                  ),
                            ),
                          ),
                          PickHeightAndWidth.width5,
                          if (!widget.isFromNoDocument &&
                              (widget.documentData.sampleDocumentPath ?? "") !=
                                  "")
                            InkWell(
                                onTap: () async {
                                  await launchUrlServiceFunction(
                                      context: context,
                                      url: widget
                                          .documentData.sampleDocumentPath
                                          .toString());
                                },
                                child: Icon(
                                  Icons.file_download,
                                  color: PickColors.primaryColor,
                                )
                                // child: SvgPicture.asset(
                                //   PickImages.viewIcon,
                                //   color: PickColors.primaryColor,
                                // ),
                                ),
                          if ((widget.documentData.isBGVRequired ?? false))
                            Icon(
                              Icons.shield_outlined,
                              color: PickColors.primaryColor,
                            ),
                        ],
                      ),
                      // PickHeightAndWidth.height5,

                      Text(
                        widget.helper?.translateTextTitle(
                          titleText: getStatusInformationFromStatus(
                              documentStatus:
                                  widget.documentData.documentStatus ??
                                      "Pending")["title"],
                        ),
                        style:
                            CommonTextStyle().textFieldLabelTextStyle.copyWith(
                                  color: getStatusInformationFromStatus(
                                      documentStatus:
                                          widget.documentData.documentStatus ??
                                              "Pending")["color"],
                                ),
                      ),
                    ],
                  ),
                ),
                if (!checkPlatForm(context: context, platforms: [
                  CustomPlatForm.MOBILE,
                  CustomPlatForm.MOBILE_VIEW,
                  CustomPlatForm.MIN_MOBILE_VIEW,
                  CustomPlatForm.MIN_MOBILE,
                ]))
                  if (!widget.isFromNoDocument)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 30,
                      width: 1,
                      color: PickColors.hintColor,
                    ),
                if (!checkPlatForm(context: context, platforms: [
                  CustomPlatForm.MOBILE,
                  CustomPlatForm.MOBILE_VIEW,
                  CustomPlatForm.MIN_MOBILE_VIEW,
                  CustomPlatForm.MIN_MOBILE,
                ]))
                  if (!widget.isFromNoDocument)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SizedBox(
                        width: 20,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: DocumentUploadWidget(
                            isRequired: true,
                            isEnabled: !widget.onTapAddButtonDisable,
                            onChanged: widget.onTapAddButton,
                            color: widget.onTapAddButtonDisable
                                ? Colors.grey.withOpacity(0.3)
                                : PickColors.greenColor,
                            fieldName:
                                widget.documentData.documentName.toString(),
                          ),
                        ),
                      ),
                    ),
                if (!checkPlatForm(context: context, platforms: [
                  CustomPlatForm.MOBILE,
                  CustomPlatForm.MOBILE_VIEW,
                  CustomPlatForm.MIN_MOBILE_VIEW,
                  CustomPlatForm.MIN_MOBILE,
                ]))
                  if (widget.onTapReview != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: InkWell(
                        onTap: widget.onTapReview,
                        child: SvgPicture.asset(PickImages.messageIcon,
                            height: 19),
                      ),
                    ),
                if (!checkPlatForm(context: context, platforms: [
                  CustomPlatForm.MOBILE,
                  CustomPlatForm.MOBILE_VIEW,
                  CustomPlatForm.MIN_MOBILE_VIEW,
                  CustomPlatForm.MIN_MOBILE,
                ]))
                  if (widget.onTapViewButton != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: InkWell(
                        onTap: widget.onTapViewButtonDisable
                            ? null
                            : widget.onTapViewButton,
                        child: SvgPicture.asset(PickImages.viewIcon,
                            height: 19,
                            colorFilter: ColorFilter.mode(
                                widget.onTapViewButtonDisable
                                    ? Colors.grey.withOpacity(0.3)
                                    : Colors.black,
                                BlendMode.srcIn)),
                      ),
                    ),
                if (!checkPlatForm(context: context, platforms: [
                  CustomPlatForm.MOBILE,
                  CustomPlatForm.MOBILE_VIEW,
                  CustomPlatForm.MIN_MOBILE_VIEW,
                  CustomPlatForm.MIN_MOBILE,
                ]))
                  if (widget.onTapDelete != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: InkWell(
                        onTap: widget.onTapDeleteDisable
                            ? null
                            : widget.onTapDelete,
                        child: SvgPicture.asset(
                          PickImages.deleteIcon,
                          colorFilter: ColorFilter.mode(
                              widget.onTapDeleteDisable
                                  ? Colors.grey.withOpacity(0.3)
                                  : Colors.red,
                              BlendMode.srcIn),
                          height: 19,
                        ),
                      ),
                    ),
              ],
            ),
            if (checkPlatForm(context: context, platforms: [
              CustomPlatForm.MOBILE,
              CustomPlatForm.MOBILE_VIEW,
              CustomPlatForm.MIN_MOBILE_VIEW,
              CustomPlatForm.MIN_MOBILE,
            ]))
              // if (!widget.isFromNoDocument)
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 1,
                color: PickColors.hintColor.withOpacity(0.3),
              ),
            if (checkPlatForm(context: context, platforms: [
              CustomPlatForm.MOBILE,
              CustomPlatForm.MOBILE_VIEW,
              CustomPlatForm.MIN_MOBILE_VIEW,
              CustomPlatForm.MIN_MOBILE,
            ]))
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!widget.isFromNoDocument)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: 20,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 9),
                          child: DocumentUploadWidget(
                            isRequired: true,
                            isEnabled: !widget.onTapAddButtonDisable,
                            onChanged: widget.onTapAddButton,
                            color: widget.onTapAddButtonDisable
                                ? Colors.grey.withOpacity(0.3)
                                : PickColors.greenColor,
                            fieldName:
                                widget.documentData.documentName.toString(),
                          ),
                        ),
                      ),
                    ),
                  if (widget.onTapReview != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: InkWell(
                        onTap: widget.onTapReview,
                        child: SvgPicture.asset(PickImages.messageIcon,
                            height: 19),
                      ),
                    ),
                  if (widget.onTapViewButton != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: widget.onTapViewButtonDisable
                            ? null
                            : widget.onTapViewButton,
                        child: SvgPicture.asset(PickImages.viewIcon,
                            height: 19,
                            colorFilter: ColorFilter.mode(
                                widget.onTapViewButtonDisable
                                    ? Colors.grey.withOpacity(0.3)
                                    : Colors.black,
                                BlendMode.srcIn)),
                      ),
                    ),
                  if (widget.onTapDelete != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        onTap: widget.onTapDeleteDisable
                            ? null
                            : widget.onTapDelete,
                        child: SvgPicture.asset(
                          PickImages.deleteIcon,
                          colorFilter: ColorFilter.mode(
                              widget.onTapDeleteDisable
                                  ? Colors.grey.withOpacity(0.3)
                                  : Colors.red,
                              BlendMode.srcIn),
                          height: 19,
                        ),
                      ),
                    ),
                ],
              )
          ],
        ),
      ),
    );
  }
}

dynamic getStatusInformationFromStatus({required String documentStatus}) {
  switch (documentStatus) {
    case "Pending":
      return {
        "title": "Pending",
        "color": PickColors.yellowColor,
      };
    case "Not Submitted":
      return {
        "title": "Not Submitted",
        "color": PickColors.yellowColor,
      };

    case "Verified":
      return {
        "title": "Verified",
        "color": PickColors.greenColor,
      };
    case "Submitted":
      return {
        "title": "Uploaded",
        "color": PickColors.skyColor,
      };
    case "Rejected":
      return {
        "title": "Rejected",
        "color": PickColors.primaryColor,
      };
    default:
      return {
        "title": "Pending",
        "color": PickColors.yellowColor,
      };
  }
}
