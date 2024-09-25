import 'package:componentes_lr/src/utils/utils/colors.dart';
import 'package:componentes_lr/src/utils/utils/font_sizes.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String? text;
  final Color? textColor;
  final TextAlign? textAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final int? maxLines;
  final String? fontFamily;

  const TextWidget(
    this.text, {
    super.key,
    this.textColor,
    this.textAlign,
    this.fontSize,
    this.fontWeight,
    this.textDecoration,
    this.overflow,
    this.letterSpacing,
    this.maxLines,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: TextStyle(
        decoration: textDecoration,
        letterSpacing: letterSpacing,
        color: textColor ?? textStylePadrao.color,
        fontSize: fontSize ?? textStylePadrao.fontSize,
        fontWeight: fontWeight ?? textStylePadrao.fontWeight,
        fontFamily: fontFamily,
      ),
      textAlign: textAlign,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }

  static TextStyle textStylePadrao = TextStyle(
    color: black,
    fontSize: standardTextFont,
    fontWeight: FontWeight.normal,
  );
}
