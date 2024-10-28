// ignore_for_file: use_build_context_synchronously

import 'package:componentes_lr/src/models/widgets/bottom_sheet_popup.dart';
import 'package:componentes_lr/src/models/widgets/export_widgets.dart';
import 'package:componentes_lr/src/utils/utils/icontext.dart';
import 'package:flutter/widgets.dart';

Future<bool> validatePassword(BuildContext context) async {
  try {
    final controllerText = TextEditingController();
    bool result = false;
    await openDefaultPopUp(
      context,
      tituloConfirmar: "CONTINUAR",
      titulo: "Digite a senha",
      children: [
        TextFieldWidget(
          controller: controllerText,
          internalLabel: "Digite a senha",
          labelInterno: '',
        ),
      ],
      onTapBotaoConfirmar: () async {
        final dia = DateTime.now().day;
        final mes = DateTime.now().month;
        final ano = DateTime.now().year;
        final resultado = ((dia * mes) - ano) * -1;
        if (controllerText.text == resultado.toString()) {
          result = true;
        }
        //context.voltar();
      },
    );
    return result;
  } catch (e) {
    return false;
  }
}

Future<void> openPopupDatabaseOptions(
  BuildContext context,
  OpcoesFuncao opcao,
  IContext databaseContext,
  void Function()? onTapBotaoConfirmar,
  String urlAPI,
) async {
  final controllerTextURL = TextEditingController(text: urlAPI);
  final senhaValida = await validatePassword(context);
  if (!senhaValida)
    erroPopUp(context, "Senha inválida", null,
        onTapBotaoConfirmar: onTapBotaoConfirmar);
  switch (opcao) {
    case OpcoesFuncao.exportarBanco:
      final result = await databaseContext.exportDatabase(context);
      if (result) {
        await openDefaultPopUp(
          context,
          tituloConfirmar: "OK",
          titulo: "Aviso!",
          descricao: "Banco exportado com sucesso!",
          onTapBotaoConfirmar: () => onTapBotaoConfirmar,
        );
        Navigator.pop(context);
      } else {
        await openDefaultPopUp(
          context,
          tituloConfirmar: "OK",
          titulo: "Aviso!",
          descricao: "Problema ao exportar banco, tenten novamente",
          onTapBotaoConfirmar: () => onTapBotaoConfirmar,
        );
      }
    case OpcoesFuncao.limparBanco:
      final result = await databaseContext.deleteDb();
      if (result) {
        await openDefaultPopUp(
          context,
          tituloConfirmar: "OK",
          titulo: "Aviso!",
          descricao: "Banco limpo com sucesso!",
          onTapBotaoConfirmar: () => onTapBotaoConfirmar,
        );
        //Navigator.pop(context);
      }
    case OpcoesFuncao.trocarUrl:
      final formKey = GlobalKey<FormState>();
      await openDefaultPopUp(
        context,
        tituloConfirmar: 'SALVAR',
        titulo: 'URL',
        children: [
          Form(
            key: formKey,
            child: TextFieldWidget(
              controller: controllerTextURL,
              internalLabel: "",
              validator: (value) =>
                  Uri.parse(value!).isAbsolute ? null : "URL inválida",
              labelInterno: '',
            ),
          ),
        ],
        onTapBotaoConfirmar: () async {
          //urlAPI = controllerTextURL.text;
          await openDefaultPopUp(
            context,
            tituloConfirmar: 'OK',
            titulo: "Aviso!",
            descricao: "URL alterada com sucesso!",
            onTapBotaoConfirmar: () => onTapBotaoConfirmar,
          );
        },
      );
    //Navigator.pop(context);
    default:
      throw Exception("Erro ai escolher opção, retornou null");
  }
}

enum OpcoesFuncao {
  exportarBanco("Exportar Banco"),
  limparBanco("Limpar Banco"),
  trocarUrl("Trocar URL");

  final String nome;

  const OpcoesFuncao(this.nome);
}
