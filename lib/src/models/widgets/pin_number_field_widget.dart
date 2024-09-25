import 'package:componentes_lr/src/utils/utils/app_measurements.dart';
import 'package:componentes_lr/src/utils/utils/colors.dart';
import 'package:componentes_lr/src/utils/utils/font_sizes.dart';
import 'package:componentes_lr/src/utils/utils/masks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinNumberFieldWidget extends StatelessWidget {
  final int fieldsNumber;
  final Color? fillColor;
  final Color borderColor;
  final double width;
  final FocusNode? focusNode;
  final TextEditingController textController;
  final void Function(String)? onPaste;
  final void Function(String)? onChanged;

  const PinNumberFieldWidget({
    super.key,
    this.focusNode,
    this.onChanged,
    this.onPaste,
    required this.textController,
    required this.fieldsNumber,
    required this.width,
    this.fillColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        contextMenuBuilder: (context, editableTextState) {
          return AdaptiveTextSelectionToolbar.editable(
            clipboardStatus: ClipboardStatus.pasteable,
            onCopy: () => editableTextState.copySelection(SelectionChangedCause.toolbar),
            onCut: () => editableTextState.cutSelection(SelectionChangedCause.toolbar),
            onPaste: () {
              Clipboard.getData('text/plain').then((value) {
                if (value != null && value.text != null) {
                  onPaste!(value.text!);
                }
              });
            },
            onSelectAll: null,
            onLookUp: null,
            onSearchWeb: null,
            onShare: null,
            onLiveTextInput: null,
            anchors: editableTextState.contextMenuAnchors,
          );
        },
        onTap: () {
          if (textController.selection == TextSelection.fromPosition(TextPosition(offset: textController.text.length - 1))) {
            textController.selection = TextSelection.fromPosition(TextPosition(offset: textController.text.length));
          }
        },
        showCursor: true,
        enableInteractiveSelection: true,
        controller: textController,
        onSaved: (newValue) {},
        onChanged: onChanged,
        textInputAction: TextInputAction.next,
        focusNode: focusNode,
        inputFormatters: [CodeValidatorMask(), FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: lightGray),
            borderRadius: BorderRadius.circular(2.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(2.w),
          ),
          fillColor: fillColor ?? white,
          filled: true,
        ),
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: black,
          fontSize: veryLargeFont,
          fontWeight: FontWeight.bold,
          fontFamily: "SegoeUI",
        ),
      ),
    );
  }
}
