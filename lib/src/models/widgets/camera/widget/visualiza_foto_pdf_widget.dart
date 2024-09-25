import 'dart:io';
import 'package:componentes_lr/src/models/widgets/camera/widget/camera_widget.dart';
import 'package:componentes_lr/src/models/widgets/export_widgets.dart';
import 'package:componentes_lr/src/utils/utils/app_measurements.dart';
import 'package:componentes_lr/src/utils/utils/colors.dart';
import 'package:componentes_lr/src/utils/utils/midia/midia_util.dart';
import 'package:componentes_lr/src/utils/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class VisualizaFotoPdfWidget extends StatefulWidget {
  final List<MidiaUtil> listArquivo;
  final double? tamanhoBotao;
  final String tituloFoto;
  final Function(int)? onPressedSubstituirFoto;
  final Function()? onPressedAdicionarFoto;
  final Function(int)? onPressedExcluirFoto;
  final int? limiteFoto;

  const VisualizaFotoPdfWidget({
    super.key,
    this.tituloFoto = "",
    required this.listArquivo,
    this.onPressedSubstituirFoto,
    this.tamanhoBotao,
    this.onPressedAdicionarFoto,
    this.onPressedExcluirFoto,
    this.limiteFoto,
  });

  @override
  State<VisualizaFotoPdfWidget> createState() => _VisualizaFotoPdfWidgetState();
}

class _VisualizaFotoPdfWidgetState extends State<VisualizaFotoPdfWidget> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        bottom: Platform.isAndroid,
        child: PageView.builder(
          controller: pageController,
          itemCount: widget.listArquivo.length,
          physics: widget.listArquivo.length > 1 ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Stack(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FotoPdfWidget(
                  onPressedAdicionarFoto: widget.onPressedAdicionarFoto,
                  onPressedSubstituirFoto: widget.onPressedSubstituirFoto,
                  index: index,
                  conteudo: Center(
                    child: widget.listArquivo[index].extensao == MidiaExtensao.pdf
                        ? PDFView(
                            pdfData: widget.listArquivo[index].base64,
                            autoSpacing: false,
                          )
                        : InteractiveViewer(
                            panEnabled: false,
                            minScale: 0.5,
                            maxScale: 2,
                            child: Image.memory(
                              widget.listArquivo[index].base64,
                              width: 100.w,
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Visibility(
                      visible: widget.listArquivo.length > 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BotaoCameraWidget(
                            icon: Icons.arrow_back,
                            alignment: Alignment.center,
                            onPressed: () => pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            ),
                          ),
                          BotaoCameraWidget(
                            icon: Icons.arrow_forward_outlined,
                            alignment: Alignment.center,
                            onPressed: () => pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 7.h,
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  decoration: BoxDecoration(color: black.withOpacity(0.6)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButtonWidget(
                          icon: Icons.arrow_back_ios,
                          onPressed: () => context.pop(widget.listArquivo),
                          color: white,
                        ),
                        Visibility(
                          visible: widget.listArquivo.length > 1,
                          child: TextWidget(
                            "${index + 1}/${widget.limiteFoto ?? widget.listArquivo.length}",
                            textColor: white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  width: 100.w,
                  child: Container(
                    height: 7.h,
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    decoration: BoxDecoration(color: black.withOpacity(0.6)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () => widget.onPressedSubstituirFoto!(index),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.loop,
                                  color: white,
                                ),
                                TextWidget("Alterar", textColor: white),
                              ],
                            ),
                          ),
                          if (widget.onPressedExcluirFoto != null)
                            GestureDetector(
                              onTap: () => widget.onPressedExcluirFoto!(index),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: white,
                                  ),
                                  TextWidget(
                                    "Excluir",
                                    textColor: white,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class FotoPdfWidget extends StatelessWidget {
  final Function(int)? onPressedSubstituirFoto;
  final Function()? onPressedAdicionarFoto;
  final Widget conteudo;
  final int index;
  final bool solicitacao;
  const FotoPdfWidget({
    super.key,
    this.onPressedSubstituirFoto,
    required this.onPressedAdicionarFoto,
    required this.conteudo,
    required this.index,
    this.solicitacao = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: conteudo,
        ),
        Row(
          children: [
            // Visibility(
            //   visible: onPressedSubstituirFoto != null,
            //   child: Expanded(
            //     child: CameraButtonWidget(
            //       solicitacao: solicitacao,
            //       textoBotao: "SUBSTITUIR ARQUIVO",
            //       onPressed: () async {
            //         context.pop(await onPressedSubstituirFoto?.call(index));
            //       },
            //     ),
            //   ),
            // ),
            Visibility(
              visible: onPressedAdicionarFoto != null,
              child: Expanded(
                child: CameraButtonWidget(
                  solicitacao: solicitacao,
                  textoBotao: "ADICIONAR ARQUIVO",
                  onPressed: () async {
                    context.pop(await onPressedAdicionarFoto?.call());
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CameraButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final String textoBotao;
  final bool solicitacao;
  const CameraButtonWidget({super.key, this.onPressed, required this.textoBotao, this.solicitacao = false});

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      title: textoBotao,
      onPressed: onPressed,
    );
  }
}

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;
  final Color? color;
  const IconButtonWidget({super.key, required this.icon, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color ?? white, size: 4.w),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
