// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/share_pref_keys.dart';
import 'package:onboarding_app/constants/share_preference.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_providers/candidate_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/common_form_builder_check_box.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructionsDialogBox extends StatefulWidget {
  const InstructionsDialogBox({super.key});

  @override
  State<InstructionsDialogBox> createState() => _InstructionsDialogBoxState();
}

class _InstructionsDialogBoxState extends State<InstructionsDialogBox> {
  bool isCheck = false;
  @override
  Widget build(BuildContext context) {
    return Consumer2(builder: (BuildContext context,
        CandidateProvider candidateProvider, GeneralHelper helper, snapshot) {
      return AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        title: Align(
          alignment: Alignment.center,
          child: Text(
            helper.translateTextTitle(titleText: "Instructions") ?? "-",
            style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                  color: PickColors.blackColor,
                  fontSize: 20,
                ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DocumentInstructionWidget(),
            CommonFormBuilderCheckbox(
              onChanged: (newValue) {
                setState(() {
                  isCheck = newValue;
                });
              },
              title: helper.translateTextTitle(
                  titleText: "Yes, I have read and understood."),
              fieldName: '',
            ),
            CommonMaterialButton(
              isButtonDisable: !isCheck,
              title: helper.translateTextTitle(titleText: "Proceed") ?? "-",
              onPressed: () async {
                if (isCheck) {
                  await Shared_Preferences.prefSetBool(
                      SharedP.instructionFlag, true);
                  backToScreen(context: context);
                }
              },
            ),
          ],
        ),
      );
    });
  }
}

class DocumentInstructionWidget extends StatelessWidget {
  const DocumentInstructionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder:
        (BuildContext context, CandidateProvider candidateProvider, snapshot) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
            candidateProvider.documentInstructionList.length, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                candidateProvider
                        .documentInstructionList[index].documentInstruction ??
                    "",
                style: CommonTextStyle().textFieldLabelTextStyle.copyWith(
                      color: PickColors.blackColor,
                      fontWeight: FontWeight.normal,
                    ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    candidateProvider.documentInstructionList[index]
                        .lstInstructionsFileDetails!.length, (subindex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5, left: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          String url = candidateProvider
                                  .documentInstructionList[index]
                                  .lstInstructionsFileDetails![subindex]
                                  .fileURL ??
                              "";

                          // if (await canLaunchUrl(Uri.parse(url))) {

                          await launchUrl(Uri.parse(url));
                          // } else {
                          //   // ignore: use_build_context_synchronously
                          //   showToast(
                          //     context: context,
                          //     isPositive: false,
                          //     message: "Could not launch $url",
                          //   );
                          // }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              PickImages.docDownloadIcon,
                            ),
                            Flexible(
                              child: Text(
                                "  Instruction Document ${subindex + 1}",
                                style: CommonTextStyle()
                                    .textFieldLabelTextStyle
                                    .copyWith(
                                      color: PickColors.navyBlueColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              )
            ],
          );
        }),
      );
    });
  }
}
