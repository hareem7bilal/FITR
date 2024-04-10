import 'package:flutter/material.dart';
import '../utils/color_extension.dart';

class SettingRow extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onPressed;

  const SettingRow({super.key, required this.icon, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: 30,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Image.asset(
            icon,
            width: 15,
            height: 15,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 25),
          Expanded(
            child: Text(title,
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 12,
                )),
          ),
          Image.asset(
            "assets/images/icons/next.png",
            width: 12,
            height: 12,
            fit: BoxFit.contain,
          ),
        ]),
      ),
    );
  }
}
