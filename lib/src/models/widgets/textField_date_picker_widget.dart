import 'package:componentes_lr/src/models/widgets/export_widgets.dart';
import 'package:componentes_lr/src/utils/utils/formatters.dart';
import 'package:flutter/material.dart';

class TextFieldDatePickerWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String internaLabel;
  final String? Function(String?)? validator;
  final bool dateTime;
  final String externalLabel;
  final void Function() onChanged;
  final void Function()? onTap;
  final bool mandatory;
  final double? textSize;
  final double? hintFontSize;
  final double? externalLabelFontSize;
  final double? borderRadius;
  const TextFieldDatePickerWidget({
    super.key,
    required this.controller,
    required this.internaLabel,
    this.validator,
    required this.dateTime,
    required this.externalLabel,
    required this.onChanged,
    required this.mandatory,
    required this.focusNode,
    this.onTap,
    this.textSize,
    this.borderRadius,
    this.hintFontSize,
    this.externalLabelFontSize,
  });

  DateTime? get selectedDate => controller.text.isEmpty
      ? null
      : fromStringToDateTimePtBr(controller.text, dateTime);

  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      controller: controller,
      readOnly: true,
      mandatory: mandatory,
      suffixIcon: Icons.calendar_today,
      externalLabel: externalLabel,
      validator: validator,
      focusNode: focusNode,
      onTap: onTap ?? () => onTapDate(context),
      internalLabel: internaLabel,
      textSize: textSize,
      hintFontSize: hintFontSize,
      externalLabelFontSize: externalLabelFontSize,
      borderRadius: borderRadius,
      labelInterno: '',
    );
  }

  Future<void> onTapDate(BuildContext context) async {
    final data = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (data != null) {
      controller.text = fromDateTimeToStringPtBr(data, false);
    }
  }
}
