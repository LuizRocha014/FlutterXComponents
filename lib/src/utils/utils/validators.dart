import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:intl/intl.dart';

extension StringNullableExtension on String? {
  bool get isNullOrEmpty => this == null || (this?.isEmpty ?? true);
  String? get formataStringParaAtribuicaoNullable => isNullOrEmpty ? null : this;
}

extension StringExtension on String {
  bool get temAcentos => RegExp(r'[^\u0000-\u007F]').hasMatch(this);
  String get obterNumeros => replaceAll(RegExp('[^0-9]'), '').trim();
  String get removeAllSpecialCharacters => replaceAll(RegExp('[^A-Za-z0-9]'), '');
}

extension FileExtension on File {
  bool get pdf => path.toLowerCase().endsWith('.pdf');
}

Future<bool> verificaConexao() async {
  try {
    final result = await InternetAddress.lookup("google.com");
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (e) {
    return false;
  }
}

bool isValidDate(String input) {
  try {
    final DateTime birthDate = DateFormat("dd/MM/yyyy").parse(input);
    final originalFormatString = toOriginalFormatString(birthDate);
    return input == originalFormatString;
  } catch (e) {
    return false;
  }
}

String toOriginalFormatString(DateTime dateTime) {
  final d = dateTime.day.toString().padLeft(2, '0');
  final m = dateTime.month.toString().padLeft(2, '0');
  final y = dateTime.year.toString().padLeft(4, '0');
  return "$d/$m/$y";
}

String? isValidDocument(String? value) {
  if (!CPFValidator.isValid(value) && !CNPJValidator.isValid(value)) {
    return "Documento inválido";
  }
  return null;
}

String? validacaoObrigatorio(String? value) {
  if (value.isNullOrEmpty) {
    return 'Campo obrigatório';
  }
  return null;
}

String? validacaoObrigatorioTamanho(String? value, int lenght) {
  if (value.isNullOrEmpty) {
    return 'Campo obrigatório';
  }
  if (value!.length < lenght) {
    return 'Campo deve ter no mínimo $lenght caracteres';
  }
  return null;
}

String? validacaoData(String? value) {
  try {
    if (value == null || value.trim().isEmpty) {
      return "A data deve ser digitada";
    }
    if (!isValidDate(value)) {
      return "A data digitada é inválida";
    }
  } catch (_) {
    return "A data  digitada é inválida ";
  }
  return null;
}

String? validacaoDataMaiorIdade(String? value) {
  try {
    if (value == null || value.trim().isEmpty) {
      return "A data deve ser digitada";
    }
    if (!isValidDate(value)) {
      return "A data digitada é inválida";
    }
    if (isDataMaiorDeIdade(value)) {
      return "É necessário ter mais de 18 anos para se cadastrar";
    }
  } catch (_) {
    return "A data  digitada é inválida ";
  }
  return null;
}

bool isDataMaiorDeIdade(String input) {
  try {
    final DateTime birthDate = DateFormat("dd/MM/yyyy").parse(input);
    final DateTime hoje = DateTime.now();
    return birthDate.isBefore(DateTime(hoje.year - 18, hoje.month, hoje.day));
  } catch (e) {
    return false;
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }
}

String? validacaoEmail(String? value) {
  if (value.isNullOrEmpty) {
    return 'Campo obrigatório';
  }
  if (value!.isValidEmail() == false) {
    return 'E-mail inválido';
  }
  return null;
}
