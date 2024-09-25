import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:componentes_lr/src/models/widgets/bottom_sheet_popup.dart';
import 'package:componentes_lr/src/utils/utils/midia/MFile.dart';
import 'package:componentes_lr/src/utils/utils/midia/camera.dart';
import 'package:componentes_lr/src/utils/utils/midia/midia_util.dart';
import 'package:componentes_lr/src/utils/utils/routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as i;
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class CameraWidgetController extends ChangeNotifier {
  late ValueNotifier<MFile?> foto;
  CameraController? cameraController;
  late ValueNotifier<bool> isLoading;
  late bool isGaleryOpen;
  late ValueNotifier<bool> flashLigado;
  late NativeDeviceOrientation orientacaoNaHoraDaFoto = NativeDeviceOrientation.portraitUp;
  late CameraLensDirection orientacaoCamera;
  late final BuildContext context;

  CameraWidgetController(this.context) {
    // this.foto = arquivo;
    // this.frontal = frontal ?? false;
    isGaleryOpen = false;
    foto = ValueNotifier(null);
    isLoading = ValueNotifier(true);
    flashLigado = ValueNotifier(false);
  }

  bool get temFoto => foto.value != null;
  // bool get tiraFoto => !temFoto;

  double get scale {
    if (cameraController == null) return 1;
    final size = MediaQuery.of(context).size;
    late double scale;
    try {
      scale = size.aspectRatio * cameraController!.value.aspectRatio;
    } catch (_) {
      scale = 1;
    }
    if (scale < 1) scale = 1 / scale;
    return scale;
  }

  Future<void> iniciaCamera({bool forcado = false, bool frontal = false, bool onResume = false}) async {
    try {
      if (isLoading.value && !forcado) return;
      isLoading.value = true;
      final status = await Permission.camera.status;
      if (status.isGranted) {
        await _previewCamera(await camera(frontal: frontal, onResume: onResume, forcado: forcado));
        await cameraController?.unlockCaptureOrientation();
      } else {
        final status = await Permission.camera.request();
        if (status.isPermanentlyDenied && context.mounted) {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Aviso"),
              content: const Text(
                "Você negou a permissão para a câmera permanentemente\nDeseja ir para a tela de configurações do aplicativo para habilitar essa permissão?",
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text(
                    'CANCELAR',
                    style: TextStyle(
                      color: Color(0xff12487d),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => openAppSettings(),
                  child: const Text(
                    'ABRIR CONFIGURAÇÕES',
                    style: TextStyle(
                      color: Color(0xff12487d),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (status.isDenied) {
          await Permission.camera.request();
        } else if (status.isGranted) {
          return await iniciaCamera(forcado: true);
        }
      }
    } catch (e) {
      if (context.mounted) {
        openDefaultPopUp(
          context,
          tituloConfirmar: "Ok",
          titulo: "Ocorreu um erro ao abrir a câmera\nTente novamente",
          onTapBotaoConfirmar: () => context.pop(),
        );
      }
    } finally {
      if (!isGaleryOpen) isLoading.value = false;
    }
  }

  Future<void> btnTrocarCamera() async {
    try {
      if (!isLoading.value) {
        isLoading.value = true;
        await _previewCamera(await camera());
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> btnFlashCamera() async {
    if (!isLoading.value) {
      flashLigado.value = !flashLigado.value;
    }
  }

  Future<void> retornarTela({bool salvar = false}) async {
    try {
      if (cameraController == null) throw Exception();
      if (!isLoading.value) {
        isLoading.value = true;
        if (temFoto && salvar) {
          final newFile = File(foto.value!.path);
          await newFile.writeAsBytes(foto.value!.midia);
          await newFile.create();
          final newFileName = foto.value!.path.split("/").last.split(".").first;
          // ignore: use_build_context_synchronously
          return context.pop(
            MidiaUtil(
              midiaId: newFileName,
              nome: newFileName,
              extensao: foto.value!.pdf ? MidiaExtensao.pdf : MidiaExtensao.jpeg,
              path: newFile.path,
            ),
          );
        } else {
          throw Exception();
        }
      }
    } catch (_) {
      context.pop();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> abrirGaleria() async {
    try {
      isLoading.value = true;
      isGaleryOpen = true;
      final image = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: isPdfAccept ? ['jpg', 'jpeg', 'png', 'pdf'] : ['jpg', 'jpeg', 'png'],
      );
      if (image == null && context.mounted) {
        return context.pop();
      } else {
        foto.value = await proccessFile(image!.files.single.xFile);
      }
    } catch (_) {
      if (context.mounted) {
        openDefaultPopUp(
          context,
          tituloConfirmar: "Ok",
          titulo: "Ocorreu um erro ao abrir a galeria\nTente novamente",
          onTapBotaoConfirmar: () => context.pop(),
        );
      }
    } finally {
      isLoading.value = false;
      isGaleryOpen = false;
    }
  }

  Future<CameraDescription> camera({bool frontal = false, bool onResume = false, bool forcado = false}) async {
    final cameras = await availableCameras();
    //Caso a lista de câmeras vier vazia gera uma excessão para ir ao catch
    if (cameras.isEmpty) throw Exception();
    //Valor padrão da orientação é traseiro
    orientacaoCamera = CameraLensDirection.back;
    if (forcado) {
      orientacaoCamera = frontal ? CameraLensDirection.front : CameraLensDirection.back;
    } else {
      //Define se a câmera abrirá no modo frontal
      //Valida se a câmera está inicializada e se a orientação é traseiro ou se é para abrir a câmera frontal
      if ((cameraController!.value.isInitialized &&
              cameraController?.description.lensDirection == CameraLensDirection.back &&
              !onResume) ||
          frontal) {
        orientacaoCamera = orientacaoCamera = CameraLensDirection.front;
      } else if (cameraController!.value.isInitialized && onResume) {
        orientacaoCamera = cameraController!.description.lensDirection;
      }
    }
    //Caso o parâmetro onResume seja true ele irá buscar a câmera com a orientação ativa do celular
    //Retorna a câmera para o usuário, mandando orientaçãoCamera para definir a orientação
    final camera = cameras.firstWhere(
      (element) => element.lensDirection == orientacaoCamera,
      orElse: () => CameraDescription(
        name: '1',
        lensDirection: orientacaoCamera == CameraLensDirection.back ? CameraLensDirection.back : CameraLensDirection.front,
        sensorOrientation: 90,
      ),
    );
    return camera;
  }

  Future<void> _previewCamera(CameraDescription camera) async {
    try {
      cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      cameraController?.unlockCaptureOrientation();
      return await cameraController?.initialize();
    } on CameraException catch (_) {
      throw Exception();
    }
  }

  Future<void> tirarFoto() async {
    bool setouLoading = false;
    try {
      orientacaoNaHoraDaFoto = await NativeDeviceOrientationCommunicator().orientation(useSensor: true).timeout(
            const Duration(seconds: 3),
            onTimeout: () => NativeDeviceOrientation.portraitUp,
          );
    } catch (e) {
      orientacaoNaHoraDaFoto = NativeDeviceOrientation.portraitUp;
    }
    if (cameraController!.value.isInitialized) {
      try {
        if (!isLoading.value) {
          isLoading.value = true;
          setouLoading = true;
        }
        late XFile file;
        try {
          flashLigado.value
              ? await cameraController?.setFlashMode(FlashMode.torch)
              : await cameraController?.setFlashMode(FlashMode.off);
          if (flashLigado.value) await cameraController?.setFlashMode(FlashMode.always);
          file = await cameraController!.takePicture();
        } catch (_) {
          file = await cameraController!.takePicture();
        }

        foto.value = await proccessFile(file);
      } on CameraException catch (_) {
        foto.value = null;
      } finally {
        if (setouLoading) isLoading.value = false;
      }
    }
  }

  Future<MFile> proccessFile(XFile file) async {
    final String id = const Uuid().v4();
    late Uint8List? content;
    final imagem = File(file.path);
    final isPdf = imagem.path.toLowerCase().endsWith('.pdf');
    final String nomeArquivo = isPdf ? "$id.pdf" : "$id.jpeg";
    final path = "${(await getApplicationDocumentsDirectory()).path}/$nomeArquivo";
    log(path);
    try {
      if (isPdf) throw Exception();
      if (imagem.readAsBytesSync().lengthInBytes > 0) {
        final image = await compute(i.decodeImage, imagem.readAsBytesSync());

        if (orientacaoNaHoraDaFoto != NativeDeviceOrientation.portraitUp) {
          late i.Image? rotateImage;
          switch (orientacaoNaHoraDaFoto) {
            case NativeDeviceOrientation.landscapeRight:
              rotateImage = i.copyRotate(image!, angle: orientacaoCamera == CameraLensDirection.front ? -90 : 90);
            case NativeDeviceOrientation.landscapeLeft:
              rotateImage = i.copyRotate(image!, angle: orientacaoCamera == CameraLensDirection.front ? 90 : -90);
            case NativeDeviceOrientation.portraitDown:
              rotateImage = i.copyRotate(image!, angle: 180);
            default:
              rotateImage = image;
          }
          content = i.encodeJpg(rotateImage!);
        } else {
          content = i.encodeJpg(image!);
        }
      }
    } catch (_) {
      content = imagem.readAsBytesSync();
    }
    await imagem.delete();
    return MFile(path, content!, isPdf ? "pdf" : "jpeg", orientacaoNaHoraDaFoto.deviceOrientation);
  }
}

enum OrientacaoCamera { frontal, traseiro }
