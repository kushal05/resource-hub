import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:resourcehub/Pages/Bookmarks.dart';
import 'package:resourcehub/Pages/HomePage.dart';
import 'package:resourcehub/Pages/PostResource.dart';
import 'package:resourcehub/Pages/Profile.dart';
import 'package:resourcehub/Pages/Settings.dart';
import 'ReusableWidgets.dart';

class Skeleton extends StatefulWidget {
  @override
  _SkeletonState createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  int _page = 0;
  CircularBottomNavigationController _navigationController = new CircularBottomNavigationController(0);

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
      bottomNavigationBar: CircularBottomNavigation(
        tabItems,
        controller: _navigationController,
        selectedCallback: (int index){
          setState(() {
            _page = index;
          });
        },
        circleSize: 55,
        iconsSize: 25
      ),
      ),
    );
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }
}
