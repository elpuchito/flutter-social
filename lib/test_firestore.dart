import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = Firestore.instance.collection('usersTest');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'full_name': 'elpuchito', // John Doe
            'company': 'spotify', // Stokes and Sons
            'age': 31 // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          TextButton(
            onPressed: addUserCustomId,
            child: Center(
              child: Text(
                "Add User",
              ),
            ),
          ),
          Expanded(child: GetUserName('-MYqC4e3MDntHfwF8XkI')),
        ],
      ),
    );
  }

  searchForUserbyAge() {
    Firestore.instance
        .collection('usersTest')
        .where('age', isGreaterThan: 20)
        .getDocuments()
        .then((doc) => {print(doc.documents.map((e) => e.data))});
  }

  searchForUserbyName() {
    Firestore.instance
        .collection('usersTest')
        .where('full_name', isGreaterThanOrEqualTo: 'os')
        .getDocuments()
        .then((doc) => {print(doc.documents.map((e) => e.data))});
  }

  Future<void> addUserCustomId() {
    CollectionReference users = Firestore.instance.collection('usersTest');
    return users
        .document('ABC123')
        .setData({'full_name': "Mary Jane", 'age': 18})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}

class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = Firestore.instance.collection('usersTest');

    return FutureBuilder<DocumentSnapshot>(
      future: users.document(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.data.exists) {
          print('age: ${snapshot.data['age']}');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data;
          return Center(
              child: Text("Full Name: ${data['full_name']} ${data['age']}"));
        }

        return Text("loading");
      },
    );
  }
}

class UserInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = Firestore.instance.collection('usersTest');

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return new ListView(
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return new ListTile(
              title: new Text(document.data['full_name']),
              subtitle: new Text(document.data['company']),
            );
          }).toList(),
        );
      },
    );
  }
}
