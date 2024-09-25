class FormatedCustomException implements Exception {
  final String? message;

  const FormatedCustomException(
    this.message,
  );

  @override
  String toString() => message ?? "Ocorreu um problema não esperado\nTente novamente!";
}

class CustomException implements Exception {
  final String message;

  const CustomException(
    this.message,
  );

  @override
  String toString() => message;
}
