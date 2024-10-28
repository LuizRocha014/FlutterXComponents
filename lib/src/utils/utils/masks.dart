import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final carLicensePlateMask = MaskTextInputFormatter(
  mask: "###-&@&&",
  filter: {
    "#": RegExp('[a-zA-Z]'),
    "&": RegExp('[0-9]'),
    "@": RegExp('[a-zA-Z|0-9]')
  },
);

final cpfMask = MaskTextInputFormatter(
  mask: '###.###.###-##',
  filter: {"#": RegExp('[0-9]')},
);

final phoneMask = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: {"#": RegExp('[0-9]')},
);

final dateMask = MaskTextInputFormatter(
  mask: '@#/&#/####',
  filter: {"#": RegExp('[0-9]'), "@": RegExp('[0-3]'), "&": RegExp('[0-1]')},
);

final yearMask = MaskTextInputFormatter(
  mask: '####',
  filter: {"#": RegExp('[0-9]')},
);

class PhoneNumberMask extends MaskTextInputFormatter {
  final bool? isCellphone;
  static String cellphoneMask = "(##) #####-####";
  static String phoneMask = "(##) ####-####";

  PhoneNumberMask(this.isCellphone)
      : super(
          mask: (isCellphone == true ? cellphoneMask : phoneMask),
          filter: {"#": RegExp(r'[\d,\b]')},
        );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (isCellphone == null) {
      if (newValue.text.length == 15 && getMask() != cellphoneMask) {
        updateMask(mask: cellphoneMask);
      } else if (newValue.text.length == 14 && getMask() != phoneMask) {
        updateMask(mask: phoneMask);
      }
    }

    return super.formatEditUpdate(oldValue, newValue);
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }

  String format(String? text) {
    return formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(
        text: text ?? '',
        selection: TextSelection(
            baseOffset: text?.length ?? 0, extentOffset: text?.length ?? 0),
      ),
    ).text;
  }
}

class CodeValidatorMask extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text.isNotEmpty &&
        newValue.text.length > 1 &&
        int.tryParse(newValue.text.substring(1)) != null) {
      return TextEditingValue(text: newValue.text.substring(1));
    } else {
      return newValue;
    }
  }
}

class DateFormatter extends MaskTextInputFormatter {
  DateFormatter()
      : super(
          mask: '@#/&#/####',
          filter: {
            "#": RegExp('[0-9]'),
            "@": RegExp('[0-3]'),
            "&": RegExp('[0-1]')
          },
        );
}

class CepInputFormatter extends MaskTextInputFormatter {
  CepInputFormatter()
      : super(
          mask: '#####-###',
          filter: {"#": RegExp(r'[0-9]')},
        );
}
