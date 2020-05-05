import 'package:resourcehub/External/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:resourcehub/Globals.dart';
import 'package:resourcehub/Pages/Bookmarks.dart';
import 'package:resourcehub/Pages/HomePage.dart';
import 'package:resourcehub/Pages/PostResource.dart';
import 'package:resourcehub/Pages/Profile.dart';
import 'package:resourcehub/Pages/Settings.dart';

class Skeleton extends StatefulWidget {
  @override
  _SkeletonState createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  int _page = 0;

  List<Widget> _allPages = [
    HomePage(),
    Bookmarks(),
    PostResource(),
    Profile(),
    Settings()
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: _allPages[_page],
      bottomNavigationBar: FancyBottomNavigation(
      tabs: [
        TabData(iconData: Icons.home, title: "Home",),
        TabData(iconData: Icons.bookmark_border, title: "Bookmarks"),
        TabData(iconData: Icons.add_circle_outline, title: "Add"),
        TabData(iconData: Icons.face, title: "Profile"),
        TabData(iconData: Icons.settings, title: "Settings"),
      ],
        onTabChangedListener: (int index){
          setState(() {
            _page = index;
          });
        },
        textColor: Colors.blue,
        barBackgroundColor: Theme.of(context).bottomAppBarColor,
        inactiveIconColor: Colors.blue,
        activeIconColor: darkThemeEnabled?Colors.blue:Colors.white,
      ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
