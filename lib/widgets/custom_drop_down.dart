// import 'package:flutter/material.dart';
// import 'package:flutter_demo/theme/theme_helper.dart';

// class CustomDropDown extends StatelessWidget {
//   const CustomDropDown({
//     Key? key,
//     this.alignment,
//     this.width,
//     this.margin,
//     this.focusNode,
//     this.icon,
//     this.autofocus = true,
//     this.textStyle,
//     this.items,
//     this.hintText,
//     this.hintStyle,
//     this.prefix,
//     this.prefixConstraints,
//     this.suffix,
//     this.suffixConstraints,
//     this.fillColor,
//     this.filled = false,
//     this.contentPadding,
//     this.defaultBorderDecoration,
//     this.enabledBorderDecoration,
//     this.focusedBorderDecoration,
//     this.disabledBorderDecoration,
//     this.validator,
//     this.onChanged,
//   }) : super(
//           key: key,
//         );

//   final Alignment? alignment;

//   final double? width;

//   final EdgeInsetsGeometry? margin;

//   final FocusNode? focusNode;

//   final Widget? icon;

//   final bool? autofocus;

//   final TextStyle? textStyle;

//   final List<SelectionPopupModel>? items;

//   final String? hintText;

//   final TextStyle? hintStyle;

//   final Widget? prefix;

//   final BoxConstraints? prefixConstraints;

//   final Widget? suffix;

//   final BoxConstraints? suffixConstraints;

//   final Color? fillColor;

//   final bool? filled;

//   final EdgeInsets? contentPadding;

//   final InputBorder? defaultBorderDecoration;

//   final InputBorder? enabledBorderDecoration;

//   final InputBorder? focusedBorderDecoration;

//   final InputBorder? disabledBorderDecoration;

//   final FormFieldValidator<SelectionPopupModel>? validator;

//   final Function(SelectionPopupModel)? onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return alignment != null
//         ? Align(
//             alignment: alignment ?? Alignment.center,
//             child: dropDownWidget,
//           )
//         : dropDownWidget;
//   }

//   Widget get dropDownWidget => Container(
//         width: width ?? double.maxFinite,
//         margin: margin,
//         child: DropdownButtonFormField<SelectionPopupModel>(
//           focusNode: focusNode ?? FocusNode(),
//           icon: icon,
//           autofocus: autofocus!,
//           style: textStyle,
//           items: items?.map((SelectionPopupModel item) {
//             return DropdownMenuItem<SelectionPopupModel>(
//               value: item,
//               child: Text(
//                 item.title,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             );
//           }).toList(),
//           decoration: decoration,
//           validator: validator,
//           onChanged: (value) {
//             onChanged!(value!);
//           },
//         ),
//       );
//   InputDecoration get decoration => InputDecoration(
//         hintText: hintText ?? "",
//         hintStyle: hintStyle,
//         prefixIcon: prefix,
//         prefixIconConstraints: prefixConstraints,
//         suffixIcon: suffix,
//         suffixIconConstraints: suffixConstraints,
//         fillColor: fillColor,
//         filled: filled,
//         isDense: true,
//         contentPadding: contentPadding,
//         border: defaultBorderDecoration ??
//             UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: theme.colorScheme.primary,
//               ),
//             ),
//         enabledBorder: enabledBorderDecoration ??
//             UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: theme.colorScheme.primary,
//               ),
//             ),
//         focusedBorder: focusedBorderDecoration ??
//             UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: theme.colorScheme.primary,
//               ),
//             ),
//         disabledBorder: disabledBorderDecoration ??
//             UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: theme.colorScheme.primary,
//               ),
//             ),
//       );
// }

// /// Extension on [CustomDropDown] to facilitate inclusion of all types of border style etc
// extension DropDownStyleHelper on CustomDropDown {
//   static UnderlineInputBorder get underLineBluegray10001 =>
//       UnderlineInputBorder(
//         borderSide: BorderSide(
//           color: appTheme.blueGray10001,
//         ),
//       );
// }
