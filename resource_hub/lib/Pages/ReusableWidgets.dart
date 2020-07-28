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

Widget errorAlertDialog(String title, String content, BuildContext context) {
  return new AlertDialog(
    elevation: 20.0,
    title: Text(title, style: TextStyle(color: Colors.red)),
    content: Text(content),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    contentPadding: EdgeInsets.only(bottom: 0.0, left: 25.0, right: 20.0, top: 10.0),
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Colors.red,
        child: const Text('Okay, got it!'),
      ),
    ],
  );
}

List<TabData> fancyTabItems = [
  TabData(iconData: Icons.home, title: "Home"),
  TabData(iconData: Icons.bookmark, title: "Bookmarks"),
  TabData(iconData: Icons.add_circle_outline, title: "Add"),
  TabData(iconData: Icons.face, title: "Profile"),
  TabData(iconData: Icons.settings, title: "Settings"),
];