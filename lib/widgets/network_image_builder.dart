import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

class NetWorkImageBuilder extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;

  const NetWorkImageBuilder({
    Key? key,
    required this.imageUrl,
    required this.height,
    required this.width,
    required this.borderRadius,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit ?? BoxFit.cover,
                  // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn),
                ),
              ),
            ),
        placeholder: (context, url) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              // color: PickColors.bgColor,
            ),
            child: Shimmer.fromColors(
                child: CircleAvatar(backgroundColor: Colors.grey[200]),
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.white),
          );
        },
        errorWidget: (context, url, error) => Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: PickColors.bgColor,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
              ),
            ));
  }
}
