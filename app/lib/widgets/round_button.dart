import 'package:flutter/material.dart';
import '../utils/color_extension.dart';

enum RoundButtonType { bgGradient, textGradient }

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final RoundButtonType type;

  const RoundButton({
    super.key,
    this.type = RoundButtonType.bgGradient,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Key addition for testability
    final keySuffix = type == RoundButtonType.bgGradient ? 'BgGradient' : 'TextGradient';
    return Container(
      key: Key('roundButtonContainer$keySuffix'), // Unique key for Container
      decoration: BoxDecoration(
        gradient: type == RoundButtonType.bgGradient
            ? LinearGradient(colors: TColor.primaryG, begin: Alignment.centerLeft, end: Alignment.centerRight)
            : null, 
        borderRadius: BorderRadius.circular(25),
        boxShadow: type == RoundButtonType.bgGradient 
            ? const [BoxShadow(color: Color.fromARGB(66, 55, 71, 93), blurRadius: 0.5, offset: Offset(0, 0.5))]
            : null,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        height: 50,
        color: type == RoundButtonType.bgGradient ? Colors.transparent : TColor.white,
        elevation: type == RoundButtonType.bgGradient ? 0 : 1,
        minWidth: double.infinity,
        child: type == RoundButtonType.bgGradient 
            ? Text(title, style: TextStyle(color: TColor.white, fontSize: 16, fontWeight: FontWeight.w700))
            : ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => LinearGradient(colors: TColor.primaryG, begin: Alignment.centerLeft, end: Alignment.centerRight)
                    .createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height)),
                child: Text(title, key: Key('roundButtonText$keySuffix'), style: TextStyle(color: TColor.white, fontSize: 16, fontWeight: FontWeight.w700)),
              ),
      ),
    );
  }
}
