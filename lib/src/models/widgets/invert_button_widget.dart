import 'dart:async';
import 'package:componentes_lr/src/models/widgets/export_widgets.dart';
import 'package:componentes_lr/src/utils/utils/colors.dart';
import 'package:componentes_lr/src/utils/utils/font_sizes.dart';
import 'package:flutter/material.dart';

class InvertButtonWidget extends StatelessWidget {
  final String title;
  final FutureOr<void> Function()? onPressed;
  const InvertButtonWidget({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      title: title,
      color: white,
      borderColor: black,
      fontColor: black,
      fontSize: mediumFont,
      onPressed: onPressed,
    );
  }
}
