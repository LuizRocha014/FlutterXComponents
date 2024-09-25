import 'dart:async';
import 'package:componentes_lr/src/models/widgets/export_widgets.dart';
import 'package:componentes_lr/src/utils/utils/app_measurements.dart';
import 'package:componentes_lr/src/utils/utils/colors.dart';
import 'package:componentes_lr/src/utils/utils/font_sizes.dart';
import 'package:flutter/material.dart';

Future<void> openDefaultPopUp(
  BuildContext context, {
  String? tituloVoltar,
  required String? tituloConfirmar,
  String? titulo,
  String? descricao,
  Color? corBotaoConfirmar,
  Color? corBotaoVoltar,
  List<Widget> children = const [],
  void Function()? onTapBotaoConfirmar,
  void Function()? onTapBotaoCancelar,
  bool isDismissible = true,
  String? iconAssets,
}) async {
  await showModalBottomSheet(
    isDismissible: isDismissible,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: BottomSheetPopup(
        titulo: titulo,
        descricao: descricao,
        tituloBotaoConfirmar: tituloConfirmar,
        tituloBotaoVoltar: tituloVoltar,
        corBotaoConfirmar: corBotaoConfirmar,
        onTapBotaoCancelar: onTapBotaoCancelar,
        onTapBotaoConfirmar: onTapBotaoConfirmar,
        imageAssets: iconAssets,
        children: children,
        isDismissible: isDismissible,
      ),
    ),
  );
}

class BottomSheetPopup extends StatelessWidget {
  final List<Widget> children;
  final String? titulo;
  final String? descricao;
  final String? tituloBotaoConfirmar;
  final String? tituloBotaoVoltar;
  final Color? corBotaoConfirmar;
  final Color? corBotaoVoltar;
  final bool isDismissible;
  final FutureOr<void> Function()? onTapBotaoConfirmar;
  final FutureOr<void> Function()? onTapBotaoCancelar;
  final String? imageAssets;
  const BottomSheetPopup({
    super.key,
    this.titulo,
    this.children = const [],
    this.tituloBotaoVoltar,
    required this.tituloBotaoConfirmar,
    this.onTapBotaoConfirmar,
    this.onTapBotaoCancelar,
    this.descricao,
    this.corBotaoConfirmar,
    this.corBotaoVoltar,
    this.isDismissible = false,
    this.imageAssets,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isDismissible,
      child: SafeArea(
        // bottom: Platform.isAndroid,
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.w),
              topRight: Radius.circular(5.w),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imageAssets != null)
                  Padding(
                    padding: EdgeInsets.only(top: 3.h),
                    child: SizedBox(
                      height: 10.h,
                      width: 20.w,
                      child: ImageAsset(
                        imageAssets!,
                        height: 1.h,
                        width: 1.w,
                      ),
                    ),
                  ),
                if (titulo != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    child: TextWidget(
                      titulo,
                      textAlign: TextAlign.center,
                      fontSize: mediumLargeFont,
                      fontWeight: FontWeight.bold,
                      maxLines: 2,
                    ),
                  ),
                if (descricao != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: TextWidget(
                      descricao,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                      textColor: black,
                      maxLines: 3,
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    children: [
                      if (tituloBotaoVoltar != null)
                        InvertButtonWidget(title: tituloBotaoVoltar!, onPressed: onTapBotaoCancelar),
                      if (tituloBotaoConfirmar != null)
                        ButtonWidget(
                          title: tituloBotaoConfirmar,
                          color: corBotaoConfirmar,
                          fontColor: white,
                          fontSize: mediumFont,
                          onPressed: onTapBotaoConfirmar,
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
