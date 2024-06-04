import 'package:auto_route/auto_route.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:onboarding_app/constants/colors.dart';

import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_providers/candidate_provider.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_view/job_description_screen.dart';

import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

// import 'package:flutter/foundation.dart' show kIsWeb;

// import 'dart:html' as html if (kIsWeb) '';
// import 'dart:js' as js if (kIsWeb) '';
// import 'dart:ui' as ui if (kIsWeb) '';

@RoutePage()
class CompanyInfoWebScreen extends StatefulWidget {
  const CompanyInfoWebScreen({super.key});

  @override
  State<CompanyInfoWebScreen> createState() => _CompanyInfoWebScreenState();
}

class _CompanyInfoWebScreenState extends State<CompanyInfoWebScreen> {
  bool isLoading = false;
  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;
  // YoutubePlayerController? youtubePlayerController;
  bool isYoutubeVideo = false;
  bool isFullScreen = false;

  @override
  void initState() {
    isYoutubeVideo = false;
    context.router.addListener(() {
      setState(() {});
    });
    initializeData();
    super.initState();
  }

  initializeData() async {
    setState(() {
      isLoading = true;
    });
    final companyInfo = Provider.of<CandidateProvider>(context, listen: false);

    await companyInfo.companyInfoApiFunction(context: context);
    try {
      // if (companyInfo.companyInfoData != null) {
      //   // companyInfo.companyInfoData!.companyVideo =
      //   //     "https://www.youtube.com/embed/2Qb4b-QGOF0?si=h4oDG2-ka8MOEzNCandquot;%20title=";
      //   companyInfo.companyInfoData!.companyVideo =
      //       "https://zinghruat.blob.core.windows.net/qadb/Documents/Recruitment/JDVideo/3mbvideofile_29_12_2023_15_11_18_884.mp4?sv=2018-03-28&sr=c&sig=CEiZvxeuvNClD%2BBKAGmoHXLN9Y2V1uSU2OQtdfHakPc%3D&se=2023-12-29T11%3A32%3A12Z&sp=r";

      //   if ((companyInfo.companyInfoData!.companyVideo ?? "")
      //           .toString()
      //           .trim() !=
      //       "") {
      //     if (companyInfo.companyInfoData!.companyVideo
      //             .toString()
      //             .contains("youtube") ||
      //         companyInfo.companyInfoData!.companyVideo
      //             .toString()
      //             .contains("youtu.be")) {
      //       videoPlayerController = null;

      //       youtubePlayerController = YoutubePlayerController.fromVideoId(
      //         videoId: YoutubePlayerController.convertUrlToId(
      //                 companyInfo.companyInfoData!.companyVideo.toString()) ??
      //             "",
      //         params: YoutubePlayerParams(
      //           mute: false,
      //           showControls: true,
      //           showFullscreenButton: true,
      //         ),
      //       );
      //       youtubePlayerController!.setFullScreenListener(
      //         (isFullScreenGet) {
      //           setState(() {
      //             isFullScreen = isFullScreenGet;
      //           });
      //         },
      //       );
      //     } else {
      //       isFromYoutube = false;
      //       youtubePlayerController = null;
      //       if (Uri.tryParse(
      //               companyInfo.companyInfoData!.companyVideo.toString()) !=
      //           null) {
      //         videoPlayerController = VideoPlayerController.networkUrl(
      //             Uri.parse(
      //                 companyInfo.companyInfoData!.companyVideo.toString()))
      //           ..initialize().then((_) {});
      //       }
      //     }
      //   }
      // }

      if (companyInfo.companyInfoData != null) {
        // companyInfo.companyInfoData!.companyVideo =
        //     "https://www.youtube.com/embed/tgbNymZ7vqY";
        // companyInfo.companyInfoData!.companyVideo =
        //     "https://zinghruat.blob.core.windows.net/qadb/Documents/Recruitment/JDVideo/3mbvideofile_29_12_2023_15_11_18_884.mp4?sv=2018-03-28&sr=c&sig=CEiZvxeuvNClD%2BBKAGmoHXLN9Y2V1uSU2OQtdfHakPc%3D&se=2023-12-29T11%3A32%3A12Z&sp=r";
        if ((companyInfo.companyInfoData!.companyVideo ?? "").toString() !=
            "") {
          if (companyInfo.companyInfoData!.companyVideo
                  .toString()
                  .contains("youtube") ||
              companyInfo.companyInfoData!.companyVideo
                  .toString()
                  .contains("youtu.be")) {
            chewieController = null;
            isYoutubeVideo = true;
            // youtubePlayerController?.close();
            videoPlayerController = null;

            // youtubePlayerController = YoutubePlayerController.fromVideoId(
            //   videoId: YoutubePlayerController.convertUrlToId(
            //           companyInfo.companyInfoData!.companyVideo.toString()) ??
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
            //     companyInfo.changeIsyoutubeFullScreen(
            //         isFullScreen: isFullScreen);
            //   },
            // );
          } else {
            print(
                "=================Hey My Video..............${companyInfo.companyInfoData!.companyVideo}");
            // youtubePlayerController = null;
            isYoutubeVideo = false;

            videoPlayerController = VideoPlayerController.networkUrl(
                Uri.parse(companyInfo.companyInfoData!.companyVideo ?? ""));

            if (videoPlayerController != null) {
              chewieController = ChewieController(
                  autoPlay: true,
                  looping: true,
                  autoInitialize: true,
                  allowPlaybackSpeedChanging: false,
                  allowFullScreen: false,
                  showOptions: false,
                  showControls: false,
                  // aspectRatio: 16 / 9,
                  useRootNavigator: false,
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
    } catch (e) {
      printDebug(textString: "===============Error: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    print("==============Dispose Call.......................");
    // TODO: implement dispose
    chewieController?.dispose();
    videoPlayerController?.dispose();
    // youtubePlayerController?.close();

    super.dispose();
  }

  Future<void> restartVideoAfterClose() async {
    final companyInfo = Provider.of<CandidateProvider>(context, listen: false);
    if (companyInfo.companyInfoData!.companyVideo != null) {
      videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(companyInfo.companyInfoData!.companyVideo!));
      await videoPlayerController!.initialize();

      chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          autoPlay: true,
          looping: false,
          showControls: false,
          showOptions: false,
          allowFullScreen: true);
      videoPlayerController!.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor:
          isFullScreen ? PickColors.blackColor : PickColors.bgColor,
      body: Consumer2(builder: (BuildContext context, AuthProvider authProvider,
          CandidateProvider companyInfo, snapshot) {
        print("=========Company.....========${context.router.currentUrl}");
        if (!context.router.currentUrl.contains("Company-Info")) {
          chewieController?.dispose();
          videoPlayerController?.dispose();
          // youtubePlayerController?.close();
        }
        return isLoading
            ? const Center(child: CircularProgressIndicator())
            : isFullScreen
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
                          setState(() {
                            videoPlayerController!
                                .seekTo(Duration(seconds: (position).toInt()));
                          });
                        },
                        onChangeSoundButton: () {
                          setState(() {
                            if (videoPlayerController!.value.volume == 0.0) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PickHeightAndWidth.height20,
                          (chewieController != null || isYoutubeVideo
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
                                                    CustomPlatForm.WEB
                                                  ])
                                                  ? 0.40
                                                  : 0.20),
                                          child: Chewie(
                                            controller: chewieController!,
                                          ),
                                        ),
                                        VideoControllerWidget(
                                          currentSliderPosition:
                                              videoPlayerController!
                                                  .value.position.inSeconds
                                                  .toDouble(),
                                          videoPlayerController:
                                              videoPlayerController!,
                                          isFullScreen: isFullScreen,
                                          videoDuration: videoPlayerController!
                                              .value.duration.inSeconds
                                              .toDouble(),
                                          onChangeFullScreen: () async {
                                            await showDialog(
                                                context: context,
                                                builder: (context) => Scaffold(
                                                      body:
                                                          FullScreenVideoWidget(
                                                        chewieController:
                                                            chewieController!,
                                                        currentSliderPosition:
                                                            videoPlayerController!
                                                                .value
                                                                .position
                                                                .inSeconds
                                                                .toDouble(),
                                                        isFullScreen: true,
                                                        onChangeFullScreen: () {
                                                          backToScreen(
                                                              context: context);
                                                        },
                                                        onChangeSoundButton:
                                                            () {
                                                          setState(() {
                                                            if (videoPlayerController!
                                                                    .value
                                                                    .volume ==
                                                                0.0) {
                                                              videoPlayerController!
                                                                  .setVolume(
                                                                      1.0);
                                                            } else {
                                                              videoPlayerController!
                                                                  .setVolume(
                                                                      0.0);
                                                            }
                                                          });
                                                        },
                                                        onChangePlayButton:
                                                            () => setState(
                                                          () {
                                                            videoPlayerController!
                                                                    .value
                                                                    .isPlaying
                                                                ? videoPlayerController!
                                                                    .pause()
                                                                : videoPlayerController!
                                                                    .play();
                                                          },
                                                        ),
                                                        onChangeSliderPosition:
                                                            (position) {
                                                          setState(() {
                                                            videoPlayerController!
                                                                .seekTo(Duration(
                                                                    seconds:
                                                                        (position)
                                                                            .toInt()));
                                                          });
                                                        },
                                                        videoDuration:
                                                            videoPlayerController!
                                                                .value
                                                                .duration
                                                                .inSeconds
                                                                .toDouble(),
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
                                          onChangeSliderPosition: (position) {
                                            setState(() {
                                              videoPlayerController!.seekTo(
                                                  Duration(
                                                      seconds:
                                                          (position).toInt()));
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
                                  : Container(
                                      child: Center(
                                        // child: HtmlWidget(
                                        //     '<iframe src=${companyInfo.companyInfoData!.companyVideo} frameborder="0" allowfullscreen="" ></iframe>'),

                                        child: WebViewX(
                                          height:
                                              SizeConfig.screenHeight! * 0.40,
                                          width: SizeConfig.screenWidth!,
                                          onWebViewCreated: (controller) {
                                            controller.loadContent(
                                                companyInfo.companyInfoData!
                                                    .companyVideo
                                                    .toString(),
                                                sourceType: SourceType.url);
                                          },
                                        ),
                                      ),
                                      // child: YoutubePlayerScaffold(
                                      //   controller: youtubePlayerController!,
                                      //   autoFullScreen: false,
                                      //   enableFullScreenOnVerticalDrag: false,
                                      //   aspectRatio: 16 / 9,
                                      //   builder: (context, player) {
                                      //     return player;
                                      //   },
                                      // ),
                                      height: SizeConfig.screenHeight! * 0.40,
                                      width: SizeConfig.screenWidth,
                                      // child: YoutubePlayer(
                                      //     aspectRatio: 16 / 9,
                                      //     controller:
                                      //         youtubePlayerController!),
                                    )
                              : Container(
                                  height: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: PickColors.whiteColor,
                                  ),
                                  width: SizeConfig.screenWidth,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image.network(
                                      authProvider.applicantInformation!
                                              .companyLogo ??
                                          "-",
                                    ),
                                    // child: SvgPicture.network(PickImages.zingHrLogo,),
                                  ),
                                ),
                          // videoPlayerController != null
                          //     ? VideoPlayerWidget(
                          //         videoPlayerController: videoPlayerController!,
                          //       )
                          //     : youtubePlayerController != null
                          //         ? Container(
                          //             height: SizeConfig.screenHeight! * 0.40,
                          //             width: SizeConfig.screenWidth,
                          //             child: YoutubePlayer(
                          //                 aspectRatio: 16 / 9,
                          //                 controller: youtubePlayerController!),
                          //           )
                          //         // showVideoProgressIndicator: true,
                          //         // onReady: () {},

                          //         //  Container(
                          //         //     height: 300,
                          //         //     child: HtmlElementView(
                          //         //       viewType: companyInfo
                          //         //           .companyInfoData!.companyVideo
                          //         //           .toString(),
                          //         //     ),
                          //         //   )
                          //         : Container(
                          //             height: 300,
                          //             decoration: BoxDecoration(
                          //               borderRadius:
                          //                   BorderRadius.circular(8.0),
                          //               color: PickColors.whiteColor,
                          //             ),
                          //             width: SizeConfig.screenWidth,
                          //             child: Image.asset(PickImages.zingHrLogo),
                          //           ),
                          // // videoPlayerController != null
                          // //     ? VideoPlayerWidget(
                          // //         videoPlayerController: videoPlayerController!,
                          // //       )
                          // //     : Container(
                          // //         height: 300,
                          // //         decoration: BoxDecoration(
                          // //           borderRadius: BorderRadius.circular(8.0),
                          // //           color: PickColors.whiteColor,
                          // //         ),
                          // //         width: SizeConfig.screenWidth,
                          // //         child: Image.asset(PickImages.zingHrLogo),
                          // //       ),
                          PickHeightAndWidth.height20,
                          (companyInfo.companyInfoData!.companyInfo ?? "")
                                      .toString()
                                      .trim() !=
                                  ""
                              ? HtmlWidget(
                                  companyInfo.companyInfoData!.companyInfo ??
                                      "",
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ZINGHR",
                                      style: CommonTextStyle()
                                          .subMainHeadingTextStyle
                                          .copyWith(
                                            color: PickColors.primaryColor,
                                          ),
                                    ),
                                    PickHeightAndWidth.height20,
                                    Text(
                                      "Born from a need to provide simple HR solutions, ZingHR combines technology with effortless on-the-Cloud solutions in almost every area in the lifecycle of Human Capital Management. Covering the entire spectrum from Recruitment to Separation, (also called Hire-to-Retire Processes), ZingHR provides easy integration with existing systems and faster deployments, supported with the best-in-class security platforms and a multi-tenant architecture. ZingHR deployments allow you to scale irrespective of geographies",
                                      style: CommonTextStyle()
                                          .textFieldLabelTextStyle
                                          .copyWith(
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                    PickHeightAndWidth.height10,
                                    Text(
                                      "ZingHR is brought to you by the Founders of Cnergyis, an enterprise HR Technologies, Outsourcing and Services Company, (providing complex and integrated employee lifecycle management solutions to large enterprises, using its proprietary Software-as-a-Service (SaaS) platform), and www.FileMyReturns.com, a pioneering system for electronically filing",
                                      style: CommonTextStyle()
                                          .textFieldLabelTextStyle
                                          .copyWith(
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                    PickHeightAndWidth.height30,
                                    Text(
                                      "VISION",
                                      style: CommonTextStyle()
                                          .subMainHeadingTextStyle
                                          .copyWith(
                                            color: PickColors.primaryColor,
                                          ),
                                    ),
                                    PickHeightAndWidth.height10,
                                    Text(
                                      "To Enable Business Transforming HR Processes, on the Cloud, with Amazing Simplicity",
                                      style: CommonTextStyle()
                                          .textFieldLabelTextStyle
                                          .copyWith(
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                    PickHeightAndWidth.height30,
                                  ],
                                ),
                        ],
                      ),
                    ),
                  );
      }),
    );
  }
}
