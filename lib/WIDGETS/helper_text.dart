import 'package:drawer_panel/HELPERS/CONSTANTS/font_helper.dart';
import 'package:flutter/material.dart';

class HelperText1 extends StatelessWidget {
  final String text;
  final Color color;
  final TextDecoration decoration;
  final double fontSize;
  const HelperText1(
      {super.key,
      required this.text,
      this.color = Colors.black87,
      this.decoration = TextDecoration.none,
      this.fontSize = 22});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: PerfectTypogaphy.bold.copyWith(
        fontSize: fontSize,
        // fontWeight: FontWeight.normal,
        color: color,
        decoration: decoration,
        overflow: TextOverflow.ellipsis
      ),
      textAlign: TextAlign.center,
    );
  }
}