import 'package:flutter/material.dart';

class UISpace extends StatelessWidget {
  final double height;
  const UISpace({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: MediaQuery.of(context).size.width,
    );
  }
}
