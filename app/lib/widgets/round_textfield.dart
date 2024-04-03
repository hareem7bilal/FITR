import 'package:flutter/material.dart';
import '../utils/color_extension.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String hintText;
  final String icon;
  final EdgeInsets? margin;
  final bool obscureText;
  final Widget? rightIcon;
  final ValueChanged<String>? onChanged;
  // final FormFieldValidator<String>? validator;

  const RoundTextField(
      {super.key,
      required this.hintText,
      this.controller,
      required this.icon,
      this.margin,
      this.keyboardType,
      this.obscureText = false, 
      this.rightIcon,
      // this.validator,
      this.onChanged,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin,
        decoration: BoxDecoration(
            color: TColor.lightGrey, borderRadius: BorderRadius.circular(15)),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: hintText,
            suffixIcon: rightIcon,
            prefixIcon: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                child: Image.asset(
                  icon,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  color: TColor.grey,
                )),
            hintStyle: TextStyle(color: TColor.grey, fontSize: 12),
            // validator: validator,

          ),
        ));
  }
}
