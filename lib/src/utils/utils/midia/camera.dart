// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:componentes_lr/src/models/widgets/bottom_sheet_popup.dart';
import 'package:componentes_lr/src/models/widgets/camera/widget/camera_widget.dart';
import 'package:componentes_lr/src/models/widgets/camera/widget/visualiza_foto_pdf_widget.dart';
import 'package:componentes_lr/src/models/widgets/export_widgets.dart';
import 'package:componentes_lr/src/utils/utils/app_measurements.dart';
import 'package:componentes_lr/src/utils/utils/font_sizes.dart';
import 'package:componentes_lr/src/utils/utils/midia/midia_util.dart';
import 'package:componentes_lr/src/utils/utils/routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

/// Classe Helper para as funções de câmera, aqui estão as funções genéricas para tirar foto e retornar um ArquivoViewModel
/// com o base64 e extensão do arquivo
//Função para validar se a extensão do arquivo corresponde a uma imagem aceita pelo sistema
bool validaExtensaoFoto(String extensao) =>
    extensao.contains('jpg') || extensao.contains('png') || extensao.contains('jpeg');
bool validaExtensaoArquivo(String? extensao) =>
    extensao != null && (validaExtensaoFoto(extensao) || extensao.contains('pdf'));
bool isPdfAccept = true;

//Função para chamar o pop-up de registro de foto, recebe os parâmetros da câmera, texto HTML, caso tenha, do pop-up e o contexto
Future<List<MidiaUtil>> btnAnexarFoto(
  List<MidiaUtil> midias,
  BuildContext context, {
  bool somenteCamera = false,
}) async {
  try {
    //Se a lista de arquivos estiver vazia a foto é nova
    if (midias.isEmpty) {
      final arquivoIndividual = await _btnEscolheCamera(context, frontal: kDebugMode);
      if (arquivoIndividual == null) throw Exception();
      midias.add(arquivoIndividual);
    }
    //Se a base64 não estiver vazia verifica se é foto ou PDF e mostra os widgets correspondentes
    else {
      //Imagem
      Future<void> substituirFoto0(int index) async {
        final arquivo = await _btnEscolheCamera(context, frontal: kDebugMode);

        if (arquivo == null) throw Exception();
        midias.removeAt(index);
        midias.insert(index, arquivo);
        context.pop();
      }

      Future<void> excluiFoto0(int index) async {
        midias[index].file.delete();
        midias.removeAt(index);
        context.pop();
      }

      final returnedMidias = await context.push(
        VisualizaFotoPdfWidget(
          listArquivo: midias,
          onPressedSubstituirFoto: substituirFoto0,
          onPressedExcluirFoto: excluiFoto0,
        ),
      );

      if (returnedMidias != null) {
        // ignore: parameter_assignments
        midias = returnedMidias as List<MidiaUtil>;
      }
      // await context.push(
      //   const CameraWidget(),
      // );
    }
  } catch (_) {
    return [];
  }
  return midias;
}

//Método que dispara o pop-up de escolha de câmera ou galeria
Future<MidiaUtil?> escolheCameraOuGaleria(BuildContext context, {bool frontal = false}) async {
  MidiaUtil? arquivoViewModel;
  await openDefaultPopUp(
    context,
    tituloConfirmar: "Cancelar",
    titulo: "Aviso!",
    descricao: "Escolha a forma que deseja anexar o arquivo:",
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () async {
              arquivoViewModel = await btnEscolheGaleria(context);
              context.pop();
            },
            child: Column(
              children: [
                SizedBox(
                  height: 8.h,
                  width: 8.h,
                  child: Icon(
                    Icons.photo,
                    size: 5.h,
                  ),
                ),
                const TextWidget(
                  "Galeria",
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              arquivoViewModel = await _btnEscolheCamera(context, frontal: kDebugMode);
              context.pop();
            },
            child: Column(
              children: [
                SizedBox(
                  height: 8.h,
                  width: 8.h,
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 5.h,
                  ),
                ),
                const TextWidget(
                  "Câmera",
                ),
              ],
            ),
          ),
        ],
      ),
    ],
    onTapBotaoConfirmar: () => context.pop(),
  );
  return arquivoViewModel;
}

//Função para chamar a câmera, caso o retorno da tela de câmera seja nulo não salvará nada no arquivo
Future<MidiaUtil?> _btnEscolheCamera(BuildContext context, {bool frontal = false}) async {
  MidiaUtil? arquivoViewModel;
  try {
    final file = await context.push(const CameraWidget());
    if (file is MidiaUtil) {
      arquivoViewModel = await _comprimeSalvaArquivo(context, file.file);
    } else if (file is FilePickerResult) {
      arquivoViewModel = await _comprimeSalvaArquivo(context, File(file.files.single.path!), fotoGaleria: true);
    } else {
      arquivoViewModel = null;
    }
    // //Get.back();
  } catch (_) {
    arquivoViewModel = null;
  } finally {
    //Get.back();
  }
  return arquivoViewModel;
}

//Função para chamar a galeria, caso o retorno da tela de câmera seja nulo não salvará nada no arquivo
Future<MidiaUtil?> btnEscolheGaleria(BuildContext context) async {
  MidiaUtil? arquivoViewModel;
  try {
    final image = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: isPdfAccept ? ['jpg', 'jpeg', 'png', 'pdf'] : ['jpg', 'jpeg', 'png'],
    );
    if (image == null) {
      arquivoViewModel = null;
    } else {
      final File file = File(image.files.single.path!);
      arquivoViewModel = await _comprimeSalvaArquivo(context, file);
    }
  } catch (_) {
    arquivoViewModel = null;
  } finally {
    //Get.back();
  }
  return arquivoViewModel;
}

//Função para comprimir e salvar arquivo
Future<MidiaUtil?> _comprimeSalvaArquivo(BuildContext context, File file, {bool fotoGaleria = false}) async {
  try {
    final extensaoArquivo = p.extension(file.path);
    //Caso seja PDF não passa pelo tratamento para diminuição de qualidade que a imagem passa
    if (extensaoArquivo == '.pdf') {
      debugPrint("Tamanho PDF: ${file.lengthSync()}");
      if (file.lengthSync() > 10000000) {
        await openDefaultPopUp(
          context,
          tituloConfirmar: "Ok",
          titulo: "Aviso!",
          descricao:
              "O arquivo ultrapassa o limite de tamanho do arquivo para envio.\nTamanho máximo do arquivo para envio: 10MB.",
          onTapBotaoConfirmar: () => context.pop(),
        );
      }
    }

    final bytes = await file.readAsBytes();
    await file.delete();
    await file.create();
    //Se for uma imagem que vem da galeria, precisa comprimir para envio, as imagens da câmera do aplicativo já são comprimidas
    //Se for PDF não é comprimido
    XFile? imagemComQualidadeDiminuida;
    if (validaExtensaoFoto(extensaoArquivo) && fotoGaleria) {
      imagemComQualidadeDiminuida = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        "${file.absolute.path.substring(0, file.absolute.path.lastIndexOf("/"))}/temp.jpg",
        quality: 50,
      );
    }
    if (imagemComQualidadeDiminuida != null) {
      try {
        await file.writeAsBytes(await imagemComQualidadeDiminuida.readAsBytes());
      } catch (_) {
        await file.writeAsBytes(bytes);
      }
    } else {
      await file.writeAsBytes(bytes);
    }
    final foto = MidiaUtil.camera(file: file, id: file.path.split("/").last.split(".").first);
    return foto;
  } catch (e) {
    return null;
  }
}

Future<MidiaUtil?> btnAnexarFotoUnica(
  MidiaUtil? arquivoViewModel,
  BuildContext context, {
  bool acceptPdf = true,
}) async {
  isPdfAccept = acceptPdf;
  final midia = await btnAnexarFoto(arquivoViewModel == null ? [] : [arquivoViewModel], context);
  if (midia.isEmpty) return null;
  return midia.first;
}

class AcoesItem extends StatelessWidget {
  final String? tituloBotaoVermelho;
  final void Function()? primeiroOnTap;
  final void Function()? segundoOnTap;
  const AcoesItem({
    super.key,
    this.tituloBotaoVermelho,
    this.primeiroOnTap,
    this.segundoOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 1.h),
          TextWidget(
            "Ações",
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
            fontSize: smallFont,
          ),
          SizedBox(height: 1.h),
          TextWidget(
            "Selecione uma ação a ser realizada",
            fontSize: smallFont,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ContainerDescricaoAcoes(
                descricao: "Excluir",
                icon: Icons.delete,
                onTap: primeiroOnTap,
              ),
              SizedBox(width: 1.5.w),
              ContainerDescricaoAcoes(
                descricao: "Editar",
                icon: Icons.edit,
                onTap: segundoOnTap,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Column(
            children: [
              SizedBox(height: 0.5.h),
              ButtonWidget(
                fontSize: smallFont,
                title: "CANCELAR",
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContainerDescricaoAcoes extends StatelessWidget {
  final String descricao;
  final IconData icon;
  final Color? cor;
  final void Function()? onTap;
  const ContainerDescricaoAcoes({super.key, required this.descricao, this.onTap, this.cor, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 7.h,
              minWidth: 7.h,
              maxHeight: 7.h,
              maxWidth: 7.h,
            ),
            child: Container(
              padding: EdgeInsets.all(1.8.h),
              decoration: BoxDecoration(
                color: cor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 4.h, color: cor),
            ),
          ),
          SizedBox(height: 1.h),
          TextWidget(descricao, textColor: cor, fontSize: smallFont),
        ],
      ),
    );
  }
}
