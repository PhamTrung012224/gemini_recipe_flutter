import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final Color activeColor;
  final Color inactiveColor;
  final bool isSelected;
  final String text;

  const CustomChip(this.text,
      {super.key,
      this.inactiveColor = Colors.grey,
      this.activeColor = Colors.white,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Container(
        padding: const EdgeInsets.only(left:16,right: 16),
        alignment: Alignment.centerLeft,
        decoration:BoxDecoration(
          color: isSelected?activeColor:inactiveColor,
          borderRadius: const BorderRadius.all(Radius.circular(8))
        ),
        child:Text(text)
      ),
    );
  }
}
