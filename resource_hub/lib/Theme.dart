import 'package:flutter/material.dart';

class Fonts {
  static String get body => "Lato";
  static String get title => "Roboto";
}

class FontSizes {
  static double scale = 1;

  static double get body => 14 * scale;
  static double get bodySm => 12 * scale;

  static double get title => 16 * scale;
}

class TextStyles {
  static TextStyle get bodyFont => TextStyle(fontFamily: Fonts.body);
  static TextStyle get titleFont => TextStyle(fontFamily: Fonts.title);

  static TextStyle get title => titleFont.copyWith(fontSize: FontSizes.title);
  static TextStyle get titleLight => title.copyWith(fontWeight: FontWeight.w300);
  static TextStyle get titleBold => title.copyWith(fontWeight: FontWeight.w700);

  static TextStyle get body => bodyFont.copyWith(fontSize: FontSizes.body, fontWeight: FontWeight.w300);
  static TextStyle get bodySm => body.copyWith(fontSize: FontSizes.bodySm);
  static TextStyle get bodySmBold => bodySm.copyWith(fontWeight: FontWeight.w700);
}

ThemeData lightMode(){
  return ThemeData(
      unselectedWidgetColor: Color.fromRGBO(189, 226, 252, 1),
      canvasColor: Color.fromRGBO(162, 208, 242, 1),
      bottomAppBarColor: Colors.white,
      cardColor: Colors.white,
      textSelectionColor: Colors.blue
  );
}

ThemeData darkMode(){
  return ThemeData(
      primaryColor:  Color.fromRGBO(31, 41, 56, 1),
      unselectedWidgetColor: Colors.white30,
      canvasColor:Color.fromRGBO(84, 93, 107, 1),
      bottomAppBarColor: Color.fromRGBO(31, 41, 56, 1),
      cardColor: Color.fromRGBO(189, 202, 222, 1),
      textSelectionColor: Colors.white
  );
}