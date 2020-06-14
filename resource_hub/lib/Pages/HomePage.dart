import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:resourcehub/Pages/MyResources.dart';
import '../Globals.dart';
import 'WebViewPage.dart';
import 'dart:async';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:share/share.dart';

var lastRefreshedTime;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<String> tags = [];


  initState(){
    super.initState();
    debugPrint("##### Init state called");
    getPosts();
    getBookmarks();
  }
  
  void getBookmarks(){
    Firestore.instance.collection('Users')..where('UserID',isEqualTo: '1').getDocuments().then((data){
      bookmarkedPostids = new HashSet<int>();
      var arr= data.documents[0].data['bookmarks'];
      for(var p in arr){
        bookmarkedPostids.add(p);
      }
      print(bookmarkedPostids.toString());
//      print(data.documents[0].data['bookmarks']);
    });
  }

  void getPosts(){
    Firestore.instance.collection('Posts').getDocuments().then((doc){
      posts = [];
      var temp = doc.documents;

      for(var p in temp){
        for(var tag in p.data['Tags']){
          print("Tags are: $tag for title: ${p.data['Title']}");
          tags.add(tag);
        }

        posts.add({
          'post_id':p.data['post_id'],
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
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Icon(Icons.search),
            )
          ],
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: Theme.of(context).accentColor,
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
                    color: Theme.of(context).canvasColor,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tags.length,
                        itemBuilder: (context, index) {
                          return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).unselectedWidgetColor,
                                      borderRadius: BorderRadius.circular(15.0)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(tags[index]),
                                    )),
                              ));
                        }),
                  ),
                ),
        Expanded(
            flex: 10,
            child: Container(
                color: Theme.of(context).canvasColor,
                child:LiquidPullToRefresh(
                    onRefresh: (){
                      return Future<void>((){
                        posts=null;
                        lastRefreshedTime = DateTime.now();
                        print("--------Pulled to refresh at $lastRefreshedTime--------");
                        getPosts();
                      });
                    },
                    child:(posts==null)?ListView(children:[Center(child:Text("Loading.."))]):ListView.builder(
                      itemCount:postsLength,
                      controller: _controller,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Card(
                            color: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            elevation: 2,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 30,
                                    ),
                                    Text(
                                      "${posts[index]['Title']}",
                                      style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black87,fontSize: 18.0),
                                    ),
                                    GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          debugPrint("bookmarked");
                                          pressBookmark(posts[index]['post_id']);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 20),
                                          child: Icon(
                                              Icons.star_border,
                                              color: bookmarkedPostids.contains(posts[index]['post_id'])?Colors.amberAccent:Colors.black,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                        text:TextSpan(
                                          text: "${posts[index]['Link']}",
                                          style: new TextStyle(color: Theme.of(context).accentColor),
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
                                      child: Text("#${posts[index]['Tags'][0]}",style: TextStyle(color: Colors.black87,),),
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
                                    new ShareButton(),
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
              ],
            ),
            MyResources()
          ],
        ),
      ),
    );
  }
  Future<dynamic> pressLike(int post_id, int index) async{
    if(likedPosts.contains(post_id)){

      setState(() {
        likedPosts.remove(post_id);
        --posts[index]['Likes'];
      });
      Firestore.instance.collection("Users").where('UserID',isEqualTo: '1').getDocuments().then((data){
        print("Data is: ${data.documents[0].documentID}");

        var list = List<int>();
        list.add(post_id);
        Firestore.instance.collection('Users').document(data.documents[0].documentID).updateData({"Likes": FieldValue.arrayRemove(list)});
      });
      Firestore.instance.collection("Posts").where('post_id',isEqualTo: post_id).getDocuments().then((data){
        print("Data is: ${data.documents[0].documentID}");
        Firestore.instance.collection('Posts').document(data.documents[0].documentID).updateData({"Likes": posts[index]['Likes']});
      });
    }
    else{
      setState(() {
        likedPosts.add(post_id);
        ++posts[index]['Likes'];
      });

      Firestore.instance.collection("Users").where('UserID',isEqualTo: '1').getDocuments().then((data){
        print("Data is: ${data.documents[0].documentID}");

        var list = List<int>();
        list.add(post_id);
        Firestore.instance.collection('Users').document(data.documents[0].documentID).updateData({"Likes": FieldValue.arrayUnion(list)});
      });
      Firestore.instance.collection("Posts").where('post_id',isEqualTo: post_id).getDocuments().then((data){
        print("Data is: ${data.documents[0].documentID}");
        Firestore.instance.collection('Posts').document(data.documents[0].documentID).updateData({"Likes": posts[index]['Likes']});
      });
    }

    return;
  }

  Future<dynamic> pressBookmark(int post_id) async{
    if(bookmarkedPostids.contains(post_id)){

      setState(() {
        bookmarkedPostids.remove(post_id);
      });
      var data = Firestore.instance.collection("Users").where('UserID',isEqualTo: '1').getDocuments().then((data){
        print("Data is: ${data.documents[0].documentID}");

        var list = List<int>();
        list.add(post_id);
        Firestore.instance.collection('Users').document(data.documents[0].documentID).updateData({"bookmarks": FieldValue.arrayRemove(list)});
      });
    }
    else{
      setState(() {
        bookmarkedPostids.add(post_id);
      });
      Firestore.instance.collection("Users").where('UserID',isEqualTo: '1').getDocuments().then((data){
      bookmarkedPostids.add(post_id);
      var data = Firestore.instance.collection("Users").where('UserID',isEqualTo: '1').getDocuments().then((data){
        print("Data is: ${data.documents[0].documentID}");

        var list = List<int>();
        list.add(post_id);
        Firestore.instance.collection('Users').document(data.documents[0].documentID).updateData({"bookmarks": FieldValue.arrayUnion(list)});
      });
    }

    return;
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        final RenderBox box = context.findRenderObject();
        Share.share("Hey! Checkout this cool article link",
            subject: "Hey! Checkout this cool article",
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      },
      child: Text("Share"),
    );
  }
}
