import 'package:componentes_lr/src/utils/utils/app_measurements.dart';
import 'package:componentes_lr/src/utils/utils/colors.dart';
import 'package:flutter/widgets.dart';

class ContainerWidget extends StatelessWidget {
  final Color? color;
  final Color? borderColor;
  final Widget? child;
  final double? height;
  final double? width;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final AlignmentGeometry? alignment;
  final List<BoxShadow>? shadow;
  final BorderRadiusGeometry? borderRadius;
  const ContainerWidget({
    super.key,
    this.color,
    this.child,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.alignment,
    this.shadow,
    this.borderRadius,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: color ?? white,
        borderRadius: borderRadius ?? BorderRadius.circular(2.w),
        boxShadow: shadow,
        border: Border.all(
          color: borderColor ?? transparent,
          width: 0.5,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }

  static List<BoxShadow> sombraPadrao = [
    BoxShadow(
      color: black.withOpacity(0.25),
      spreadRadius: 1,
      blurRadius: 10,
      offset: const Offset(0, 1),
    ),
  ];
}
