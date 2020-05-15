import 'package:flutter/material.dart';

var posts;
var postsLength;
var lastRefreshedTime;

var accentColor = Color(0xff42a5f5);

bool darkThemeEnabled = false;

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