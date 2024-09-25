// ignore: depend_on_referenced_packages
import 'package:componentes_lr/src/utils/utils/string_utils.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MaskDefalutFormatter extends MaskTextInputFormatter {
  final bool maiusculo;
  final bool trim;
  MaskDefalutFormatter({this.maiusculo = true, this.trim = false}) : super();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final TextEditingValue novo = trim
        ? TextEditingValue(
            text: removeDiacritics(
              maiusculo ? newValue.text.removeAllWhitespaces.toUpperCase() : newValue.text.removeAllWhitespaces,
            ),
          )
        : TextEditingValue(text: removeDiacritics(maiusculo ? newValue.text.toUpperCase() : newValue.text));
    return newValue.copyWith(
      text: novo.text,
      selection: TextSelection.fromPosition(TextPosition(offset: novo.text.length)),
    );
  }
}
