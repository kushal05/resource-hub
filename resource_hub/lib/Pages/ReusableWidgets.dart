import 'package:flutter/material.dart';

List<BottomNavigationBarItem> getBottomNavBar(int _page){
  return <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(Icons.home,
            color: (_page == 0) ? Colors.blueAccent : Colors.grey),
        title: SizedBox(height: 0.0),
//        title: Text("Home"),
        backgroundColor: Colors.white),
    BottomNavigationBarItem(
        icon: Icon(Icons.bookmark,
            color: (_page == 1) ? Colors.blueAccent : Colors.grey),
//        title: Container(height: 0.0),
        title: Text("Bookmarks", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add,
          color: (_page == 2) ? Colors.blueAccent : Colors.grey),
//        title: Container(height: 0.0),
      title: Text("Add"),
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.face,
            color: (_page == 3) ? Colors.blueAccent : Colors.grey),
//        title: Container(height: 0.0),
        title: Text("Profile"),
        backgroundColor: Colors.white),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings,
          color: (_page == 4) ? Colors.blueAccent : Colors.grey),
//        title: Container(height: 0.0),
      title: Text("Settings"),
    )
  ];
}