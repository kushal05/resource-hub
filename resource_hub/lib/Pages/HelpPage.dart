import 'package:flutter/material.dart';
import 'package:resourcehub/Pages/Settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  var questionStyle = TextStyle(fontSize: 18.0);
  var answerStyle = TextStyle(fontSize: 16.0);

  QuerySnapshot faqs;
  getFaqs() async {
    return await Firestore.instance.collection('FAQs').getDocuments();
  }

  @override
  void initState() {
    super.initState();
    getFaqs().then((results) {
      setState(() {
        faqs = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: new IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text("Help"),
      ),
      body: faqs == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: ListView.builder(
                  itemCount: faqs.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ExpansionTile(
                      title: Text(
                        "${faqs.documents[index].data['faq'][0]}",
                        style: questionStyle,
                        textAlign: TextAlign.left,
                      ),
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 5),
                          child: Text(
                            "${faqs.documents[index].data['faq'][1]}",
                            style: answerStyle,
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    );
                  })),
    );
  }
}
