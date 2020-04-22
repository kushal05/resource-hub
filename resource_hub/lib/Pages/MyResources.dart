import 'package:flutter/material.dart';

class MyResources extends StatefulWidget {
  @override
  _MyResourcesState createState() => _MyResourcesState();
}

class _MyResourcesState extends State<MyResources> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("My Resources"),
        ),
      ),
    );
  }
}
