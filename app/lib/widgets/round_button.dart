import 'package:flutter/material.dart';
import '../utils/color_extension.dart';

enum RoundButtonType { bgGradient, bgSGradient, textGradient }

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final RoundButtonType type;
  final double elevation;

  const RoundButton(
      {super.key,
      this.type = RoundButtonType.bgGradient,
      required this.title,
      required this.onPressed,
      int? fontSize,
      FontWeight? fontWeight,
      this.elevation = 0.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: type == RoundButtonType.bgSGradient
                ? TColor.secondaryG
                : TColor.primaryG,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(25),
        boxShadow: type == RoundButtonType.bgGradient ||
                type == RoundButtonType.bgSGradient
            ? const [
                BoxShadow(
                    color: Color.fromARGB(66, 55, 71, 93),
                    blurRadius: 0.5,
                    offset: Offset(0, 0.5))
              ]
            : null,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        height: 50,
        color: type == RoundButtonType.bgGradient
            ? Colors.transparent
            : TColor.white,
        //elevation: type == RoundButtonType.bgGradient || type == RoundButtonType.bgSGradient ? 0: 1,
        minWidth: double.maxFinite,
        child: type == RoundButtonType.bgGradient ||
                type == RoundButtonType.bgSGradient
            ? Text(title,
                style: TextStyle(
                  color: TColor.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ))
            : ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  return LinearGradient(
                          colors: TColor.primaryG,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight)
                      .createShader(
                          Rect.fromLTRB(0, 0, bounds.width, bounds.height));
                },
                child: Text(title,
                    style: TextStyle(
                      color: TColor.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ))),
      ),
    );
  }
}
