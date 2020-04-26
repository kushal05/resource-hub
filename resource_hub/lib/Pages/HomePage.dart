import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:resourcehub/Pages/MyResources.dart';
import '../Globals.dart';
import 'WebViewPage.dart';
import 'dart:async';

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
              child: Icon(Icons.search),
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
                    decoration: blueGradient,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white30,
                                      borderRadius: BorderRadius.circular(15.0)
                                    ),
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
                                      borderRadius: BorderRadius.circular(12.0)),
                                  elevation: 2,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: 30,
                                            ),
                                            Text(
                                              "${snapshot.data.documents[index]['Title']}",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            GestureDetector(
                                                behavior: HitTestBehavior.translucent,
                                                onTap: () {
                                                  debugPrint("bookmarked");
                                                  getUserBookmarks();
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(right: 20),
                                                  child: Icon(Icons.star_border),
                                                )
                                            ),
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
                                               ..onTap = () {
                                                 Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (BuildContext context) => MyWebView(
                                                        title: "${snapshot.data.documents[index]['Title']}",
                                                        selectedUrl: "${snapshot.data.documents[index]['Link']}",
                                                      )));
                                             },
                                          )
                                        )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Container(
                                              child: Text("#${snapshot.data.documents[index]['Tags'][0]}"),
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

  Future<dynamic> getUserBookmarks() async{
    var data = Firestore.instance.collection("Users").where('user_id',isEqualTo: 1).getDocuments().then((data){
      print("Data is: ${data.documents[0].data}");
    });
    return data;
  }
}
