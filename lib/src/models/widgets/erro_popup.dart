import 'package:componentes_lr/src/models/widgets/export_widgets.dart';
import 'package:componentes_lr/src/utils/utils/routes.dart';
import 'package:flutter/widgets.dart';

Future<void> erroPopUp(BuildContext context, String mensagem, String? icon, {void Function()? onTapBotaoConfirmar}) async {
  return await openDefaultPopUp(
    context,
    tituloConfirmar: "OK",
    descricao: mensagem,
    titulo: "Atenção!",
    iconAssets: icon,
    onTapBotaoConfirmar: onTapBotaoConfirmar ?? () => context.pop(),
  );
}

Future<void> sucessPopUp(BuildContext context, String mensagem, {void Function()? onTapBotaoConfirmar}) async {
  return await openDefaultPopUp(
    context,
    tituloConfirmar: "Voltar",
    titulo: mensagem,
    onTapBotaoConfirmar: onTapBotaoConfirmar ?? () => context.pop(),
  );
}
