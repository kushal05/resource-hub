import 'package:flutter/material.dart';
import 'package:resourcehub/Pages/MyResources.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ListView recommendedResources() {
    return ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return Text("Resource ${index + 1}");
        });
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
                    child: ListView.builder(
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
                                    "Title ${index + 1}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Link: https://resourcehub.com/posts/${index + 1}",
                                    style: TextStyle(fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "#tag${index + 1} #tag${index + 2}",
                                    style: TextStyle(fontWeight: FontWeight.normal),
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
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: 100,
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
