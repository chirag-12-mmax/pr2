// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';

import 'package:onboarding_app/constants/api_info/api_routes.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/set_time_duration.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_views/video_acceptance_screen.dart';
import 'package:onboarding_app/screens/candidate_module/offer_detail/offer_detail_commons/offer_detail_data_widget.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_commons/job_description_details_widget.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_provider/qr_code_provider.dart';
import 'package:onboarding_app/widgets/build_logo_profile.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webviewx_plus/webviewx_plus.dart';

// import 'package:flutter/foundation.dart' show kIsWeb;

// import 'dart:html' as html;
// import 'dart:js' as js;
// import 'dart:ui' as ui;

@RoutePage()
class JobDescriptionScreen extends StatefulWidget {
  const JobDescriptionScreen(
      {super.key,
      @PathParam('subscriptionId') required this.subscriptionId,
      @PathParam('reqId') required this.requisitionId,
      @PathParam('resumeSource') required this.resumeSource});
  final String subscriptionId;
  final String requisitionId;
  final String resumeSource;

  @override
  State<JobDescriptionScreen> createState() => _JobDescriptionScreenState();
}

class _JobDescriptionScreenState extends State<JobDescriptionScreen> {
  bool isLoading = false;
  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;
  // YoutubePlayerController? youtubePlayerController;
  bool isYoutubeVideo = false;

  bool isFullScreen = false;
  // int? progressTimerCount = 0;
  // int videoDurationTime = 0;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  initializeData() async {
    setState(() {
      isLoading = true;
    });
    isYoutubeVideo = false;
    final qrCodeProvider = Provider.of<QRCodeProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    qrCodeProvider.qrCodeSubscription = context.router.currentPath
        .split("/")[context.router.currentPath.split("/").length - 3];

    await authProvider.setServerConfigurationURLFunction(
        subscription: qrCodeProvider.qrCodeSubscription ?? "",
        context: context);

    qrCodeProvider.qrRequisitionId = context.router.currentPath
        .split("/")[context.router.currentPath.split("/").length - 2];
    qrCodeProvider.qrCodeResumeSource = context.router.currentPath
        .split("/")[context.router.currentPath.split("/").length - 1];

    await qrCodeProvider.getJobDescriptionDetailByRequisitionApiFunction(
        context: context,
        dataParameter: {
          "subscriptionName": qrCodeProvider.qrCodeSubscription,
          "requisitionId": qrCodeProvider.qrRequisitionId,
          "type": "qrcoderequisition",
          "employeeCode": "",
          "_": DateTime.now().millisecondsSinceEpoch.toString(),
        });

    if (qrCodeProvider.jobDescriptionData != null) {
      // qrCodeProvider.jobDescriptionData!.jdVideo =
      //     "https://www.youtube.com/embed/tgbNymZ7vqY";

      if ((qrCodeProvider.jobDescriptionData!.jdVideo ?? "").toString() != "") {
        if (qrCodeProvider.jobDescriptionData!.jdVideo
                .toString()
                .contains("youtube") ||
            qrCodeProvider.jobDescriptionData!.jdVideo
                .toString()
                .contains("youtu.be")) {
          chewieController = null;
          videoPlayerController = null;
          isYoutubeVideo = true;

          // youtubePlayerController = YoutubePlayerController.fromVideoId(
          //   videoId: YoutubePlayerController.convertUrlToId(
          //           qrCodeProvider.jobDescriptionData!.jdVideo.toString()) ??
          //       "",
          //   params: const YoutubePlayerParams(
          //     mute: false,
          //     showControls: true,
          //     showFullscreenButton: true,
          //   ),
          // );
          // youtubePlayerController!.setFullScreenListener(
          //   (isFullScreenGet) {
          //     setState(() {
          //       isFullScreen = isFullScreenGet;
          //     });
          //   },
          // );
        } else {
          // youtubePlayerController = null;
          isYoutubeVideo = false;
          videoPlayerController = VideoPlayerController.networkUrl(
              Uri.parse(qrCodeProvider.jobDescriptionData!.jdVideo));

          if (videoPlayerController != null) {
            chewieController = ChewieController(
                autoPlay: true,
                looping: true,
                autoInitialize: true,
                allowPlaybackSpeedChanging: false,
                allowFullScreen: false,
                showOptions: false,
                showControls: false,
                useRootNavigator: false,
                // aspectRatio: videoPlayerController!.value.aspectRatio,
                errorBuilder: (context, errorMessage) {
                  return Center(
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                },
                videoPlayerController: videoPlayerController!);
          }

          videoPlayerController!.addListener(() {
            setState(() {});
          });

          await videoPlayerController!
              .initialize()
              .onError((error, stackTrace) {});
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    chewieController?.dispose();
    videoPlayerController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Consumer2(builder: (BuildContext context,
        QRCodeProvider qrCodeProvider, GeneralHelper helper, snapshot) {
      return Scaffold(
        backgroundColor:
            isFullScreen ? PickColors.blackColor : PickColors.bgColor,
        appBar: isFullScreen
            ? null
            : AppBar(
                elevation: 0,
                backgroundColor: PickColors.whiteColor,
                automaticallyImplyLeading: false,
                leading: InkWell(
                  onTap: () {
                    replaceNextScreenWithRoute(
                        context: context, routePath: AppRoutesPath.LOGIN);
                  },
                  child:
                      Icon(Icons.arrow_back_ios, color: PickColors.blackColor),
                ),
                title: Text(
                    helper.translateTextTitle(titleText: "Job Description") ??
                        "-",
                    style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                          fontSize: 24,
                        )),
              ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : qrCodeProvider.jobDescriptionData != null
                ? isFullScreen
                    ? videoPlayerController != null
                        ? FullScreenVideoWidget(
                            chewieController: chewieController!,
                            currentSliderPosition: videoPlayerController!
                                .value.position.inSeconds
                                .toDouble(),
                            videoPlayerController: videoPlayerController!,
                            isFullScreen: isFullScreen,
                            videoDuration: videoPlayerController!
                                .value.duration.inSeconds
                                .toDouble(),
                            onChangeFullScreen: () {
                              setState(() {
                                isFullScreen = !isFullScreen;
                              });
                            },
                            onChangePlayButton: () {
                              setState(() {
                                videoPlayerController!.value.isPlaying
                                    ? videoPlayerController!.pause()
                                    : videoPlayerController!.play();
                              });
                            },
                            onChangeSliderPosition: (position) {
                              videoPlayerController!.seekTo(
                                  Duration(seconds: (position).toInt()));
                              setState(() {});
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
                          )
                        : Container()
                    //  YoutubePlayerScaffold(
                    //     controller: youtubePlayerController!,
                    //     autoFullScreen: false,
                    //     enableFullScreenOnVerticalDrag: false,
                    //     aspectRatio: 16 / 9,
                    //     builder: (context, player) {
                    //       return player;
                    //     },
                    //   )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              qrCodeProvider.jobDescriptionData!.isJdImage ==
                                      true
                                  ? Container(
                                      height:
                                          (MediaQuery.of(context).size.height *
                                              (checkPlatForm(
                                                      context: context,
                                                      platforms: [
                                                    CustomPlatForm.WEB
                                                  ])
                                                  ? 0.40
                                                  : 0.20)),
                                      // width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            fit: checkPlatForm(
                                                    context: context,
                                                    platforms: [
                                                  CustomPlatForm.WEB
                                                ])
                                                ? BoxFit.fitHeight
                                                : BoxFit.fill,
                                            image: NetworkImage((qrCodeProvider
                                                        .jobDescriptionData!
                                                        .jdImage ??
                                                    "-")
                                                .trim()) as ImageProvider),
                                      ))

                                  // BuildLogoProfileImageWidget(
                                  //     imagePath:
                                  //         "https://zinghruat.blob.core.windows.net/qadbrec/Image/Logo/logo.jpg?sv=2018-03-28&sr=c&sig=8eyBwgJFnO7uopfnQgqo%2Fm1c0nL82cyJNKIKDkBMvec%3D&se=2023-12-07T11%3A41%3A28Z&sp=r",
                                  //     titleName: "",
                                  //     height: 400,
                                  //   )
                                  : (chewieController != null || isYoutubeVideo
                                      // youtubePlayerController != null
                                      )
                                      ? chewieController != null
                                          ? Column(
                                              children: [
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      (checkPlatForm(
                                                              context: context,
                                                              platforms: [
                                                            CustomPlatForm.WEB,
                                                            CustomPlatForm
                                                                .MIN_LAPTOP_VIEW,
                                                            CustomPlatForm
                                                                .LARGE_LAPTOP_VIEW
                                                          ])
                                                          ? 0.40
                                                          : 0.20),
                                                  child: Chewie(
                                                    controller:
                                                        chewieController!,
                                                  ),
                                                ),
                                                VideoControllerWidget(
                                                  currentSliderPosition:
                                                      videoPlayerController!
                                                          .value
                                                          .position
                                                          .inSeconds
                                                          .toDouble(),
                                                  videoPlayerController:
                                                      videoPlayerController!,
                                                  isFullScreen: isFullScreen,
                                                  videoDuration:
                                                      videoPlayerController!
                                                          .value
                                                          .duration
                                                          .inSeconds
                                                          .toDouble(),
                                                  onChangeFullScreen: () {
                                                    setState(() {
                                                      isFullScreen =
                                                          !isFullScreen;
                                                    });
                                                  },
                                                  onChangePlayButton: () {
                                                    setState(() {
                                                      videoPlayerController!
                                                              .value.isPlaying
                                                          ? videoPlayerController!
                                                              .pause()
                                                          : videoPlayerController!
                                                              .play();
                                                    });
                                                  },
                                                  onChangeSliderPosition:
                                                      (position) {
                                                    setState(() {
                                                      videoPlayerController!
                                                          .seekTo(Duration(
                                                              seconds: (position)
                                                                  .toInt()));
                                                    });
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
                                                )
                                              ],
                                            )
                                          : Center(
                                              // child: HtmlWidget(
                                              //     '<iframe src=${qrCodeProvider.jobDescriptionData!.jdVideo} frameborder="0" allowfullscreen="" ></iframe>'),

                                              child: WebViewX(
                                              height: SizeConfig.screenHeight! *
                                                  0.40,
                                              width: SizeConfig.screenWidth!,
                                              onWebViewCreated: (controller) {
                                                controller.loadContent(
                                                    qrCodeProvider
                                                        .jobDescriptionData!
                                                        .jdVideo
                                                        .toString(),
                                                    sourceType: SourceType.url);
                                              },
                                            ))
                                      : Container(),
                              // HtmlWidget(
                              //     '<iframe class="company_video_h" width="" height="" src="https://www.youtube.com/embed/fvzDGpp00BE?si=Lhau2F4W08sL6_xr?rel=0" frameborder="0" allowfullscreen="" style="width: 100%; height: 315px;"></iframe>'),

                              PickHeightAndWidth.height15,
                              OfferDetailDataWidget(
                                backgroundColor: PickColors.whiteColor,
                                mainTitle: qrCodeProvider
                                        .jobDescriptionData!.jobTitle ??
                                    "-",
                                dataList: [
                                  {
                                    "title": helper.translateTextTitle(
                                        titleText: "Location"),
                                    "titleValue": qrCodeProvider
                                            .jobDescriptionData!.location ??
                                        "-",
                                  },
                                  {
                                    "title": helper.translateTextTitle(
                                        titleText: "Department"),
                                    "titleValue": qrCodeProvider
                                            .jobDescriptionData!.department ??
                                        "-",
                                  }
                                ],
                                icon: PickImages.profileAdd,
                                isSpaceBetween: false,
                              ),
                              PickHeightAndWidth.height10,
                              if (Bidi.stripHtmlIfNeeded(qrCodeProvider
                                              .jobDescriptionData!
                                              .jobDescription ??
                                          "")
                                      .toString()
                                      .trim() !=
                                  "")
                                JobDescriptionDetailsWidget(
                                  title: helper.translateTextTitle(
                                      titleText: "Job Description"),
                                  titleValue: (qrCodeProvider
                                          .jobDescriptionData!.jobDescription ??
                                      ""),
                                ),
                              if (Bidi.stripHtmlIfNeeded(qrCodeProvider
                                              .jobDescriptionData!.krAs ??
                                          "")
                                      .toString()
                                      .trim() !=
                                  "")
                                JobDescriptionDetailsWidget(
                                  title: helper.translateTextTitle(
                                      titleText: "KRA'S / KPI'S"),
                                  titleValue: (qrCodeProvider
                                          .jobDescriptionData!.krAs ??
                                      ""),
                                ),
                              if (Bidi.stripHtmlIfNeeded(qrCodeProvider
                                              .jobDescriptionData!
                                              .rulesAndResponsibility ??
                                          "")
                                      .toString()
                                      .trim() !=
                                  "")
                                JobDescriptionDetailsWidget(
                                  title: helper.translateTextTitle(
                                      titleText: "Roles and responsibilities"),
                                  titleValue: (qrCodeProvider
                                          .jobDescriptionData!
                                          .rulesAndResponsibility ??
                                      ""),
                                ),
                              if (Bidi.stripHtmlIfNeeded(qrCodeProvider
                                              .jobDescriptionData!
                                              .skillsAndCompetencies ??
                                          "")
                                      .toString()
                                      .trim() !=
                                  "")
                                JobDescriptionDetailsWidget(
                                  title: helper.translateTextTitle(
                                      titleText: "Skills And Competencies"),
                                  titleValue: (qrCodeProvider
                                          .jobDescriptionData!
                                          .skillsAndCompetencies ??
                                      ""),
                                ),
                              PickHeightAndWidth.height20,
                              SizedBox(
                                width:
                                    checkPlatForm(context: context, platforms: [
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: CommonMaterialButton(
                                        color: Colors.transparent,
                                        borderColor: PickColors.primaryColor,
                                        title: helper.translateTextTitle(
                                                titleText: "Cancel") ??
                                            "-",
                                        style: CommonTextStyle()
                                            .buttonTextStyle
                                            .copyWith(
                                                color: PickColors.primaryColor),
                                        onPressed: () async {
                                          replaceNextScreenWithRoute(
                                              context: context,
                                              routePath: AppRoutesPath.LOGIN);
                                        },
                                      ),
                                    ),
                                    PickHeightAndWidth.width10,
                                    Expanded(
                                      child: CommonMaterialButton(
                                        title: helper.translateTextTitle(
                                            titleText: "Apply"),
                                        onPressed: () async {
                                          await showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return CommonConfirmationDialogBox(
                                                cancelButtonTitle:
                                                    helper.translateTextTitle(
                                                        titleText: "No"),
                                                buttonTitle:
                                                    helper.translateTextTitle(
                                                        titleText: "Yes"),
                                                title:
                                                    helper.translateTextTitle(
                                                        titleText:
                                                            "Confirmation"),
                                                isCancel: true,
                                                subTitle: helper.translateTextTitle(
                                                    titleText:
                                                        "Are you sure you want to apply for this job?"),
                                                onPressButton: () async {
                                                  backToScreen(
                                                      context: context);
                                                  videoPlayerController
                                                      ?.dispose();
                                                  chewieController?.dispose();

                                                  moveToNextScreenWithRoute(
                                                      context: context,
                                                      routePath: AppRoutesPath
                                                          .CANDIDATE_APPLICATION);
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                : Text(helper.translateTextTitle(
                        titleText: "Oops, no records found") ??
                    "-"),
      );
    });
  }
}

class FullScreenVideoWidget extends StatefulWidget {
  const FullScreenVideoWidget(
      {super.key,
      required this.chewieController,
      required this.currentSliderPosition,
      required this.videoPlayerController,
      required this.onChangeSliderPosition,
      required this.onChangePlayButton,
      required this.onChangeSoundButton,
      required this.isFullScreen,
      required this.onChangeFullScreen,
      required this.videoDuration});
  final ChewieController chewieController;
  final double currentSliderPosition;

  final VideoPlayerController videoPlayerController;
  final dynamic onChangeSliderPosition;
  final dynamic onChangePlayButton;
  final dynamic onChangeSoundButton;
  final bool isFullScreen;
  final dynamic onChangeFullScreen;
  final double videoDuration;

  @override
  State<FullScreenVideoWidget> createState() => _FullScreenVideoWidgetState();
}

class _FullScreenVideoWidgetState extends State<FullScreenVideoWidget> {
  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = widget.videoPlayerController;
    chewieController = widget.chewieController;
    videoPlayerController!.addListener(() {
      setState(() {});
    });
  }

  // @override
  // void dispose() {
  //   // videoPlayerController?.dispose();
  //   // chewieController?.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.screenHeight!,
        width: SizeConfig.screenWidth,
        color: PickColors.whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Expanded(
              child: Chewie(
                controller: chewieController!,
              ),
            ),
            VideoControllerWidget(
              currentSliderPosition:
                  videoPlayerController!.value.position.inSeconds.toDouble(),
              isFullScreen: widget.isFullScreen,
              videoDuration: widget.videoDuration,
              videoPlayerController: videoPlayerController!,
              onChangeFullScreen: widget.onChangeFullScreen,
              onChangePlayButton: widget.onChangePlayButton,
              onChangeSliderPosition: widget.onChangeSliderPosition,
              onChangeSoundButton: widget.onChangeSoundButton,
            )
          ],
        ));
  }
}

class VideoControllerWidget extends StatelessWidget {
  final double currentSliderPosition;

  final VideoPlayerController videoPlayerController;
  final dynamic onChangeSliderPosition;
  final dynamic onChangePlayButton;
  final dynamic onChangeSoundButton;
  final bool isFullScreen;
  final dynamic onChangeFullScreen;
  final double videoDuration;

  const VideoControllerWidget({
    super.key,
    required this.currentSliderPosition,
    required this.onChangeSliderPosition,
    required this.videoPlayerController,
    required this.onChangePlayButton,
    required this.onChangeSoundButton,
    required this.isFullScreen,
    required this.onChangeFullScreen,
    required this.videoDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Column(
        children: [
          Container(
            child: Slider(
                value: currentSliderPosition > videoDuration
                    ? 0
                    : currentSliderPosition,
                min: 0,
                max: videoDuration,
                onChanged: onChangeSliderPosition),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  videoPlayerController!.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                onPressed: onChangePlayButton,
              ),
              Expanded(
                child: Text(
                    '${formatDurationInHhMmSs(duration: videoPlayerController.value.position.inSeconds > videoDuration ? Duration(seconds: 0) : videoPlayerController.value.position)} / ${formatDurationInHhMmSs(duration: Duration(seconds: videoDuration.toInt()))}'),
              ),
              PickHeightAndWidth.width10,
              InkWell(
                onTap: onChangeSoundButton,
                child: Icon(
                  color: PickColors.primaryColor,
                  animatedVolumeIcon(videoPlayerController.value.volume == 0.0),
                ),
              ),
              IconButton(
                  icon: Icon(
                    isFullScreen
                        ? Icons.close_fullscreen_rounded
                        : Icons.fullscreen,
                    color: Colors.black,
                  ),
                  onPressed: onChangeFullScreen),
            ],
          )
        ],
      ),
    );
  }
}
