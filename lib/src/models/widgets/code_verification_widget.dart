import 'package:componentes_lr/src/models/widgets/pin_number_field_widget.dart';
import 'package:componentes_lr/src/utils/utils/app_measurements.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeVerificationWidget extends StatefulWidget {
  /// Método disparado ao preencher o último campo ou colar um código, retornando o valor para o controller
  final void Function(String) codeSubmit;

  /// Método para zerar a variável do código dentro do controller quando apagar o último campo
  final void Function() codeDelete;

  /// Número de campos
  final int fieldsNumber;

  /// Cor de fundo dos campos
  final Color? fillColor;

  /// Cor da borda dos campos
  final Color borderColor;

  /// Width de cada campo
  final double fieldsWidth;

  const CodeVerificationWidget({
    super.key,
    required this.codeSubmit,
    required this.codeDelete,
    this.fieldsNumber = 0,
    required this.fieldsWidth,
    this.fillColor,
    required this.borderColor,
  });

  @override
  State<CodeVerificationWidget> createState() => _CodeVerificationWidgetState();
}

class _CodeVerificationWidgetState extends State<CodeVerificationWidget> {
  late List<FocusNode> focusList = List.empty();
  late List<TextEditingController> textControllerList = List.empty();

  @override
  void initState() {
    super.initState();
    //Inicia a lista de focusNode e textEditingController de acordo com a quantidade de campos
    focusList = [for (var i = 0; i < widget.fieldsNumber; i++) FocusNode()];
    textControllerList = [for (var i = 0; i < widget.fieldsNumber; i++) TextEditingController()];

    //Cria o comportamento de não focar um campo quando o anterior está vazio
    for (var i = 0; i < (widget.fieldsNumber); i++) {
      focusList[i].addListener(() {
        if (i != 0 && textControllerList[i - 1].text.isEmpty && textControllerList[i].text.isEmpty) {
          focusList[i - 1].requestFocus();
        }
        //Comportamento de não focar o campo caso o próximo esteja preenchido
        // else if (i != (focusList.length - 1) &&
        //     textControllerList[i + 1].text.isNotEmpty &&
        //     textControllerList[i].text.isNotEmpty) {
        //   focusList[i + 1].requestFocus();
        // }
      });
    }
  }

  //Método usado para colar valores a partir do primeiro campo
  void onPaste(String pasteValue) {
    final value = pasteValue.replaceAll('-', '');
    //Só funcionará se o código colado tiver a quantidade exata de caracteres do número de campos
    if (value.length == widget.fieldsNumber) {
      for (var i = 0; i < widget.fieldsNumber; i++) {
        textControllerList[i].text = value[i];
      }
      if (textControllerList.last.text.isNotEmpty) {
        FocusManager.instance.primaryFocus?.unfocus();
        widget.codeSubmit(textControllerList.map((e) => e.text).join());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 3.w,
      runSpacing: 1.h,
      children: List<Widget>.generate(
        widget.fieldsNumber,
        (index) => Focus(
          onKeyEvent: (node, event) {
            //Validação de backspace pra quando o campo estiver vazio e quiser voltar para o anterior
            if (event.logicalKey == LogicalKeyboardKey.backspace && textControllerList[index].text.isEmpty) {
              if (index == 0) {
                FocusManager.instance.primaryFocus?.unfocus();
              } else {
                focusList[index - 1].requestFocus();
              }
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: PinNumberFieldWidget(
            width: widget.fieldsWidth,
            fieldsNumber: widget.fieldsNumber,
            onPaste: index == 0 ? onPaste : (p0) {},
            textController: textControllerList[index],
            focusNode: focusList[index],
            fillColor: widget.fillColor,
            borderColor: widget.borderColor,
            onChanged: (value) {
              //Validações para avançar de campo ao preencher, ou retornar ao apagar
              if (value.isNotEmpty) {
                if (index != (focusList.length - 1)) {
                  focusList[index + 1].requestFocus();
                } else {
                  FocusManager.instance.primaryFocus?.unfocus();
                  widget.codeSubmit(textControllerList.map((e) => e.text).join());
                }
              } else if (index != 0) {
                if (index == (focusList.length - 1)) widget.codeDelete();
                focusList[index - 1].requestFocus();
              } else {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
          ),
        ),
      ).toList(),
    );
  }
}
