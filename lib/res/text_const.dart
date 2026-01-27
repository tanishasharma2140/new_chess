import 'package:new_chess/res/font_family.dart';
import 'package:flutter/material.dart';

class TextConst extends StatelessWidget {
  final String title;
  final double? size;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final Color? color;

  // 👇 Added fields
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? decorationThickness;

  const TextConst({
    super.key,
    required this.title,
    this.size,
    this.fontWeight,
    this.color,
    this.fontFamily,
    this.decoration,
    this.decorationColor,
    this.decorationThickness,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: fontFamily ?? FontFamily.kanitReg,
        color: color ?? Colors.black,
        fontSize: size ?? kDefaultFontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
        decoration: decoration,
        decorationColor: decorationColor ?? color ?? Colors.black,
        decorationThickness: decorationThickness,
      ),
    );
  }
}
