import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UIIcon extends StatelessWidget {
  final double size;
  final String icon;
  final Color color;
  const UIIcon(
      {super.key,
      required this.size,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(icon,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn));
  }
}
