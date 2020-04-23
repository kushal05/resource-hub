import 'package:flutter/material.dart';

class PostResource extends StatefulWidget {
  @override
  _PostResourceState createState() => _PostResourceState();
}

class _PostResourceState extends State<PostResource> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post your resource"),
      ),
      body: Center(
        child: Container(
          child: Text("Post Resources"),
        ),
      ),
    );
  }
}
