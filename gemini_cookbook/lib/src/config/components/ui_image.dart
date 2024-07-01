import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UIImage extends StatelessWidget {
  final double width;
  final double height;
  final String image;
  final Color color;
  const UIImage(
      {super.key,
      this.width = 42,
      this.height = 42,
      required this.image,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(image,
        width: width,
        height: height,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn));
  }
}
