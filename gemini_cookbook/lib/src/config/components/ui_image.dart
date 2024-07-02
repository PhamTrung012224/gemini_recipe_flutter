import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UIImage extends StatelessWidget {
  final double size;
  final String image;
  final Color color;
  const UIImage(
      {super.key,
      required this.size,
      required this.image,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(image,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn));
  }
}
