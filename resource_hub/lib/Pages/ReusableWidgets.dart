import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';

List<BottomNavigationBarItem> getBottomNavBar(int _page){
  return <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(Icons.home,
            color: (_page == 0) ? Colors.blueAccent : Colors.grey),
        title: Text("Home", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white),
    BottomNavigationBarItem(
        icon: Icon(Icons.bookmark,
            color: (_page == 1) ? Colors.blueAccent : Colors.grey),
//        title: Container(height: 0.0),
        title: Text("Bookmarks", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add,
          color: (_page == 2) ? Colors.blueAccent : Colors.grey),
//        title: Container(height: 0.0),
      title: Text("Add", style: TextStyle(color: Colors.black),),
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.face,
            color: (_page == 3) ? Colors.blueAccent : Colors.grey),
//        title: Container(height: 0.0),
        title: Text("Profile", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings,
          color: (_page == 4) ? Colors.blueAccent : Colors.grey),
//        title: Container(height: 0.0),
      title: Text("Settings", style: TextStyle(color: Colors.black),),
    )
  ];
}


//List<TabItem> tabItems = List.of([
//  new TabItem(Icons.home, "Home", Colors.blue, labelStyle: TextStyle(color: Colors.blue)),
//  new TabItem(Icons.bookmark, "Bookmarks", Colors.orange, labelStyle: TextStyle(color: Colors.orange)),
//  new TabItem(Icons.add_circle_outline, "Add", Colors.red, labelStyle: TextStyle(color: Colors.red)),
//  new TabItem(Icons.face, "Profile", Colors.cyan, labelStyle: TextStyle(color: Colors.cyan)),
//  new TabItem(Icons.settings, "Settings", Colors.green, labelStyle: TextStyle(color: Colors.green)),
//]);


List<TabData> fancyTabItems = [
  TabData(iconData: Icons.home, title: "Home"),
  TabData(iconData: Icons.bookmark, title: "Bookmarks"),
  TabData(iconData: Icons.add_circle_outline, title: "Add"),
  TabData(iconData: Icons.face, title: "Profile"),
  TabData(iconData: Icons.settings, title: "Settings"),
];