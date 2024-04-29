import 'package:flutter/material.dart';

import 'package:flutter_application_1/utils/color_extension.dart';

class IconTitleNextRow extends StatelessWidget {
  final String icon;
  final TextEditingController? textEditingController;
  final String title;
  final String? time;
  final VoidCallback onPressed;
  final Color color;
  final FocusNode? focusNode;
  const IconTitleNextRow(
      {super.key,
      required this.icon,
      required this.title,
      this.time,
      required this.onPressed,
      required this.color,
      this.focusNode,
      this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              child: Image.asset(
                icon,
                width: 18,
                height: 18,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: TColor.grey, fontSize: 12),
              ),
            ),
            SizedBox(
              width: 120,
              child: time != null
                  ? Text(
                      time!,
                      textAlign: TextAlign.right,
                      style: TextStyle(color: TColor.grey, fontSize: 12),
                    )
                  : TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        hintText: 'Enter here',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: TColor.grey, fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 25,
              height: 25,
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/buttons/arrow_right.png",
                  width: 12,
                  height: 12,
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
