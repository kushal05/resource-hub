import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:resourcehub/Pages/MyResources.dart';
import '../Globals.dart';
import 'WebViewPage.dart';
import 'dart:async';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  initState(){
    super.initState();
    debugPrint("##### Init state called");
    getPosts();
  }

  void getPosts(){
    Firestore.instance.collection('Posts').getDocuments().then((doc){

      posts = [];
      var temp = doc.documents;

      for(var p in temp){
        posts.add({
          'Title':p.data['Title'],
          'Link':p.data['Link'],
          'Description':p.data['Description'],
          'Username':p.data['Username'],
          'UserID':p.data['UserID'],
          'Tags':p.data['Tags'],
          'Likes':p.data['Likes'],
          'Timestamp':DateTime.parse(p.data['Timestamp'].toDate().toString()),
        });
      }
      posts.sort((a,b) {
        var adate = a['Timestamp'].millisecondsSinceEpoch;
        var bdate = b['Timestamp'].millisecondsSinceEpoch;
        return -1*int.parse(adate.compareTo(bdate).toString());
      });
      setState(() {
        postsLength=doc.documents.length;
        debugPrint("getPosts called");
      });
    });
  }

  ScrollController _controller = ScrollController();
  var localPosts;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Resource Hub"),
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
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 200,
                      color: Colors.blueAccent,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      color: Colors.black12,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Resource ${index + 1}"),
                                      )),
                                ));
                          }),
                    ),
                  ),
                  Expanded(
                      flex: 10,
                      child: Container(
                          color: Colors.blue[100],
                          child:LiquidPullToRefresh(
                              onRefresh: (){
                                return Future<void>((){
                                  posts=null;
                                  getPosts();
                                });
                              },
                              child:(posts==null)?ListView(children:[Center(child:Text("Loading.."))]):ListView.builder(
                                itemCount:postsLength,
                                controller: _controller,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0)),
                                      elevation: 2,
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${posts[index]['Title']}",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: RichText(
                                                  text:TextSpan(
                                                    text: "${posts[index]['Link']}",
                                                    style: new TextStyle(color: Colors.blue),
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (BuildContext context) => MyWebView(
                                                              title: "${posts[index]['Title']}",
                                                              selectedUrl: "${posts[index]['Link']}",
                                                            )));
                                                      },
                                                  )
                                              )
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Container(
                                                child: Text("#${posts[index]['Tags'][0]}"),
//                                            child: Container(),                                            // child: ListView.builder(
                                                //   scrollDirection: Axis.horizontal,
                                                //   itemCount: snapshot.data.documents[index]['Tags'].length,
                                                //   itemBuilder: (context,ind){
                                                //     debugPrint("#${snapshot.data.documents[index]['Tags'][ind]}");
                                                //     return Text("#${snapshot.data.documents[index]['Tags'][ind]}");
                                                //   }
                                                // )
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              MaterialButton(
                                                onPressed: () {},
                                                child: Text("Kudos"),
                                              ),
                                              MaterialButton(
                                                onPressed: () {},
                                                child: Text("Comment"),
                                              ),
                                              MaterialButton(
                                                onPressed: () {},
                                                child: Text("Share"),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                          )
                      )
                  ),
                ]
            ),
            MyResources()
          ],
        ),
      ),
    );
  }
}