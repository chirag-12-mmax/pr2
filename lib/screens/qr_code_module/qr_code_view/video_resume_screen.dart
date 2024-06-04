import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_provider/qr_code_provider.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_view/video_quisition_widget.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:provider/provider.dart';

class VideoResumeScreen extends StatefulWidget {
  const VideoResumeScreen({super.key});

  @override
  State<VideoResumeScreen> createState() => _VideoResumeScreenState();
}

class _VideoResumeScreenState extends State<VideoResumeScreen> {
  bool isVideoResumeStarted = false;
  bool isLoading = false;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  initializeData() async {
    setState(() {
      isLoading = true;
    });
    final qrCodeProvider = Provider.of<QRCodeProvider>(context, listen: false);
    await qrCodeProvider
        .getQuizDetailForQrCodeApiFunction(context: context, dataParameter: {
      "requisitionId": qrCodeProvider.qrRequisitionId ?? "",
      "_": DateTime.now().millisecondsSinceEpoch.toString(),
    });

    if (qrCodeProvider.candidateQuizDetail != null) {
      (qrCodeProvider.candidateQuizDetail!.questions ?? []).sort(((a, b) {
        return b.questionType!.compareTo(a.questionType!);
      }));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return isLoading
        ? const CircularProgressIndicator()
        : isVideoResumeStarted
            ? const VideoQuestionWidget()
            : Consumer2(builder: (BuildContext context,
                QRCodeProvider qrCodeProvider, GeneralHelper helper, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      constraints: const BoxConstraints(minHeight: 200),
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: PickColors.whiteColor,
                      ),
                      child: SvgPicture.asset(
                        PickImages.qrVideoImage,
                        height: 250,
                        // width: 200,
                      ),
                    ),
                    PickHeightAndWidth.height30,
                    Text(
                      helper.translateTextTitle(titleText: "Pre Assessment") ??
                          "-",
                      style: CommonTextStyle().textFieldLabelTextStyle.copyWith(
                            fontSize: 18,
                          ),
                    ),
                    PickHeightAndWidth.height20,
                    Text(
                      helper.translateTextTitle(titleText: "Instructions") ??
                          "-",
                      style: CommonTextStyle().textFieldLabelTextStyle.copyWith(
                            fontSize: 18,
                          ),
                    ),
                    PickHeightAndWidth.height20,
                    (qrCodeProvider.candidateQuizDetail!.status!.isQuizSubmit ??
                            false)
                        ? Text(
                            helper.translateTextTitle(
                                titleText:
                                    "The Assessment has been submitted successfully"),
                            style:
                                CommonTextStyle().noteHeadingTextStyle.copyWith(
                                      fontFamily: "Cera Pro",
                                      color: PickColors.blackColor,
                                    ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                GlobalList.instructionList.length,
                                (index) => InstructionsInfoWidget(
                                      title: GlobalList.instructionList[index],
                                    ))),
                    PickHeightAndWidth.height40,
                    Container(
                      constraints: const BoxConstraints(minWidth: 350),
                      width: SizeConfig.screenWidth! * 0.20,
                      child: CommonMaterialButton(
                        title: (qrCodeProvider.candidateQuizDetail!.status!
                                        .isQuizSubmit ??
                                    false) ||
                                qrCodeProvider
                                    .candidateQuizDetail!.questions!.isEmpty
                            ? helper.translateTextTitle(titleText: "Next") ??
                                "-"
                            : helper.translateTextTitle(titleText: "Start"),

                        // isButtonDisable: (qrCodeProvider
                        //         .candidateQuizDetail!.status!.isQuizSubmit ??
                        //     false),
                        onPressed: () async {
                          if (qrCodeProvider
                              .candidateQuizDetail!.questions!.isNotEmpty) {
                            if ((qrCodeProvider.candidateQuizDetail!.status!
                                    .isQuizSubmit ??
                                false)) {
                              qrCodeProvider.updateQrCodeScreenIndex(
                                  context: context,
                                  tabIndex:
                                      qrCodeProvider.qrCodeSelectedTabIndex +
                                          1);
                            } else {
                              setState(() {
                                isVideoResumeStarted = true;
                              });
                            }
                          } else {
                            qrCodeProvider.updateQrCodeScreenIndex(
                                context: context,
                                tabIndex:
                                    qrCodeProvider.qrCodeSelectedTabIndex + 1);
                          }
                        },
                      ),
                    ),
                  ],
                );
              });
  }
}

class InstructionsInfoWidget extends StatelessWidget {
  final String? title;
  const InstructionsInfoWidget({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? "",
      style: CommonTextStyle().noteHeadingTextStyle.copyWith(
            fontFamily: "Cera Pro",
            color: PickColors.blackColor,
          ),
    );
  }
}
