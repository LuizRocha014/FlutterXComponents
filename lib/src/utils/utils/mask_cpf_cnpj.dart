import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MaskCpfCnpj extends MaskTextInputFormatter {
  final bool? cnpj;
  static String mascaraCPF = "###.###.###-##";
  static String mascaraCNPJ = "##.###.###/####-##";

  MaskCpfCnpj(this.cnpj)
      : super(
          mask: (cnpj == true ? mascaraCNPJ : mascaraCPF),
          filter: {"#": RegExp(r'[\d,\b]')},
        );

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (cnpj == null) {
      if (newValue.text.length == 15 && getMask() != mascaraCNPJ) {
        updateMask(mask: mascaraCNPJ);
      } else if (newValue.text.length == 14 && getMask() != mascaraCPF) {
        updateMask(mask: mascaraCPF);
      }
    }

    return super.formatEditUpdate(oldValue, newValue);
  }
}
