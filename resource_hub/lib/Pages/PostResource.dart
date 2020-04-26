import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostResource extends StatefulWidget {
  @override
  _PostResourceState createState() => _PostResourceState();
}

class _PostResourceState extends State<PostResource> {

  final _formKey = GlobalKey<FormState>();

  String description, title, tag, link;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final tagController = TextEditingController();
  final linkController = TextEditingController();

  final List<String> tagsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Post your resource"),
        ),
        body: Center(
            child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    hintText: "Enter title",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), gapPadding: 18),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Enter description",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), gapPadding: 18),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width*0.7,
                      child: TextFormField(
                        controller: tagController,
                        decoration: InputDecoration(
                          labelText: "Tag",
                          hintText: "Enter tag",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), gapPadding: 18),
                        ),
                        validator: (value) {
                          if (tagsList.length==0) {
                            return 'Please enter some tags';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.2,
                      child: MaterialButton(
                        onPressed: (){
                          setState(() {
                            if(tagController.value.text != "")
                              tagsList.add(tagController.value.text);
                            tagController.clear();
                          });
                        },
                        child: Text("Add tag"),
                      ),
                    )
                  ],
                ),
              ),
              (tagsList.length != 0) ? Container(
                height: 40,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tagsList.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(tagsList[index] == null ? '' : tagsList[index]),
                      );
                    }
                ),
              ) : Container(height: 10, width: 10,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: linkController,
                  decoration: InputDecoration(
                    labelText: "Link",
                    hintText: "Enter link for the resource",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), gapPadding: 18),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlineButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _handlePostResource();
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        )));
  }

  _handlePostResource(){
    if (_formKey.currentState.validate()) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Posting Data')));

      Firestore.instance.collection('Posts').add({
        "Title": titleController.value.text,
        "Description": descriptionController.value.text,
        "Tags": tagsList,
        "Link": linkController.value.text,
        "Likes": "5",
        "Timestamp": DateTime.now(),
        "UserID": "12",
        "Username": "Tester XxX"
      });
    }
  }
}
