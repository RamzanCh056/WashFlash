import 'package:flutter/material.dart';

import '../utils/color.dart';

class ReusableTextForm extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Color filledColor;
  final String? hintText;
  final bool? obscureText;
  final bool? enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int maxLines;

  const ReusableTextForm({
    Key? key,
    this.validator,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.prefixIcon,  this.filledColor = AppColor.lightGreyColor, this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText!,
        minLines: 1,
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: filledColor,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          enabled: enabled!,
          hintText: hintText,
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        // validations
        validator: validator);
  }
}
