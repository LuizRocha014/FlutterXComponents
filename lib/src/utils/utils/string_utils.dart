extension StringNullableExtension on String {
  String get removeAllWhitespaces => replaceAll(" ", "");

  String get removeAllSpecialCharacters => replaceAll(RegExp('[^A-Za-z0-9]'), '');
}
