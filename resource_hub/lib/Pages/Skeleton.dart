import 'package:flutter/material.dart';
import 'package:resourcehub/Pages/HomePage.dart';

import 'MyResources.dart';
import 'ReusableWidgets.dart';

class Skeleton extends StatefulWidget {
  @override
  _SkeletonState createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {

  int _page=0;

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Resource Hub'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Icon(Icons.settings),
            )
          ],
          bottom: TabBar(
            isScrollable: false,
            tabs: [
              Tab(text: "Home", ),
              Tab(text: "My Resources", )
            ],
        ),),
        body: TabBarView(
          children: <Widget>[
              HomePage(),
            MyResources()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        items: getBottomNavBar(_page),
      ),
      ),
    );
  }
}
