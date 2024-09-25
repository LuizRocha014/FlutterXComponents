import 'package:componentes_lr/src/models/widgets/export_widgets.dart';
import 'package:componentes_lr/src/utils/utils/app_measurements.dart';
import 'package:componentes_lr/src/utils/utils/colors.dart';
import 'package:componentes_lr/src/utils/utils/font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? externalLabel;
  final String internalLabel;
  final dynamic prefixIcon;
  final dynamic suffixIcon;
  final IconData? externalLeftIcon;
  final bool obscureText;
  final bool? readOnly;
  final bool hasBorder;
  final void Function()? onTapSuffixIcon;
  final void Function()? onTap;
  final Color? color;
  final Color? iconColor;
  final Color? textColor;
  final double? borderRadius;
  final Color? externalLabelColor;
  final Color? hintTextColor;
  final double? hintFontSize;
  final FontWeight? hintFontWeight;
  final FontWeight? externalLabelFontWeight;
  final double? externalLabelFontSize;
  final int? maxLines;
  final String? externalLabelIcon;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final void Function(String)? onChanged;
  final bool login;
  final bool? enabled;
  final bool mandatory;
  final Color? borderColor;
  final Color? externalLeftIconColor;
  final double? bottomPadding;
  final FocusNode? focusNode;
  final void Function(String value)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final int? maxLinesExternalLabel;
  final String? labelText;
  final String? suffixText;
  final Function(PointerDownEvent)? onTapOutside;
  final Function()? onEditingComplete;
  final double? textSize;

  const TextFieldWidget({
    super.key,
    required this.controller,
    this.externalLabel,
    required this.internalLabel,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.onTapSuffixIcon,
    this.color,
    this.iconColor,
    this.textColor,
    this.borderRadius,
    this.externalLabelColor,
    this.hintTextColor,
    this.hasBorder = true,
    this.hintFontSize,
    this.hintFontWeight,
    this.externalLabelFontWeight,
    this.externalLabelFontSize,
    this.maxLines = 1,
    this.externalLabelIcon,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.keyboardType,
    this.readOnly,
    this.onTap,
    this.inputFormatters,
    this.maxLength,
    this.onChanged,
    this.login = false,
    this.enabled,
    this.mandatory = false,
    this.borderColor,
    this.bottomPadding,
    this.externalLeftIcon,
    this.externalLeftIconColor,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
    this.maxLinesExternalLabel,
    this.labelText,
    this.suffixText,
    this.onTapOutside,
    this.onEditingComplete,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding ?? 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (externalLabel != null)
              Padding(
                padding: EdgeInsets.only(bottom: 0.5.h, left: 1.w),
                child: Row(
                  children: [
                    if (externalLabelIcon != null)
                      Padding(
                        padding: EdgeInsets.only(right: 1.w),
                        child: ImageAsset(
                          externalLabelIcon!,
                          height: isMobile ? 4.w : 2.5.w,
                        ),
                      ),
                    SizedBox(
                      width: 85.w,
                      child: TextWidget(
                        externalLabel,
                        overflow: TextOverflow.visible,
                        fontSize: externalLabelFontSize,
                        textColor: externalLabelColor ?? Colors.grey[300],
                        fontWeight: externalLabelFontWeight ?? FontWeight.w400,
                        maxLines: maxLinesExternalLabel,
                      ),
                    ),
                    TextWidget(mandatory ? " *" : null, fontSize: externalLabelFontSize, textColor: Colors.red),
                  ],
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (externalLeftIcon != null) ...[
                  Icon(
                    externalLeftIcon,
                    color: externalLeftIconColor ?? black,
                    size: 4.h,
                  ),
                  SizedBox(width: 2.w),
                ],
                Expanded(
                  child: Opacity(
                    opacity: enabled == false ? 0.65 : 1.0,
                    child: TextFormField(
                      onTapOutside: onTapOutside,
                      onEditingComplete: onEditingComplete,
                      controller: controller,
                      obscureText: obscureText,
                      enabled: enabled,
                      maxLines: maxLines,
                      maxLength: maxLength,
                      focusNode: focusNode,
                      validator: validator,
                      keyboardType: keyboardType ?? TextInputType.text,
                      autovalidateMode: autovalidateMode,
                      readOnly: readOnly ?? false,
                      onTap: onTap,
                      textAlignVertical: TextAlignVertical.center,
                      inputFormatters: inputFormatters,
                      onFieldSubmitted: onFieldSubmitted,
                      textInputAction: textInputAction,
                      onChanged: onChanged,
                      style: TextStyle(
                        color: textColor ?? black,
                        fontSize: textSize ?? mediumFont,
                        fontWeight: FontWeight.normal,
                        fontFamily: "SegoeUI",
                      ),
                      decoration: InputDecoration(
                        hintText: internalLabel,

                        labelText: labelText,
                        helperText: " ",
                        suffixText: suffixText,
                        counterText: "",
                        errorMaxLines: 2,
                        prefixIcon: prefixIcon != null
                            ? prefixIcon is String
                                ? ImageAsset(prefixIcon as String, height: 2.5.h, width: 2.5.h)
                                : Icon(prefixIcon as IconData, size: 2.5.h, color: iconColor)
                            : null,
                        // prefixIcon == null ? null : ImageAsset(prefixIcon!, height: 2.h, width: 2.w, color: azulPrimario),
                        suffixIcon: suffixIcon != null
                            ? GestureDetector(
                                onTap: onTapSuffixIcon,
                                child: suffixIcon is String
                                    ? Padding(
                                        padding: EdgeInsets.all(1.5.h),
                                        child: ImageAsset(suffixIcon as String, height: 2.5.h, width: 2.5.w),
                                      )
                                    : Icon(suffixIcon as IconData, size: 2.5.h, color: iconColor),
                              )
                            : null,
                        hintStyle: TextStyle(
                          fontSize: hintFontSize ?? smallMediumFont,
                          fontWeight: hintFontWeight ?? FontWeight.normal,
                          fontFamily: "SegoeUI",
                          overflow: TextOverflow.ellipsis,
                          color: mediumGray,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: isMobile
                              ? (maxLines ?? 0) > 1
                                  ? 1.5.h
                                  : 0.5.h
                              : 1.5.h,
                        ),
                        enabledBorder: outlineInputBorder,
                        focusedBorder: outlineInputBorder,
                        border: outlineInputBorder,
                        errorBorder: outlineInputBorder,
                        disabledBorder: outlineInputBorder,
                        focusedErrorBorder: outlineInputBorder,
                        filled: true,
                        fillColor: color ?? white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputBorder get outlineInputBorder => login
      ? UnderlineInputBorder(
          borderSide: BorderSide(
            color: hasBorder
                ? enabled == true
                    ? (borderColor ?? black).withOpacity(0.65)
                    : borderColor ?? black
                : transparent,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 2.w),
        )
      : OutlineInputBorder(
          borderSide: BorderSide(
            color: hasBorder
                ? enabled == true
                    ? (borderColor ?? black).withOpacity(0.65)
                    : borderColor ?? black
                : transparent,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 2.w),
        );
}
