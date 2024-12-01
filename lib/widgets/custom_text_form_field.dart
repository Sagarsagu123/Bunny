import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/theme/theme_helper.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    this.alignment,
    this.width,
    this.margin,
    this.controller,
    this.focusNode,
    this.autofocus = true,
    this.textStyle,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.maxLength,
    this.inputFormatters,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.fillColor,
    this.filled = false,
    this.contentPadding,
    this.defaultBorderDecoration,
    this.enabledBorderDecoration,
    this.focusedBorderDecoration,
    this.disabledBorderDecoration,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.keyboardType,
    String? errorText,
  }) : super(
          key: key,
        );

  final Alignment? alignment;

  final double? width;

  final EdgeInsetsGeometry? margin;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final bool? obscureText;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final Color? fillColor;

  final bool? filled;

  final TextInputType? keyboardType;

  final EdgeInsets? contentPadding;

  final InputBorder? defaultBorderDecoration;

  final InputBorder? enabledBorderDecoration;

  final InputBorder? focusedBorderDecoration;

  final InputBorder? disabledBorderDecoration;

  final FormFieldValidator<String>? validator;

  final Function(String value)? onChanged;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onEditingComplete;
  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: textFormFieldWidget,
          )
        : textFormFieldWidget;
  }

  Widget get textFormFieldWidget => Container(
        width: width ?? double.maxFinite,
        margin: margin,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode ?? FocusNode(),
          autofocus: autofocus!,
          style: textStyle,
          obscureText: obscureText!,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          decoration: decoration,
          validator: validator,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
        ),
      );
  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle,
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        fillColor: fillColor,
        filled: filled,
        isDense: true,
        contentPadding: contentPadding,
        border: defaultBorderDecoration ??
            UnderlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.blueGray10001,
              ),
            ),
        enabledBorder: enabledBorderDecoration ??
            UnderlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.blueGray10001,
              ),
            ),
        focusedBorder: focusedBorderDecoration ??
            UnderlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.blueGray10001,
              ),
            ),
        disabledBorder: disabledBorderDecoration ??
            UnderlineInputBorder(
              borderSide: BorderSide(
                color: appTheme.blueGray10001,
              ),
            ),
      );
}

/// Extension on [CustomTextFormField] to facilitate inclusion of all types of border style etc
extension TextFormFieldStyleHelper on CustomTextFormField {
  static UnderlineInputBorder get underLinePrimary => UnderlineInputBorder(
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
        ),
      );
  static UnderlineInputBorder get underLineOnPrimaryContainer =>
      UnderlineInputBorder(
        borderSide: BorderSide(
          color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
        ),
      );
  static UnderlineInputBorder get underLineOnPrimaryContainer1 =>
      UnderlineInputBorder(
        borderSide: BorderSide(
          color: theme.colorScheme.onPrimaryContainer,
        ),
      );
}
