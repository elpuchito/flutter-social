import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/widgets/header.dart';
import 'package:flutter_social_app/widgets/progress.dart';

final usersRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  void initState() {
    super.initState();
    updateUser();
  }

  getUsers() async {
    final QuerySnapshot snap = await usersRef.getDocuments();
    snap.documents.forEach((element) {
      print('users: ${element.data}');
    });
    // usersRef.getDocuments().then((snapshot) {
    //   snapshot.documents.forEach((element) {
    //     print(element.data);
    //   });
    // });
  }

  createUser() {
    usersRef.add({'name': 'ota', 'isAdmin': false, 'postCount': 34});
  }

  updateUser() async {
    final doc = await usersRef.document('Q8BVqW5DNUXALQddihJ9').get();
    if (doc.exists) {
      doc.reference.updateData({'postCount': 69});
    }
    // usersRef.document('Q8BVqW5DNUXALQddihJ9').updateData({'postCount': 897});
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context, isAppTittle: true),
        body: StreamBuilder<QuerySnapshot>(
            stream: usersRef.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularProgress();
              }
              return Container(
                child: ListView(
                  children: snapshot.data.documents
                      .map((doc) => Text(doc['name']))
                      .toList(),
                ),
              );
            }));
  }
}
