import 'package:flutter/material.dart';

class TColor {
  //static Color get primaryColor1 => const Color(0xff87CEFA);
  //static Color get primaryColor2 => const Color(0xffADD8E6);
  //static Color get secondaryColor1 => const Color(0xffB0E0E6);
  //static Color get secondaryColor2 => const Color(0xffB0C4DE);

  static Color get primaryColor1 => const Color.fromARGB(255, 201, 157, 245);
  static Color get primaryColor2 => const Color.fromARGB(255, 221, 199, 244);
  static Color get secondaryColor1 => const Color.fromARGB(255, 154, 122, 178);
  static Color get secondaryColor2 => const Color.fromARGB(255, 182, 126, 190);
  
  static Color get secondaryColor3 => const Color(0xffF5F5F5);

  static List<Color> get primaryG => [primaryColor2, primaryColor1];
  static List<Color> get secondaryG =>
      [secondaryColor1, secondaryColor2, secondaryColor3];

  static Color get black => Colors.black;
  static Color get grey => Colors.grey;
  static Color get white => Colors.white;
  static Color get lightGrey => const Color(0xffF7F8F8);
}
