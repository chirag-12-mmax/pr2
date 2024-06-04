// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/set_time_duration.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_provider/qr_code_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:onboarding_app/widgets/form_builder_controls/text_field_control.dart';
import 'package:provider/provider.dart';

class VideoQuestionWidget extends StatefulWidget {
  const VideoQuestionWidget({
    super.key,
  });

  @override
  State<VideoQuestionWidget> createState() => _VideoQuestionWidgetState();
}

class _VideoQuestionWidgetState extends State<VideoQuestionWidget> {
  int? timerCount = 0;
  int currentIndex = 0;
  CameraController? cameraController;
  late List<CameraDescription> _cameras;
  bool isRecording = false;
  XFile? recordedFile;

  List<dynamic> questionsWithAnswerList = [];

  int timeForEachQuestion = 90;

  Timer? timer;

  @override
  void initState() {
    setInitialData();
    super.initState();
  }

  Future<void> setInitialData() async {
    final qrCodeProvider = Provider.of<QRCodeProvider>(context, listen: false);
    questionsWithAnswerList = List.generate(
        qrCodeProvider.candidateQuizDetail!.questions!.length,
        (index) => {
              "questionId": qrCodeProvider
                  .candidateQuizDetail!.questions![index].questionId,
              "questionType": qrCodeProvider
                  .candidateQuizDetail!.questions![index].questionType,
              "answerText": "",
              "videoResumeFileName": "",
              "objective": qrCodeProvider
                  .candidateQuizDetail!.questions![index].objectiveQType
            });

    if (qrCodeProvider.candidateQuizDetail!.questions!.first.questionType ==
        "subjective") {
      timerCount = timeForEachQuestion;
      await setCameraForVideoRecording();
    } else {
      timerCount = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2(builder: (BuildContext context,
        QRCodeProvider qrCodeProvider, GeneralHelper helper, snapshot) {
      return Column(
        children: [
          if (timerCount != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    helper.translateTextTitle(titleText: "Pre Assessment") ??
                        "-",
                    style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                          color: PickColors.blackColor,
                          fontSize: 17,
                        ),
                  ),
                ),
                Text(
                  "Timer - ${formatDurationInHhMmSs(duration: Duration(seconds: timerCount ?? 0))}",
                  style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                        color: PickColors.primaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          PickHeightAndWidth.height20,
          Center(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: PickColors.whiteColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "${currentIndex + 1} . ${qrCodeProvider.candidateQuizDetail!.questions![currentIndex].questionText ?? "-"}",
                          style: CommonTextStyle().textFieldLabelTextStyle,
                        ),
                      ),
                      if (qrCodeProvider.candidateQuizDetail!
                              .questions![currentIndex].isMandatory ??
                          false)
                        Text(
                          '*',
                          style: CommonTextStyle()
                              .noteHeadingTextStyle
                              .copyWith(
                                  fontSize: 15, color: PickColors.primaryColor),
                        ),
                    ],
                  ),
                  if (qrCodeProvider.candidateQuizDetail!
                          .questions![currentIndex].questionType ==
                      "objective")
                    (qrCodeProvider.candidateQuizDetail!
                                .questions![currentIndex].objectiveQType !=
                            "shortparagraph")
                        ? Column(
                            children: List.generate(4, (innerIndex) {
                              if (((qrCodeProvider.candidateQuizDetail!
                                                  .questions![currentIndex]
                                                  .toJson()[
                                              "option${innerIndex + 1}"]) ??
                                          "")
                                      .toString()
                                      .trim() !=
                                  "") {
                                return QuestionOptionWidget(
                                  isOptionSelected: questionsWithAnswerList[
                                          currentIndex]["answerText"]
                                      .toString()
                                      .split(",")
                                      .contains((innerIndex + 1).toString()),
                                  onTapOption: () {
                                    setState(() {
                                      if (qrCodeProvider
                                              .candidateQuizDetail!
                                              .questions![currentIndex]
                                              .objectiveQType ==
                                          "singlechoice") {
                                        questionsWithAnswerList[currentIndex]
                                                ["answerText"] =
                                            (innerIndex + 1).toString();
                                      } else {
                                        List<String> tempAnswerList = [];

                                        tempAnswerList =
                                            questionsWithAnswerList[
                                                    currentIndex]["answerText"]
                                                .toString()
                                                .trim()
                                                .split(",");

                                        if (tempAnswerList.contains(
                                            (innerIndex + 1).toString())) {
                                          tempAnswerList.remove(
                                              (innerIndex + 1).toString());
                                        } else {
                                          tempAnswerList
                                              .add((innerIndex + 1).toString());
                                        }

                                        tempAnswerList
                                            .sort((a, b) => a.compareTo(b));

                                        questionsWithAnswerList[currentIndex]
                                            ["answerText"] = "";

                                        tempAnswerList.forEach((ele) {
                                          if (questionsWithAnswerList[
                                                          currentIndex]
                                                      ["answerText"]
                                                  .toString() !=
                                              "") {
                                            questionsWithAnswerList[
                                                    currentIndex]
                                                ["answerText"] += ",";
                                          }
                                          questionsWithAnswerList[currentIndex]
                                              ["answerText"] += ele;
                                        });

                                        print(
                                            "=======Answer========${questionsWithAnswerList[currentIndex]["answerText"]}");
                                      }
                                    });
                                  },
                                  optionText: "A. " +
                                      (qrCodeProvider.candidateQuizDetail!
                                          .questions![currentIndex]
                                          .toJson()["option${innerIndex + 1}"]),
                                );
                              } else {
                                return Container();
                              }
                            }),
                          )
                        : Container(
                            child: CommonFormBuilderTextField(
                              maxLines: 5,
                              isOnlyUppercase: false,
                              fieldName: "Answer Text",
                              isRequired: qrCodeProvider.candidateQuizDetail!
                                      .questions![currentIndex].isMandatory ??
                                  false,
                              maxCharLength: 570,
                              hint: "Answer text",
                              onChanged: (value) {
                                questionsWithAnswerList[currentIndex]
                                    ["answerText"] = value;
                              },
                              keyboardType: TextInputType.text,
                            ),
                          ),
                  if (qrCodeProvider.candidateQuizDetail!
                          .questions![currentIndex].questionType ==
                      "subjective")
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: cameraController != null
                              ? CameraPreview(
                                  cameraController!,
                                )
                              : Container(),
                        ),
                      ),
                    ),
                  PickHeightAndWidth.height20,
                  Center(
                    child: SizedBox(
                      width: checkPlatForm(context: context, platforms: [
                        CustomPlatForm.MOBILE,
                        CustomPlatForm.MOBILE_VIEW,
                        CustomPlatForm.MIN_MOBILE,
                        CustomPlatForm.MIN_MOBILE_VIEW,
                        CustomPlatForm.TABLET,
                        CustomPlatForm.TABLET_VIEW
                      ])
                          ? SizeConfig.screenWidth
                          : SizeConfig.screenWidth! / 2,
                      child: Row(
                        children: [
                          // if (qrCodeProvider.candidateQuizDetail!
                          //             .questions![currentIndex].questionType ==
                          //         "objective" &&
                          //     currentIndex != 0)
                          //   Expanded(
                          //     child: CommonMaterialButton(
                          //         title: "Previous" ?? "-",
                          //         onPressed: () async {
                          //           if (qrCodeProvider
                          //                   .candidateQuizDetail!
                          //                   .questions![currentIndex - 1]
                          //                   .questionType !=
                          //               "objective") {
                          //             await showDialog(
                          //               barrierDismissible: false,
                          //               context: context,
                          //               builder: (context) {
                          //                 return CommonConfirmationDialogBox(
                          //                   buttonTitle:
                          //                       helper.translateTextTitle(titleText:"Okay"),
                          //                   title:
                          //                       helper.translateTextTitle(titleText:"Alert"),
                          //                   subTitle: helper.translateTextTitle(titleText: )
                          //                       .previousActionForVideoInterviewQuestionsIsNotAllowed,
                          //                   onPressButton: () async {
                          //                     backToScreen(context: context);
                          //                   },
                          //                 );
                          //               },
                          //             );
                          //           } else {
                          //             setState(() {
                          //               currentIndex--;
                          //             });
                          //           }
                          //         }),
                          //   ),
                          // PickHeightAndWidth.width20,
                          Expanded(
                            child: CommonMaterialButton(
                                title: currentIndex ==
                                        (qrCodeProvider.candidateQuizDetail!
                                                .questions!.length -
                                            1)
                                    ? helper.translateTextTitle(
                                            titleText: "Submit") ??
                                        "-"
                                    : helper.translateTextTitle(
                                            titleText: "Next") ??
                                        "-",
                                onPressed: () async {
                                  if (timerCount != null
                                      ? timerCount! > 5
                                      : true) {
                                    if (timerCount == null) {
                                      if (qrCodeProvider
                                              .candidateQuizDetail!
                                              .questions![currentIndex]
                                              .isMandatory ??
                                          false) {
                                        if (questionsWithAnswerList[
                                                    currentIndex]["answerText"]
                                                .toString()
                                                .trim() ==
                                            "") {
                                          await showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return CommonConfirmationDialogBox(
                                                buttonTitle:
                                                    helper.translateTextTitle(
                                                        titleText: "Okay"),
                                                title:
                                                    helper.translateTextTitle(
                                                        titleText: "Alert"),
                                                subTitle:
                                                    "Question is Mandatory Please Select Answer!",
                                                onPressButton: () async {
                                                  backToScreen(
                                                      context: context);
                                                },
                                              );
                                            },
                                          );
                                          return;
                                        }
                                      }
                                    }

                                    if (currentIndex <
                                        (qrCodeProvider.candidateQuizDetail!
                                                .questions!.length -
                                            1)) {
                                      setState(() {
                                        currentIndex++;

                                        if (qrCodeProvider
                                                .candidateQuizDetail!
                                                .questions![currentIndex]
                                                .questionType ==
                                            "subjective") {
                                          timerCount = timeForEachQuestion;
                                        } else {
                                          timerCount = null;
                                          timer!.cancel();
                                          stopVideoRecordingForCandidate();
                                        }
                                      });
                                    } else {
                                      showOverlayLoader(context);
                                      if (recordedFile != null) {
                                        await qrCodeProvider
                                            .uploadCandidateVideoResumeFunction(
                                                context: context,
                                                fieName:
                                                    "${recordedFile!.name}.webm",
                                                fileByteData:
                                                    await recordedFile!
                                                        .readAsBytes());
                                        if (qrCodeProvider.uploadedFileData !=
                                            null) {
                                          int i = 0;
                                          for (var element
                                              in questionsWithAnswerList) {
                                            if (element["questionType"] ==
                                                "subjective") {
                                              questionsWithAnswerList[i]
                                                      ["videoResumeFileName"] =
                                                  qrCodeProvider
                                                          .uploadedFileData[
                                                      "fileName"];
                                            }
                                            i++;
                                          }
                                        }
                                      }
                                      if (await qrCodeProvider
                                          .saveCandidateQuizDetailApiFunction(
                                              dataParameter: {
                                            "requisitionId":
                                                qrCodeProvider.qrRequisitionId,
                                            "quizId": qrCodeProvider
                                                .candidateQuizDetail!
                                                .configuration!
                                                .quizId
                                                .toString(),
                                            "quizDetails":
                                                questionsWithAnswerList
                                          },
                                              context: context)) {
                                        hideOverlayLoader();

                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          qrCodeProvider.updateQrCodeScreenIndex(
                                              context: context,
                                              tabIndex: qrCodeProvider
                                                      .qrCodeSelectedTabIndex +
                                                  1);
                                        });
                                      } else {
                                        hideOverlayLoader();
                                      }
                                    }
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Future<void> setCameraForVideoRecording() async {
    final helper = Provider.of<GeneralHelper>(context, listen: false);
    showOverlayLoader(context);
    try {
      _cameras = await availableCameras();
      var selectedCamera;

      if (_cameras.isNotEmpty) {
        // final front = _cameras.firstWhere(
        //     (camera) => camera.lensDirection == CameraLensDirection.front);
        if (checkPlatForm(
            context: context,
            platforms: [CustomPlatForm.MOBILE, CustomPlatForm.TABLET])) {
          selectedCamera = _cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front);
        } else {
          selectedCamera = _cameras.first;
        }

        cameraController = CameraController(
            selectedCamera, ResolutionPreset.low,
            enableAudio: true);

        cameraController!.initialize().then((_) {
          startVideoRecordingForCandidate();
          setTimerForQuestion();
          if (!mounted) {
            return;
          }
        }).catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                // Handle access errors here.
                break;
              default:
                // Handle other errors here.
                break;
            }
          }
        });
      }
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'cameraNotFound':
            // Handle access errors here.
            hideOverlayLoader();
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return CommonConfirmationDialogBox(
                  buttonTitle: helper.translateTextTitle(titleText: "Okay"),
                  title: helper.translateTextTitle(titleText: "Alert"),
                  subTitle: helper.translateTextTitle(
                      titleText: "Camera Device Not Found"),
                  onPressButton: () async {
                    backToScreen(context: context);
                  },
                );
              },
            );
            break;
          case 'CameraAccessDenied':
            // Handle access errors here.
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return CommonConfirmationDialogBox(
                  buttonTitle: helper.translateTextTitle(titleText: "Okay"),
                  title: helper.translateTextTitle(titleText: "Alert"),
                  subTitle: helper.translateTextTitle(
                      titleText:
                          "Previous action for video interview questions is not allowed."),
                  onPressButton: () async {
                    backToScreen(context: context);
                  },
                );
              },
            );
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    }

    hideOverlayLoader();
  }

  Future<void> startVideoRecordingForCandidate() async {
    if (cameraController != null) {
      isRecording = true;
      await cameraController!.prepareForVideoRecording();
      await cameraController!.startVideoRecording();
    }
  }

  void setTimerForQuestion() {
    final helper = Provider.of<GeneralHelper>(context, listen: false);
    final authProvider = Provider.of<QRCodeProvider>(context, listen: false);
    timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => setState(() {
              if (timerCount != null) {
                if (timerCount == 0) {
                  timerCount = null;
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return CommonConfirmationDialogBox(
                        buttonTitle:
                            helper.translateTextTitle(titleText: "Okay"),
                        title: helper.translateTextTitle(titleText: "Alert"),
                        subTitle: helper.translateTextTitle(
                            titleText: "Video recording timeout."),
                        onPressButton: () {
                          backToScreen(context: context);
                        },
                      );
                    },
                  ).whenComplete(() {
                    if (currentIndex <
                        (authProvider.candidateQuizDetail!.questions!.length -
                            1)) {
                      currentIndex++;
                      if (authProvider.candidateQuizDetail!
                              .questions![currentIndex].questionType ==
                          "subjective") {
                        timerCount = timeForEachQuestion;
                      } else {
                        timer.cancel();
                        stopVideoRecordingForCandidate();
                      }
                    }
                  });
                } else {
                  timerCount = timerCount! - 1;
                }
              } else {}
            }));
  }

  void stopVideoRecordingForCandidate() async {
    if (isRecording) {
      isRecording = false;
      recordedFile = await cameraController!.stopVideoRecording();

      setState(() {
        cameraController!.dispose();
        cameraController = null;
      });

      if (recordedFile != null) {}
    }
  }
}

class QuestionOptionWidget extends StatelessWidget {
  const QuestionOptionWidget({
    super.key,
    required this.onTapOption,
    required this.optionText,
    required this.isOptionSelected,
  });

  final dynamic onTapOption;
  final String optionText;
  final bool isOptionSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapOption,
      child: Container(
        width: SizeConfig.screenWidth,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: isOptionSelected
              ? PickColors.successColor
              : PickColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isOptionSelected
                  ? PickColors.successColor
                  : PickColors.hintColor,
              width: 1),
        ),
        child: Text(
          optionText,
          style: CommonTextStyle().textFieldLabelTextStyle.copyWith(
                color: isOptionSelected
                    ? PickColors.whiteColor
                    : PickColors.blackColor,
                fontWeight: FontWeight.normal,
              ),
        ),
      ),
    );
  }
}
