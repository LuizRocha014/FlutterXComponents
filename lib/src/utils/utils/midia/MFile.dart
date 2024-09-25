import 'package:flutter/services.dart';

class MFile {
  final String path;
  final Uint8List midia;
  final String extension;
  final DeviceOrientation? orientation;

  bool get pdf => path.toLowerCase().endsWith('.pdf');

  MFile(this.path, this.midia, this.extension, this.orientation);
}
