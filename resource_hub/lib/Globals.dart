import 'package:flutter/material.dart';

var posts;
var postsLength;

bool darkThemeEnabled = false;

ThemeData lightMode(){
  return ThemeData(
    unselectedWidgetColor: Color.fromRGBO(189, 226, 252, 1),
    canvasColor: Color.fromRGBO(162, 208, 242, 1),
    bottomAppBarColor: Colors.white,
    cardColor: Colors.white,
  );
}

ThemeData darkMode(){
  return ThemeData(
    primaryColor:  Color.fromRGBO(31, 41, 56, 1),
    unselectedWidgetColor: Colors.white30,
    canvasColor:Color.fromRGBO(84, 93, 107, 1),
    bottomAppBarColor: Color.fromRGBO(31, 41, 56, 1),
    cardColor: Color.fromRGBO(189, 202, 222, 1),
  );
}