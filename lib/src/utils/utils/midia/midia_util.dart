import 'dart:io';
import 'dart:typed_data';

class MidiaUtil {
  late String midiaId;
  late String nome;
  String? path;
  final MidiaExtensao extensao;
  Uint8List? midiaBase64;
  String? midia;
  String? extemsaoString;

  late bool novo;

  File get file => File(path!);
  Uint8List get base64 => midiaBase64 ?? file.readAsBytesSync().buffer.asUint8List();

  MidiaUtil({
    required this.nome,
    this.path,
    required this.extensao,
    this.midiaBase64,
    required this.midiaId,
  });

  MidiaUtil.camera({
    required id,
    required File file,
    this.extensao = MidiaExtensao.jpeg,
  }) : super() {
    path = file.path;
    midiaId = id as String;
    extemsaoString = extensao.toString().substring(extensao.toString().lastIndexOf('.') + 1);
    nome = "$id.${extensao.name}";
  }

  MidiaUtil.copyWith(
    MidiaUtil midia,
  )   : nome = midia.nome,
        path = midia.path,
        extensao = midia.extensao,
        midiaBase64 = midia.midiaBase64,
        super();

  MidiaExtensao getMidiaExtensao() {
    if (path == null) {
      return MidiaExtensao.jpeg;
    } else if (path!.toLowerCase().endsWith('jpg')) {
      return MidiaExtensao.jpg;
    } else if (path!.toLowerCase().endsWith('png')) {
      return MidiaExtensao.png;
    } else if (path!.toLowerCase().endsWith('pdf')) {
      return MidiaExtensao.pdf;
    } else {
      return MidiaExtensao.jpeg;
    }
  }
}

enum MidiaExtensao {
  jpg,
  png,
  jpeg,
  pdf;
}

MidiaExtensao fromJsonExtensao(dynamic extensao) {
  if (extensao is String) {
    switch (extensao) {
      case 'jpg':
        return MidiaExtensao.jpg;
      case 'png':
        return MidiaExtensao.png;
      case 'pdf':
        return MidiaExtensao.pdf;
      case 'jpeg':
      default:
        return MidiaExtensao.jpeg;
    }
  } else {
    return MidiaExtensao.values[extensao as int];
  }
}

Future<MidiaExtensao?> getMidiaExtensaoByBase64(String? base64) async {
  if (base64 == null) {
    return null;
  }
  switch (base64[0]) {
    case '/':
      return MidiaExtensao.jpg;
    case 'i':
      return MidiaExtensao.png;
    case 'J':
      return MidiaExtensao.jpeg;
    case 'U':
      return MidiaExtensao.pdf;
    default:
      return null;
  }
}
