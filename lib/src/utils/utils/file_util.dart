import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

String? getPathFileExtension(String path) {
  return p.extension(path).replaceAll('.', '');
}

//Método para exportar um arquivo para o diretório de downloads
Future<void> exportFile(File arquivo, String nomeArquivo, String extensao) async {
  Directory? diretorioDocumentos =
      Platform.isAndroid ? Directory('/storage/emulated/0/Download') : await getApplicationCacheDirectory();
  // if (diretorioDocumentos == null) throw const FormatedCustomException("Não foi possível salvar o arquivo no dispositivo\nÉ possível compartilhar o arquivo");
  if (Platform.isAndroid && !await diretorioDocumentos.exists()) {
    diretorioDocumentos = await getExternalStorageDirectory();
  }
  if (diretorioDocumentos == null) throw Exception();
  final novoDiretorio = "${diretorioDocumentos.path}/$nomeArquivo.$extensao";
  final statusPermissao = await Permission.storage.status;
  if (!statusPermissao.isGranted) {
    final denied = await Permission.storage.request();
    if (denied.isPermanentlyDenied) await openAppSettings();
  }
  await arquivo.copy(novoDiretorio);
  await Share.shareXFiles([XFile(File(novoDiretorio).path)]);
}

Future<File> convertBase64ToFile(String image, String extensao) async {
  final Uint8List bytes = base64.decode(image);
  final String dir = (await getTemporaryDirectory()).path;
  final File file = File("$dir/${DateTime.now().millisecondsSinceEpoch}$extensao");
  await file.writeAsBytes(bytes);
  return file;
}
