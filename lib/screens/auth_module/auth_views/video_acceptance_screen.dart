// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/check_file_size.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/set_time_duration.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_view/job_description_screen.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_compress/video_compress.dart';

import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class VideoAcceptanceScreen extends StatefulWidget {
  final String remarkString;
  const VideoAcceptanceScreen({super.key, required this.remarkString});

  @override
  State<VideoAcceptanceScreen> createState() => _VideoAcceptanceScreenState();
}

class _VideoAcceptanceScreenState extends State<VideoAcceptanceScreen>
    with WidgetsBindingObserver {
  late List<CameraDescription> _cameras;

  CameraController? cameraController;
  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;

  bool isVideoAcceptanceStarted = false;

  XFile? recordedFile;
  XFile? capturedImageFile;

  int currentIndex = 0;
  Timer? timer;
  Timer? progressTimer;
  int? progressTimerCount = 0;
  // Timer? videoDurationTimer;
  int videoDurationTime = 0;

  int? timerCount = 0;

  bool isFullScreen = false;

  bool isLoading = false;
  bool isRecording = false;

  // double before = 0;
  // double after = 0;

  // Duration? videoLength;
  // Duration? videoPosition;
  double volume = 0.5;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    chewieController?.dispose();
    videoPlayerController?.dispose();
    cameraController?.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      timer?.cancel();
      chewieController?.dispose();
      videoPlayerController?.dispose();
      cameraController?.dispose();
    }
  }

  Future<void> setCameraForVideoRecording() async {
    final helper = Provider.of<GeneralHelper>(context, listen: false);

    // chewieController?.dispose();
    videoPlayerController?.pause();

    showOverlayLoader(context);
    try {
      _cameras = await availableCameras();

      var selectedCamera;

      if (_cameras.isNotEmpty) {
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
          if (!mounted) {
            return;
          }
          startVideoRecordingForCandidate();
          setTimerForQuestion();
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
                      titleText: "Please Give The Audio Video Permission"),
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (cameraController != null) {
      isRecording = true;
      await cameraController!.prepareForVideoRecording();
      await cameraController!.startVideoRecording();

      videoDurationTime = 0;
    }
  }

  void stopVideoRecordingForCandidate() async {
    if (isRecording) {
      isRecording = false;
      setState(() {
        recordedFile = null;
      });
      showOverlayLoader(context);

      try {
        recordedFile = await cameraController!.stopVideoRecording();

        // before = getFileSizeInMB(
        //     mbSize: 0, sizeInBytes: await recordedFile!.readAsBytes());

        if (checkPlatForm(context: context, platforms: [
          CustomPlatForm.MOBILE,
          CustomPlatForm.TABLET,
          CustomPlatForm.MIN_MOBILE
        ])) {
          MediaInfo? info = await VideoCompress.compressVideo(
            recordedFile!.path,
            quality: VideoQuality.MediumQuality,
            deleteOrigin: false,
            includeAudio: true,
          );
          if (info != null) {
            recordedFile = XFile(info.file!.path);
          }

          // after = getFileSizeInMB(
          //     mbSize: 0, sizeInBytes: await recordedFile!.readAsBytes());
        }
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.applicantInformation!.isCompareFace ?? false) {
          capturedImageFile = await cameraController!.takePicture();
        }

        print(
            "==============After Compress==My File Size........${getFileSizeInMB(mbSize: 0, sizeInBytes: await recordedFile!.readAsBytes())}");

        // videoDurationTimer?.cancel();

        printDebug(
            textString:
                "============Recorded File Path...======${recordedFile?.path}");

        if (recordedFile != null) {
          if (checkPlatForm(context: context, platforms: [
            CustomPlatForm.MIN_MOBILE,
            CustomPlatForm.MOBILE,
            CustomPlatForm.TABLET
          ])) {
            videoPlayerController =
                VideoPlayerController.file(File(recordedFile!.path));
          } else {
            videoPlayerController =
                VideoPlayerController.networkUrl(Uri.parse(recordedFile!.path));
          }

          await videoPlayerController!.initialize();

          chewieController = ChewieController(
              videoPlayerController: videoPlayerController!,
              autoPlay: true,
              looping: false,
              showControls: false,
              showOptions: false,
              allowFullScreen: true);
          videoPlayerController?.addListener(() {
            setState(() {
              progressTimerCount =
                  videoPlayerController!.value.position.inSeconds;
            });
          });

          cameraController?.dispose();
          cameraController = null;
          handleProgressTimer(currentPosition: 0);
        }
      } catch (e) {
        hideOverlayLoader();
      } finally {
        hideOverlayLoader();
      }
    }
  }

  Future<void> restartVideoAfterClose() async {
    print("=========Recorded file  path...${recordedFile!.path}");
    if (recordedFile != null) {
      if (checkPlatForm(context: context, platforms: [
        CustomPlatForm.MIN_MOBILE,
        CustomPlatForm.MOBILE,
        CustomPlatForm.TABLET
      ])) {
        videoPlayerController =
            VideoPlayerController.file(File(recordedFile!.path));
      } else {
        videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(recordedFile!.path));
      }

      await videoPlayerController!.initialize();

      chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          autoPlay: true,
          looping: false,
          showControls: false,
          showOptions: false,
          allowFullScreen: true);

      videoPlayerController!.addListener(() {
        setState(() {
          progressTimerCount = videoPlayerController!.value.position.inSeconds;
        });
      });
      handleProgressTimer(currentPosition: progressTimerCount ?? 0);
    }
  }

  void handleProgressTimer({required int currentPosition}) {
    setState(() {
      progressTimerCount = currentPosition;
    });
    videoPlayerController!.seekTo(Duration(seconds: progressTimerCount ?? 0));
  }

  void setTimerForQuestion() {
    final helper = Provider.of<GeneralHelper>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timerTime) => setState(() {
              if (timerCount != null) {
                if (timerCount == 0) {
                  timerCount = null;
                  cameraController!.pauseVideoRecording();

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
                    cameraController!.resumeVideoRecording();
                    if (currentIndex <
                        (authProvider.acceptanceDetailsData!.questions!.length -
                            1)) {
                      currentIndex++;
                      timerCount = authProvider.acceptanceDetailsData!
                              .questions![currentIndex].questionTimer ??
                          0;
                    } else {
                      if (timer != null) {
                        timer!.cancel();
                      }

                      stopVideoRecordingForCandidate();
                    }
                  });
                } else {
                  timerCount = timerCount! - 1;
                  videoDurationTime++;
                }
              } else {}
            }));
  }

  @override
  Widget build(BuildContext context) {
    if (!context.router.currentUrl.contains("dashboard")) {
      timer?.cancel();
      chewieController?.dispose();
      videoPlayerController?.dispose();
      cameraController?.dispose();
    }
    return Consumer2(builder: (BuildContext context, AuthProvider authProvider,
        GeneralHelper helper, snapshot) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PickHeightAndWidth.height30,
          Row(
            children: [
              Expanded(
                child: Text(
                  helper.translateTextTitle(titleText: "Video Acceptance") ??
                      "-",
                  style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                        color: PickColors.blackColor,
                        fontSize: 17,
                      ),
                ),
              ),
              if (isVideoAcceptanceStarted && (timerCount ?? 0) != 0)
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
          //chewieController == null
          if (!isVideoAcceptanceStarted)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PickHeightAndWidth.height30,
                Text(
                  helper.translateTextTitle(titleText: "Instructions") ?? "-",
                  style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                        color: PickColors.blackColor,
                        fontSize: 17,
                      ),
                ),
                HtmlWidget(
                  authProvider
                          .acceptanceDetailsData!.instructions!.instructions ??
                      "",
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 350),
                    width: SizeConfig.screenWidth! * 0.20,
                    child: CommonMaterialButton(
                        title:
                            helper.translateTextTitle(titleText: "Continue") ??
                                "_",
                        onPressed: () async {
                          if ((authProvider.acceptanceDetailsData!.questions ??
                                  [])
                              .isNotEmpty) {
                            timerCount = authProvider.acceptanceDetailsData!
                                    .questions![0].questionTimer ??
                                0;

                            await setCameraForVideoRecording();

                            isVideoAcceptanceStarted = true;
                          }
                        }),
                  ),
                ),
              ],
            ),
          PickHeightAndWidth.height30,
          if (isVideoAcceptanceStarted && recordedFile == null)
            Center(
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: PickColors.whiteColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${currentIndex + 1} . ${authProvider.acceptanceDetailsData!.questions![currentIndex].question ?? "-"}",
                      style: CommonTextStyle().textFieldLabelTextStyle,
                    ),
                    if ((authProvider.acceptanceDetailsData!
                                    .questions![currentIndex].number ??
                                "")
                            .trim() !=
                        "")
                      PickHeightAndWidth.height20,
                    if ((authProvider.acceptanceDetailsData!
                                    .questions![currentIndex].number ??
                                "")
                            .trim() !=
                        "")
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: authProvider.acceptanceDetailsData!
                              .questions![currentIndex].number!
                              .split("-")
                              .map((e) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              decoration: BoxDecoration(
                                color: PickColors.bgColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  e.toString(),
                                  style:
                                      CommonTextStyle().textFieldLabelTextStyle,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    PickHeightAndWidth.height20,
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: cameraController != null
                          ? CameraPreview(
                              cameraController!,
                            )
                          : Container(),
                    ),

                    // if (capturedImageFile != null)
                    //   Image.network(capturedImageFile!.path),
                    PickHeightAndWidth.height20,
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 350),
                        width: SizeConfig.screenWidth! * 0.20,
                        child: CommonMaterialButton(
                            title: currentIndex ==
                                    (authProvider.acceptanceDetailsData!
                                            .questions!.length -
                                        1)
                                ? helper.translateTextTitle(titleText: "Finish")
                                : helper.translateTextTitle(
                                        titleText: "Next") ??
                                    "-",
                            onPressed: () {
                              videoDurationTime = videoDurationTime - 1;
                              if (currentIndex <
                                  (authProvider.acceptanceDetailsData!
                                          .questions!.length -
                                      1)) {
                                if (timerCount! <
                                    (authProvider
                                                .acceptanceDetailsData!
                                                .questions![currentIndex]
                                                .questionTimer ??
                                            0) -
                                        5) {
                                  setState(() {
                                    currentIndex++;
                                    timerCount = authProvider
                                            .acceptanceDetailsData!
                                            .questions![currentIndex]
                                            .questionTimer ??
                                        0;
                                  });
                                }
                              } else {
                                timerCount = null;
                                if (timer != null) {
                                  timer!.cancel();
                                }
                                stopVideoRecordingForCandidate();
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (isVideoAcceptanceStarted && recordedFile != null)
            chewieController != null
                ? Column(
                    children: [
                      Column(children: [
                        Column(
                          children: [
                            chewieController != null &&
                                    videoPlayerController!.value.isInitialized
                                ? Container(
                                    height: 330,
                                    width: 600,
                                    child: Chewie(
                                      controller: chewieController!,
                                    ),
                                  )
                                : Container(),
                            if (chewieController != null &&
                                videoPlayerController!.value.isInitialized)
                              VideoControllerWidget(
                                currentSliderPosition:
                                    (progressTimerCount ?? 0).toDouble(),
                                isFullScreen: isFullScreen,
                                onChangeFullScreen: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) => Scaffold(
                                            body: FullScreenVideoWidget(
                                              chewieController:
                                                  chewieController!,
                                              currentSliderPosition:
                                                  (progressTimerCount ?? 0)
                                                      .toDouble(),
                                              isFullScreen: true,
                                              onChangeFullScreen: () {
                                                backToScreen(context: context);
                                              },
                                              onChangeSoundButton: () {
                                                setState(() {
                                                  if (videoPlayerController!
                                                          .value.volume ==
                                                      0.0) {
                                                    videoPlayerController!
                                                        .setVolume(1.0);
                                                  } else {
                                                    videoPlayerController!
                                                        .setVolume(0.0);
                                                  }
                                                });
                                              },
                                              onChangePlayButton: () =>
                                                  setState(
                                                () {
                                                  videoPlayerController!
                                                          .value.isPlaying
                                                      ? videoPlayerController!
                                                          .pause()
                                                      : videoPlayerController!
                                                          .play();
                                                },
                                              ),
                                              onChangeSliderPosition: (value) {
                                                handleProgressTimer(
                                                    currentPosition:
                                                        value.toInt());
                                              },
                                              videoDuration:
                                                  videoDurationTime.toDouble(),
                                              videoPlayerController:
                                                  videoPlayerController!,
                                            ),
                                          )).whenComplete(() {
                                    setState(() {
                                      isFullScreen = false;
                                    });
                                    restartVideoAfterClose();
                                  });
                                },
                                onChangeSliderPosition: (value) {
                                  handleProgressTimer(
                                      currentPosition: value.toInt());
                                },
                                onChangeSoundButton: () {
                                  setState(() {
                                    if (videoPlayerController!.value.volume ==
                                        0.0) {
                                      videoPlayerController!.setVolume(1.0);
                                    } else {
                                      videoPlayerController!.setVolume(0.0);
                                    }
                                  });
                                },
                                onChangePlayButton: () => setState(
                                  () {
                                    videoPlayerController!.value.isPlaying
                                        ? videoPlayerController!.pause()
                                        : videoPlayerController!.play();
                                  },
                                ),
                                videoDuration: videoDurationTime.toDouble(),
                                videoPlayerController: videoPlayerController!,
                              ),
                            // if (capturedImageFile != null)
                            //   Image.file(File(capturedImageFile!.path))
                          ],
                        ),
                      ]),
                      PickHeightAndWidth.height10,
                      Row(
                        children: [
                          Expanded(
                            child: CommonMaterialButton(
                              style: CommonTextStyle().buttonTextStyle.copyWith(
                                    color: PickColors.primaryColor,
                                  ),
                              borderColor: PickColors.primaryColor,
                              color: PickColors.whiteColor,
                              title: helper.translateTextTitle(
                                      titleText: "Retake") ??
                                  "-",
                              onPressed: () async {
                                timerCount = authProvider.acceptanceDetailsData!
                                        .questions![0].questionTimer ??
                                    0;
                                isRecording = false;
                                currentIndex = 0;
                                recordedFile = null;
                                capturedImageFile = null;

                                await setCameraForVideoRecording();
                              },
                            ),
                          ),
                          PickHeightAndWidth.width15,
                          Expanded(
                            child: CommonMaterialButton(
                              title: helper.translateTextTitle(
                                      titleText: "Submit") ??
                                  "-",
                              onPressed: () async {
                                await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return CommonConfirmationDialogBox(
                                      cancelButtonTitle: helper
                                          .translateTextTitle(titleText: "No"),
                                      buttonTitle: helper.translateTextTitle(
                                          titleText: "Yes"),
                                      title: helper.translateTextTitle(
                                          titleText: "Confirmation"),
                                      isCancel: true,
                                      subTitle: helper.translateTextTitle(
                                          titleText:
                                              "This action will upload the video and submit the application hence you will not be able to retake the video are you sure you want to submit ?"),
                                      onPressButton: () async {
                                        chewieController?.dispose();
                                        videoPlayerController?.dispose();
                                        bool isAllowSubmit = true;
                                        showOverlayLoader(context);
                                        if ((authProvider.applicantInformation!
                                                    .isCompareFace ??
                                                false) &&
                                            (authProvider.applicantInformation!
                                                            .applicantPhoto ??
                                                        "")
                                                    .toString()
                                                    .trim() !=
                                                "") {
                                          if (await authProvider
                                              .getCandidateProfilePicApiFunction(
                                                  context: context)) {
                                            if (authProvider.profilePicData !=
                                                null) {
                                              authProvider.applicantInformation!
                                                      .applicantPhoto =
                                                  authProvider.profilePicData[
                                                      "candidatePhotoUrl"];
                                            }
                                          }
                                          final response = await http.get(
                                              Uri.parse(authProvider
                                                      .applicantInformation!
                                                      .applicantPhoto ??
                                                  ""));

                                          isAllowSubmit = false;

                                          if (await authProvider
                                              .compareFaceApiFunction(
                                            context: context,
                                            fieName1: authProvider
                                                .applicantInformation!
                                                .applicantPhoto
                                                .toString()
                                                .split("?")
                                                .first
                                                .split("/")
                                                .last,
                                            fieName2: "captured_image" +
                                                DateTime.now()
                                                    .microsecondsSinceEpoch
                                                    .toString() +
                                                ".${authProvider.applicantInformation!.applicantPhoto.toString().split("?").first.split("/").last.split(".").last}",
                                            fileByteData1: response.bodyBytes,
                                            fileByteData2:
                                                await capturedImageFile!
                                                    .readAsBytes(),
                                          )) {
                                            hideOverlayLoader();
                                            isAllowSubmit = true;
                                          } else {
                                            isAllowSubmit = false;
                                            hideOverlayLoader();
                                            await showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return CommonConfirmationDialogBox(
                                                  buttonTitle:
                                                      helper.translateTextTitle(
                                                          titleText: "Retry"),
                                                  title:
                                                      helper.translateTextTitle(
                                                          titleText: "Alert"),
                                                  subTitle: "Invalid Face",
                                                  onPressButton: () async {
                                                    backToScreen(
                                                        context: context);
                                                    backToScreen(
                                                        context: context);
                                                    timerCount = authProvider
                                                            .acceptanceDetailsData!
                                                            .questions![0]
                                                            .questionTimer ??
                                                        0;
                                                    isRecording = false;
                                                    currentIndex = 0;
                                                    recordedFile = null;
                                                    capturedImageFile = null;

                                                    await setCameraForVideoRecording();
                                                  },
                                                );
                                              },
                                            );
                                          }
                                        }

                                        if (isAllowSubmit) {
                                          if (recordedFile != null) {
                                            showOverlayLoader(context);
                                            if (await authProvider
                                                .submitVideoDetailApiService(
                                                    context: context,
                                                    type: authProvider
                                                                .candidateCurrentStage ==
                                                            CandidateStages
                                                                .OFFER_ACCEPTANCE
                                                        ? "OfferLetter"
                                                        : "AppointmentLetter",
                                                    fieName:
                                                        "${recordedFile!.name}.webm",
                                                    fileByteData:
                                                        await recordedFile!
                                                            .readAsBytes())) {
                                              if (await authProvider
                                                  .saveCandidateOfferDetailApiFunction(
                                                      helper: helper,
                                                      dataParameter: {
                                                        "rejectReasonId": 0,
                                                        "remark":
                                                            widget.remarkString,
                                                        "isDiscuss": false,
                                                        "isReject": false,
                                                        "uploadedDocument": ""
                                                      },
                                                      context: context)) {
                                                final helper =
                                                    Provider.of<GeneralHelper>(
                                                        context,
                                                        listen: false);
                                                await authProvider
                                                    .getApplicantInformationApiFunction(
                                                        context: context,
                                                        authToken: authProvider
                                                                .currentUserAuthInfo!
                                                                .authToken ??
                                                            "",
                                                        timestamp: DateTime
                                                                .now()
                                                            .toUtc()
                                                            .millisecondsSinceEpoch
                                                            .toString(),
                                                        helper: helper)
                                                    .then((value) {
                                                  hideOverlayLoader();
                                                });
                                                // if (chewieController != null) {
                                                //   chewieController?.dispose();
                                                //   videoPlayerController?.dispose();
                                                // }
                                              } else {
                                                hideOverlayLoader();
                                              }
                                            } else {
                                              hideOverlayLoader();
                                            }

                                            backToScreen(context: context);
                                          }
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                : Center(
                    child: SpinKitPulsingGrid(
                      color: PickColors.primaryColor,
                    ),
                  )
        ],
      );
    });
  }
}

IconData animatedVolumeIcon(bool isVolumeOFF) {
  if (isVolumeOFF) {
    return Icons.volume_off;
  } else {
    return Icons.volume_up;
  }
}

Future<void> downloadImage(
    List<int> myfile, String fileName, BuildContext context) async {
  if (checkPlatForm(context: context, platforms: [
    CustomPlatForm.MIN_MOBILE,
    CustomPlatForm.MOBILE,
    CustomPlatForm.TABLET
  ])) {
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/$fileName';

    File file = File(filePath);
    await file.writeAsBytes(await myfile);
    print("========My File Path....${filePath}");
    OpenFilex.open(filePath);

    // Display a message or navigate to a new screen on successful download
    // For example, you can show a SnackBar
  } else {
    // final blob = html.Blob([myfile]); // Convert to Blob
    // final url = html.Url.createObjectUrlFromBlob(blob);

    // final anchor = html.AnchorElement(href: url)
    //   ..target = '_blank'
    //   ..download =
    //       'captured_image_${DateTime.now().microsecond.toString()}.jpeg' // Set desired file name
    //   ..click();

    // html.Url.revokeObjectUrl(url);
    // printDebug(textString: "=================${url}");
  }
}
