import 'package:auto_route/auto_route.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_view/job_description_screen.dart';
import 'package:video_player/video_player.dart';

@RoutePage()
class MyFullScreen extends StatefulWidget {
  const MyFullScreen(
      {super.key,
      required this.chewieController,
      required this.currentSliderPosition,
      required this.videoPlayerController,
      this.onChangeSliderPosition,
      this.onChangePlayButton,
      this.onChangeSoundButton,
      required this.isFullScreen,
      this.onChangeFullScreen,
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
  State<MyFullScreen> createState() => _MyFullScreenState();
}

class _MyFullScreenState extends State<MyFullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FullScreenVideoWidget(
          chewieController: widget.chewieController,
          currentSliderPosition: widget.currentSliderPosition,
          videoPlayerController: widget.videoPlayerController,
          onChangeSliderPosition: (value) {
            widget.onChangeSliderPosition(value);
            setState(() {});
          },
          onChangePlayButton: () {
            widget.onChangePlayButton();
            setState(() {});
          },
          onChangeSoundButton: () {
            widget.onChangeSoundButton();
            setState(() {});
          },
          isFullScreen: widget.isFullScreen,
          onChangeFullScreen: widget.onChangeFullScreen,
          videoDuration: widget.videoDuration),
    );
  }
}
