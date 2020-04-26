import 'dart:async';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget{

  MyWebView({
    @required this.title,
    @required this.selectedUrl,
  });

  final String title;
  final String selectedUrl;

  @override
  MyWebViewState createState() => MyWebViewState(title: title,selectedUrl: selectedUrl);
}

class MyWebViewState extends State<MyWebView> {
  String title;
  String selectedUrl;
  bool isLoading;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
      
  MyWebViewState({
    @required this.title,
    @required this.selectedUrl,
  });

  initState() {
    super.initState();
    isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: selectedUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onPageFinished: (_) {
              setState(() {
                isLoading = false;
              });
            },
            ),
            isLoading ? Center( child: CircularProgressIndicator()) : Container(),
          ],
        ));
  }
}