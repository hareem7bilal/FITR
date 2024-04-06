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
  final bool readOnly; // Add this
  final VoidCallback? onTap; // Add this

  const RoundTextField({
    super.key,
    this.controller,
    this.keyboardType,
    required this.hintText,
    required this.icon,
    this.margin,
    this.obscureText = false,
    this.rightIcon,
    this.onChanged,
    this.readOnly = false, // Initialize here
    this.onTap, // Initialize here
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: readOnly ? onTap : null, // Use onTap here if readOnly is true
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: TColor.lightGrey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          readOnly: readOnly, // Use readOnly here
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
              ),
            ),
            hintStyle: TextStyle(color: TColor.grey, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
