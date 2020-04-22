import 'package:flutter/material.dart';

class PostResource extends StatefulWidget {
  @override
  _PostResourceState createState() => _PostResourceState();
}

class _PostResourceState extends State<PostResource> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("POst Resources"),
        ),
      ),
    );
  }
}
