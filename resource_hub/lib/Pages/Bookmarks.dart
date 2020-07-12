import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:resourcehub/Theme.dart';
import 'package:share/share.dart';

import '../Globals.dart';
import 'WebViewPage.dart';

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  var isLoaded = false;
  initState() {
    super.initState();
    debugPrint("##### Init state called");
    getBookmarks();
  }

  void getBookmarks() {
    bookmarkedPosts = [];
    Firestore.instance
        .collection('Users')
        .where('UserID', isEqualTo: '1')
        .getDocuments()
        .then((data) {
      bookmarkedPostids = new HashSet<int>();
      var arr = data.documents[0].data['bookmarks'];
      var val = 0;
      for (var p in arr) {
        bookmarkedPostids.add(p);
        Firestore.instance
            .collection('Posts')
            .where('post_id', isEqualTo: p)
            .getDocuments()
            .then((data) {
          var temp = data.documents;
          for (var p in temp) {
            val++;
            bookmarkedPosts.add({
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
            if(val == arr.length){
              isLoaded =true;
              setState(() {
                bookmarkedPostsLength=arr.length;
                debugPrint("getBookmarks called");
              });
            }
          }
        });
      }
      bookmarkedPosts.sort((a, b) {
        var adate = a['Timestamp'].millisecondsSinceEpoch;
        var bdate = b['Timestamp'].millisecondsSinceEpoch;
        return -1 * int.parse(adate.compareTo(bdate).toString());
      });

      print(bookmarkedPostids.toString());
//      print(data.documents[0].data['bookmarks']);
    });
  }

  ScrollController _controller = ScrollController();

  void showSnackBar(BuildContext context) {
    var snackBar = SnackBar(
      content: Text("Resources have been updates!"),
      action: SnackBarAction(
        label: "Show updates",
        onPressed: () {
          _controller.jumpTo(0.0);
        },
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<dynamic> pressBookmark(int postId) async {
    if (bookmarkedPostids.contains(postId)) {
      setState(() {
        bookmarkedPostids.remove(postId);
      });
      Firestore.instance
          .collection("Users")
          .where('UserID', isEqualTo: '1')
          .getDocuments()
          .then((data) {
        print("Data is: ${data.documents[0].documentID}");
        var list = List<int>();
        list.add(postId);
        Firestore.instance
            .collection('Users')
            .document(data.documents[0].documentID)
            .updateData({"bookmarks": FieldValue.arrayRemove(list)});
      });
    } else {
      setState(() {
        bookmarkedPostids.add(postId);
      });
      var data = Firestore.instance
          .collection("Users")
          .where('UserID', isEqualTo: '1')
          .getDocuments()
          .then((data) {
        print("Data is: ${data.documents[0].documentID}");
        var list = List<int>();
        list.add(postId);
        Firestore.instance
            .collection('Users')
            .document(data.documents[0].documentID)
            .updateData({"bookmarks": FieldValue.arrayUnion(list)});
      });
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Bookmarks"),
        ),
        body: Container(
            color: Theme.of(context).canvasColor,
            child: LiquidPullToRefresh(
                onRefresh: () {
                  return Future<void>(() {
                    bookmarkedPosts = null;
                    lastRefreshedTime = DateTime.now();
                    print(
                        "--------Pulled to refresh at $lastRefreshedTime--------");
                    getBookmarks();
                  });
                },
                child: (!isLoaded)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Center(
                                child: Text(
                              "Getting your bookmarks...",
                              style: TextStyles.title,
                            )),
                            SizedBox(
                              height: 30,
                            ),
                            CircularProgressIndicator()
                          ])
                    : ListView.builder(
                        itemCount: bookmarkedPostsLength,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        width: 30,
                                      ),
                                      Text(
                                        "${bookmarkedPosts[index]['Title']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                            fontSize: 18.0),
                                      ),
                                      GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            debugPrint("bookmarked");
                                            pressBookmark(bookmarkedPosts[index]
                                                ['post_id']);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: Icon(
                                              Icons.star_border,
                                              color: bookmarkedPostids.contains(
                                                      bookmarkedPosts[index]
                                                          ['post_id'])
                                                  ? Colors.amberAccent
                                                  : Colors.black,
                                            ),
                                          )),
                                    ],
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                          text: TextSpan(
                                        text:
                                            "${bookmarkedPosts[index]['Link']}",
                                        style: new TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        MyWebView(
                                                          title:
                                                              "${bookmarkedPosts[index]['Title']}",
                                                          selectedUrl:
                                                              "${bookmarkedPosts[index]['Link']}",
                                                        )));
                                          },
                                      ))),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Container(
                                        child: Text(
                                          "#${bookmarkedPosts[index]['Tags'][0]}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      MaterialButton(
                                        onPressed: () {},
                                        child: Text("Kudos"),
                                      ),
                                      MaterialButton(
                                        onPressed: () {},
                                        child: Text("Comment"),
                                      ),
                                      shareButton(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ))));
  }

  Widget shareButton() {
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