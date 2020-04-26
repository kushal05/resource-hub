import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:resourcehub/Pages/MyResources.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Globals.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ScrollController _controller = ScrollController();
  var localPosts;

  void showSnackBar(BuildContext context){
    var snackBar = SnackBar(
      content: Text("Resources have been updates!"),
      action: SnackBarAction(
        label: "Show updates",
        onPressed: (){
          _controller.jumpTo(0.0);
        },
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

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
                    color: Colors.greenAccent,
                    child: StreamBuilder(
                      stream: Firestore.instance.collection('Posts').orderBy('Timestamp', descending: true).snapshots(),
                      builder: (context,snapshot){
                        if(!snapshot.hasData){
                          return Center(child: Text("Loading..."));
                        }
                        else{
                          posts=snapshot.data.documents;
                          postsLength=snapshot.data.documents.length;

                          Timer.periodic(Duration(seconds: 5), (Timer t){
                            if(postsLength!=snapshot.data.documents.length){
                              postsLength=snapshot.data.documents.length;
                              showSnackBar(context);
                            }
                          });

                          return ListView.builder(
                            itemCount:snapshot.data.documents.length,
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
                                        child: Row(
                                          children: <Widget>[
                                            GestureDetector(
                                              behavior: HitTestBehavior.translucent,
                                              onTap: () {
                                                debugPrint("bookmared");
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(right: 20),
                                                child: Icon(Icons.star_border),
                                              )
                                            ),
                                            Text(
                                              "${snapshot.data.documents[index]['Title']}",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )

                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RichText(
                                            text:TextSpan(
                                            text: "${snapshot.data.documents[index]['Link']}",
                                            style: new TextStyle(color: Colors.blue),
                                             recognizer: TapGestureRecognizer()
                                               ..onTap = () { launch('${snapshot.data.documents[index]['Link']}');
                                             },
                                          )
                                        )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("#${snapshot.data.documents[index]['Tags'][0]}"),
                                        // child: ListView.builder(
                                        //   scrollDirection: Axis.horizontal,
                                        //   itemCount: snapshot.data.documents[index]['Tags'].length,
                                        //   itemBuilder: (context,ind){
                                        //     debugPrint("#${snapshot.data.documents[index]['Tags'][ind]}");
                                        //     return Text("#${snapshot.data.documents[index]['Tags'][ind]}");
                                        //   }
                                        // )
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
                          );
                        }
                      }
                    ),
                  ),
                ),
              ],
            ),
            MyResources()
          ],
        ),
      ),
    );
  }
}
