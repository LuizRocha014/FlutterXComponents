import 'package:intl/intl.dart';

double formattedValueRealToDouble(String valor) {
  if (!valor.startsWith("R\$")) return 0;
  return double.tryParse(valor
          .replaceFirst("R\$", "")
          .replaceAll(".", "")
          .replaceAll(",", ".")
          .trim()) ??
      0;
}

String doubleToFormattedReal(double valor) {
  return NumberFormat.currency(name: 'R\$ ', locale: 'pt_BR', decimalDigits: 2)
      .format(valor);
}

String dateTimeBrazilianStandard(DateTime data) {
  return DateFormat('dd/MM/yy | kk:mm').format(data);
}

String dateBrazilianStandard(DateTime data) {
  return DateFormat('dd/MM/yy').format(data);
}

String timeFormat(DateTime data) {
  return DateFormat('kk:mm').format(data);
}

String timeDifferenceUntilNow(DateTime date) {
  final difference = DateTime.now().difference(date);

  if (difference.inSeconds < 60) {
    return "${difference.inSeconds} ${difference.inSeconds == 1 ? "segundo" : "segundos"} atrás";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} ${difference.inMinutes == 1 ? "minuto" : "minutos"} atrás";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} ${difference.inHours == 1 ? "hora" : "horas"} atrás";
  } else if (difference.inDays == 1) {
    return "1 dia atrás";
  } else {
    return "${difference.inDays} dias atrás";
  }
}

String fromDateTimeToStringPtBr(DateTime data, bool showHours) =>
    (showHours ? DateFormat('dd/MM/yyyy HH:mm') : DateFormat('dd/MM/yyyy'))
        .format(data);
DateTime fromStringToDateTimePtBr(String data, bool showHours) {
  final separadoPorEspaco = data.split(" ");
  final temHoras = separadoPorEspaco.length > 1;
  final dataSplit =
      temHoras ? separadoPorEspaco[0].split("/") : data.split("/");
  final horaSplit = temHoras ? separadoPorEspaco[1].split(":") : ["00", "00"];
  return DateTime(
    int.parse(dataSplit[2]),
    int.parse(dataSplit[1]),
    int.parse(dataSplit[0]),
    showHours ? int.parse(horaSplit[0]) : 0,
    showHours ? int.parse(horaSplit[1]) : 0,
  );
}

String camelCaseToUnderscore(String value) => value
    .replaceAllMapped(RegExp('(?<=[a-z])[A-Z]'), (m) => '_${m.group(0)}')
    .toLowerCase();

String returnInitialsName(String nameValue) {
  // Divide o nome completo em uma lista de palavras
  List<String> palavras = nameValue.split(' ');

  // Filtra para incluir apenas palavras não vazias
  List<String> palavrasFiltradas =
      palavras.where((palavra) => palavra.isNotEmpty).toList();

  // Pega apenas os dois primeiros nomes, ou menos se houver menos palavras
  List<String> primeirosDoisNomes = palavrasFiltradas.take(2).toList();

  // Mapeia para pegar a primeira letra de cada palavra e transforma em maiúscula
  String iniciais =
      primeirosDoisNomes.map((palavra) => palavra[0].toUpperCase()).join();

  return iniciais;
}
