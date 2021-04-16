import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_social_app/models/user.dart';
import 'package:flutter_social_app/pages/home.dart';
import 'package:flutter_social_app/widgets/progress.dart';

TextEditingController displayNmContrler = TextEditingController();
TextEditingController bioContrler = TextEditingController();
bool _displayNamevalid = true;
bool _bioValid = true;

class EditProfile extends StatefulWidget {
  final String currentUserId;

  const EditProfile({Key key, this.currentUserId}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  User user;

  @override
  void initState() {
    super.initState();
    getuser();
  }

  updateProfileData() {
    setState(() {
      displayNmContrler.text.trim().length < 3 || displayNmContrler.text.isEmpty
          ? _displayNamevalid = false
          : _displayNamevalid = true;
      bioContrler.text.trim().length > 100
          ? _bioValid = false
          : _bioValid = true;
    });

    if (_displayNamevalid && _bioValid) {
      usersRef.document(widget.currentUserId).updateData({
        "displayName": displayNmContrler.text,
        "bio": bioContrler.text,
      });
      SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  getuser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.document(widget.currentUserId).get();
    user = User.fromDocument(doc);
    displayNmContrler.text = user.displayName;
    bioContrler.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  logout() async {
    await googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.done,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context))
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              CachedNetworkImageProvider(user.photoUrl),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            DisplayNameField(),
                            BioField(),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: updateProfileData,
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: FlatButton(
                          onPressed: logout,
                          child: Text(
                            "Logout",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

//   Column buildDisplayNameField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Padding(
//             padding: EdgeInsets.only(top: 12.0),
//             child: Text(
//               "Display Name",
//               style: TextStyle(color: Colors.grey),
//             )),
//         TextField(
//           controller: displayNmContrler,
//           decoration: InputDecoration(
//             hintText: "Update Display Name",
//             errorText: _displayNamevalid ? null : "Display Name too short",
//           ),
//         )
//       ],
//     );
//   }

//   Column buildBioField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Padding(
//           padding: EdgeInsets.only(top: 12.0),
//           child: Text(
//             "Bio",
//             style: TextStyle(color: Colors.grey),
//           ),
//         ),
//         TextField(
//           controller: bioContrler,
//           decoration: InputDecoration(
//             hintText: "Update Bio",
//             errorText: _bioValid ? null : "Bio too long",
//           ),
//         )
//       ],
//     );
//   }
}

class BioField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Bio",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: bioContrler,
          decoration: InputDecoration(
              hintText: "Update Bio",
              errorText: _bioValid ? null : "Bio too long"),
        )
      ],
    );
  }
}

class DisplayNameField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Display Name",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: displayNmContrler,
          decoration: InputDecoration(
              hintText: "Update Display Name",
              errorText: _displayNamevalid ? null : 'display name too short'),
        )
      ],
    );
  }
}
