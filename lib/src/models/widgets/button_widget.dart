import 'dart:async';

import 'package:componentes_lr/src/models/widgets/export_widgets.dart';
import 'package:componentes_lr/src/utils/utils/app_measurements.dart';
import 'package:componentes_lr/src/utils/utils/colors.dart';
import 'package:componentes_lr/src/utils/utils/font_sizes.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final String? title;
  final double? fontSize;
  final Color? color;
  final Color? fontColor;
  final bool? ignoring;
  final double? height;
  final double? width;
  final String? iconePath;
  final FontWeight? fontWeight;
  final FutureOr<void> Function()? onPressed;
  final double? verticalPadding;
  final bool useShadow;
  final double? horizontalPadding;
  final bool usesLoading;
  final Widget? complementText;
  final Color? borderColor;
  final double? borderRadius;
  final IconData? iconButton;
  final Widget? child;
  final bool? isLoading;
  final bool isFixedSize;

  /// Widget padrão para os botões utilizados no sistema
  const ButtonWidget({
    super.key,
    required this.title,
    this.fontSize,
    this.color,
    this.fontColor,
    this.ignoring,
    required this.onPressed,
    this.width,
    this.height,
    this.iconePath,
    this.verticalPadding,
    this.horizontalPadding,
    this.usesLoading = false,
    this.complementText,
    this.borderColor,
    this.iconButton,
    this.borderRadius,
    this.fontWeight,
    this.child,
    this.isLoading,
    this.useShadow = false,
    this.isFixedSize = true,
  });

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool botaoExecutando = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.ignoring ?? false,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: widget.verticalPadding ?? 0.25.h,
          horizontal: widget.horizontalPadding ?? 0,
        ),
        child: ElevatedButton(
          onPressed: () async {
            if (!botaoExecutando) {
              if (mounted) {
                setState(() => botaoExecutando = true);
              }
              if (mounted) {
                await widget.onPressed?.call();
              }
              if (mounted) {
                setState(() => botaoExecutando = false);
              }
            }
          },
          style: ElevatedButton.styleFrom(
            shape: widget.borderRadius != null || widget.borderColor != null
                ? RoundedRectangleBorder(
                    borderRadius: widget.borderRadius == null
                        ? BorderRadius.zero
                        : BorderRadius.circular(widget.borderRadius!),
                    side: widget.borderColor == null
                        ? BorderSide.none
                        : BorderSide(color: widget.borderColor!),
                  )
                : null,
            backgroundColor: widget.color,
            shadowColor: widget.useShadow ? null : transparent,
            elevation: widget.useShadow ? 5 : 0,
            fixedSize: widget.isFixedSize
                ? Size(widget.width ?? 80.w, widget.height ?? 5.5.h)
                : null,
            minimumSize: Size.zero,
            padding: widget.isFixedSize
                ? EdgeInsets.zero
                : EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
          ),
          child: Row(
            mainAxisSize:
                widget.isFixedSize ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if ((botaoExecutando || widget.isLoading == true) &&
                  widget.usesLoading) ...[
                SizedBox(
                  height: 5.w,
                  width: 5.w,
                  child: const Align(
                    child: CircularProgressIndicator(
                      color: white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ] else ...[
                if (widget.child == null) ...[
                  if (widget.complementText != null) widget.complementText!,
                  TextWidget(
                    widget.title,
                    fontSize: widget.fontSize ?? mediumLargeFont,
                    textColor: widget.fontColor ?? white,
                    fontWeight: widget.fontWeight ?? FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  widget.child!,
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
