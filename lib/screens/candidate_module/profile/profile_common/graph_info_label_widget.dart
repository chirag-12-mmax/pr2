import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';

class GraphInfoLabelWidget extends StatelessWidget {
  final Color? color;
  final String? title;
  const GraphInfoLabelWidget({
    super.key,
    this.color,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
        PickHeightAndWidth.width5,
        Flexible(
          child: Text(
            title ?? "",
          ),
        )
      ],
    );
  }
}
