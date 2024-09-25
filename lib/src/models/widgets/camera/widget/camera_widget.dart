import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:componentes_lr/src/models/widgets/camera/controller/camera_widget_controller.dart';
import 'package:componentes_lr/src/models/widgets/export_widgets.dart';
import 'package:componentes_lr/src/utils/utils/app_measurements.dart';
import 'package:componentes_lr/src/utils/utils/colors.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class CameraWidget extends StatefulWidget {
  final bool frontal;
  const CameraWidget({super.key, this.frontal = false});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> with WidgetsBindingObserver {
  late CameraWidgetController controller;
  @override
  void initState() {
    controller = CameraWidgetController(context);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller.iniciaCamera(forcado: true, frontal: widget.frontal);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!(controller.cameraController?.value.isInitialized ?? false)) return;
    if (state == AppLifecycleState.inactive && !controller.isGaleryOpen) {
      controller.cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      await controller.iniciaCamera(onResume: true);
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    Future.microtask(
      () async => Future.wait([
        if (controller.cameraController?.dispose() != null) controller.cameraController!.dispose(),
      ]),
    );
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PopScope(
        onPopInvoked: (value) => controller.retornarTela(),
        child: SafeArea(
          bottom: Platform.isAndroid,
          child: ValueListenableBuilder(
            valueListenable: controller.isLoading,
            builder: (c, b, w) {
              if (controller.isLoading.value || controller.cameraController == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return !controller.temFoto
                    ? Stack(
                        children: [
                          GestureDetector(
                            onDoubleTap: () async => controller.btnTrocarCamera(),
                            child: Transform.scale(
                              scale: controller.scale,
                              child: Center(child: CameraPreview(controller.cameraController!)),
                            ),
                          ),
                          BotaoCameraWidget(
                            icon: Icons.arrow_back,
                            onPressed: () => controller.retornarTela(),
                            alignment: Alignment.topLeft,
                          ),
                          BotaoCameraWidget(
                            icon: Icons.photo_size_select_actual_rounded,
                            onPressed: () async {
                              await controller.abrirGaleria();
                              setState(() {});
                            },
                            alignment: Alignment.bottomRight,
                          ),
                          BotaoCameraWidget(
                            icon: Icons.camera_alt,
                            onPressed: () async => controller.tirarFoto(),
                            alignment: Alignment.bottomCenter,
                          ),
                          BotaoCameraWidget(
                            icon: Icons.cameraswitch,
                            onPressed: () async => controller.btnTrocarCamera(),
                            alignment: Alignment.topRight,
                          ),
                          ValueListenableBuilder(
                            valueListenable: controller.flashLigado,
                            builder: (c, b, w) {
                              return BotaoCameraWidget(
                                icon: controller.flashLigado.value ? Icons.flash_on : Icons.flash_off,
                                onPressed: () async => controller.btnFlashCamera(),
                                alignment: Alignment.bottomLeft,
                              );
                            },
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: Transform.scale(
                                  scale: controller.scale,
                                  child: AspectRatio(
                                    aspectRatio: controller.cameraController?.value.aspectRatio ?? 1,
                                    child: controller.foto.value!.pdf
                                        ? PDFView(
                                            pdfData: controller.foto.value!.midia,
                                            autoSpacing: false,
                                          )
                                        : Image.memory(
                                            controller.foto.value!.midia,
                                          ),
                                  ),
                                ),
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          controller.foto.value = null;
                                          await controller.iniciaCamera(onResume: true);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all<Color>(
                                            black.withOpacity(0.5),
                                          ),
                                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(0),
                                            ),
                                          ),
                                        ),
                                        child: const TextWidget(
                                          "NOVA FOTO",
                                          textColor: white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async => controller.retornarTela(salvar: true),
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all<Color>(
                                            black.withOpacity(0.5),
                                          ),
                                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(0),
                                            ),
                                          ),
                                        ),
                                        child: const TextWidget(
                                          "ESCOLHER",
                                          textColor: white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          BotaoCameraWidget(
                            icon: Icons.arrow_back,
                            onPressed: controller.retornarTela,
                            alignment: Alignment.topLeft,
                          ),
                        ],
                      );
              }
            },
          ),
        ),
      ),
    );
  }
}

class BotaoCameraWidget extends StatelessWidget {
  final void Function()? onPressed;
  final AlignmentGeometry? alignment;
  final IconData icon;
  final double? radius;
  final double? size;
  const BotaoCameraWidget({super.key, this.onPressed, this.alignment, required this.icon, this.radius, this.size});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(3.w, 2.h, 3.w, 2.h),
        child: CircleAvatar(
          radius: 6.w,
          backgroundColor: black.withOpacity(0.5),
          child: IconButton(
            icon: Icon(
              icon,
              color: Colors.white,
              size: 5.w,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
