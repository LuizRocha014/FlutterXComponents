import 'dart:io';
import 'package:flutter/widgets.dart';

class SafeAreaWidget extends StatelessWidget {
  final bool top;
  final bool? bottom;
  final Widget child;
  const SafeAreaWidget({super.key, required this.child, this.top = true, this.bottom});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: Platform.isIOS,
      top: top,
      child: child,
    );
  }
}
