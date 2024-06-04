import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/date_formates.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:onboarding_app/widgets/form_builder_controls/text_field_control.dart';
import 'package:provider/provider.dart';

class OfferAcceptDialogBox extends StatefulWidget {
  const OfferAcceptDialogBox({super.key});

  @override
  State<OfferAcceptDialogBox> createState() => _OfferAcceptDialogBoxState();
}

class _OfferAcceptDialogBoxState extends State<OfferAcceptDialogBox> {
  bool isLoading = false;
  final acceptFormKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2(builder: (BuildContext context, GeneralHelper helper,
        AuthProvider authProvider, snapshot) {
      return SimpleDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        title: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Accept ${authProvider.candidateCurrentStage != CandidateStages.OFFER_ACCEPTANCE ? "Appointment" : "Offer"}",
                  style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                        color: PickColors.blackColor,
                        fontSize: 20,
                      ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                backToScreen(context: context);
              },
              child: SvgPicture.asset(
                alignment: Alignment.centerRight,
                PickImages.cancelIcon,
              ),
            ),
          ],
        ),
        children: [
          SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FormBuilder(
                      key: acceptFormKey,
                      initialValue: {
                        "joining_date": DateTime.tryParse(authProvider
                                        .applicantInformation!.dateOfJoining ??
                                    "") !=
                                null
                            ? DateFormate.normalDateFormate.format(
                                DateTime.parse(authProvider
                                        .applicantInformation!.dateOfJoining ??
                                    ""))
                            : ""
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            helper.translateTextTitle(
                                titleText: authProvider.applicantInformation!
                                        .offerAcceptanceMessage ??
                                    ""),
                            style:
                                CommonTextStyle().mainHeadingTextStyle.copyWith(
                                      color: PickColors.blackColor,
                                      fontSize: 15,
                                    ),
                          ),
                          PickHeightAndWidth.height5,
                          Text(
                            helper.translateTextTitle(
                                    titleText: "Your joining date is") +
                                " " +
                                (DateTime.tryParse(authProvider
                                                .applicantInformation!
                                                .dateOfJoining ??
                                            "") !=
                                        null
                                    ? DateFormate.normalDateFormate.format(
                                        DateTime.parse(authProvider
                                                .applicantInformation!
                                                .dateOfJoining ??
                                            ""))
                                    : "-"),
                            style:
                                CommonTextStyle().mainHeadingTextStyle.copyWith(
                                      color: PickColors.blackColor,
                                      fontSize: 15,
                                    ),
                          ),
                          PickHeightAndWidth.height30,
                          CommonFormBuilderTextField(
                            maxLines: 5,
                            maxCharLength: 300,
                            fieldName: "Remarks",
                            isRequired: true,
                            hint: helper.translateTextTitle(
                                titleText:
                                    "Kindly use this space below to acknowledge your ${authProvider.candidateCurrentStage != CandidateStages.OFFER_ACCEPTANCE ? "appointment" : "offer"} acceptance in writing."),
                            onChanged: (value) {},
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: "Remarks is Mandatory"),
                            ]),
                            keyboardType: TextInputType.text,
                          ),
                          PickHeightAndWidth.height15,
                          Row(
                            children: [
                              Expanded(
                                child: CommonMaterialButton(
                                  borderColor: PickColors.primaryColor,
                                  color: PickColors.whiteColor,
                                  title: helper.translateTextTitle(
                                          titleText: "Cancel") ??
                                      "-",
                                  style: CommonTextStyle()
                                      .buttonTextStyle
                                      .copyWith(
                                        color: PickColors.primaryColor,
                                      ),
                                  onPressed: () {
                                    backToScreen(context: context);
                                  },
                                ),
                              ),
                              PickHeightAndWidth.width10,
                              Expanded(
                                child: CommonMaterialButton(
                                  title: (authProvider.candidateCurrentStage ==
                                              CandidateStages.OFFER_ACCEPTANCE
                                          ? (authProvider.applicantInformation!
                                                  .isAcceptanceFlow ??
                                              false)
                                          : (authProvider.applicantInformation!
                                                  .isAppointmentAcceptanceFlow ??
                                              false))
                                      ? helper.translateTextTitle(
                                              titleText: "Proceed") ??
                                          "-"
                                      : helper.translateTextTitle(
                                              titleText: "Submit") ??
                                          "-",
                                  onPressed: () async {
                                    if (acceptFormKey.currentState!
                                        .validate()) {
                                      acceptFormKey.currentState!.save();
                                      if ((authProvider.applicantInformation!
                                                  .dateOfJoining ??
                                              "") !=
                                          "") {
                                        backToScreenWithArg(
                                          context: context,
                                          result: {
                                            "remark": acceptFormKey
                                                .currentState!.value["Remarks"]
                                          },
                                        );
                                      } else {
                                        await showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return CommonConfirmationDialogBox(
                                              buttonTitle:
                                                  helper.translateTextTitle(
                                                      titleText: "Okay"),
                                              title: helper.translateTextTitle(
                                                  titleText: "Alert"),
                                              subTitle:
                                                  "Am sorry,as your${authProvider.candidateCurrentStage != CandidateStages.OFFER_ACCEPTANCE ? "appointment" : "offer"} latter has not yet been generated. date of Joining is not present , please contact HR team",
                                              onPressButton: () async {
                                                backToScreen(context: context);
                                              },
                                            );
                                          },
                                        );
                                      }
                                    } else {
                                      await showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return CommonConfirmationDialogBox(
                                            buttonTitle:
                                                helper.translateTextTitle(
                                                    titleText: "Okay"),
                                            title: helper.translateTextTitle(
                                                titleText: "Alert"),
                                            subTitle: acceptFormKey
                                                        .currentState!.errors[
                                                    acceptFormKey.currentState!
                                                        .errors.keys
                                                        .toList()
                                                        .first] ??
                                                "-",
                                            onPressButton: () async {
                                              backToScreen(context: context);
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          )
        ],
      );
    });
  }
}
