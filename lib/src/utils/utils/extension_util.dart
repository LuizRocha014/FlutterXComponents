import 'dart:io';

extension StringNullableExtension on String? {
  bool get isNullOrEmpty => this == null || (this?.isEmpty ?? true);
  String? get formataStringParaAtribuicaoNullable => isNullOrEmpty ? null : this;
}

extension StringExtension on String {
  bool get temAcentos => RegExp(r'[^\u0000-\u007F]').hasMatch(this);
}

extension FileExtension on File {
  bool get pdf => path.toLowerCase().endsWith('.pdf');
}
