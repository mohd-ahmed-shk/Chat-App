import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  final String? hintText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final int? maxLength;
  final bool? readOnly;
  final bool? obscureText;
  final TextStyle? style;
  final Widget? suffixIcon;
  final InputDecoration? decoration;
  final EdgeInsetsGeometry? contentPadding;
  const AppTextField({super.key, this.hintText, this.controller, this.prefixIcon, this.suffixIcon, this.validator, this.keyboardType, this.textInputAction, this.inputFormatters, this.maxLength, this.contentPadding, this.readOnly, this.style, this.obscureText, this.decoration});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
        validator: validator,
        maxLength: maxLength,
        readOnly: readOnly ?? false,
        obscureText: obscureText ?? false,
        obscuringCharacter: '*',

        inputFormatters: inputFormatters,
        keyboardType: keyboardType ?? TextInputType.text,
        textInputAction: textInputAction ?? TextInputAction.next,
        style: style ?? TextStyle(fontSize: 15.sp,color: Colors.black),
        decoration: decoration ?? InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8).r,
              borderSide: BorderSide.none
            ),
            counterText: "",
            filled: true,
            fillColor: const Color(0xFF261C12).withOpacity(0.1),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,

            hintText: hintText,
            hintStyle: style ?? TextStyle(fontSize: 15.sp,color: Colors.grey.withOpacity(0.8)),
            contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 0,vertical: 15).r
        ),
      );
  }
}
