import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/models/user.dart';
import 'package:flutter_social_app/pages/activity_feed.dart';
import 'package:flutter_social_app/pages/create_account.dart';

import 'package:flutter_social_app/pages/timeline.dart';
import 'package:flutter_social_app/pages/upload.dart';
import 'package:flutter_social_app/pages/search.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';

import '../test.dart';
import 'profile_page.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = Firestore.instance.collection('users');
final DateTime timeStamp = DateTime.now();
User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pagecontroller;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pagecontroller = PageController();
    //detcts when user is signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (e) {
      print('error signn in: $e');
    });
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((e) {
      print('error signn in: $e');
    });
  }

  login() {
    googleSignIn.signIn();
  }

  logOut() {
    googleSignIn.signOut();
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      print('user signed in: $account');
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();

    //if user doesn't exist take them to the createAcoount page
    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));
      //get username from create acount page, use it to make a new entry in users collection
      usersRef.document(user.id).setData({
        'id': user.id,
        'username': username,
        'photoUrl': user.photoUrl,
        'email': user.email,
        'displayName': user.displayName,
        'bio': '',
        'timestamp': timeStamp,
      });
      doc = await usersRef.document(user.id).get();
    }
    currentUser = User.fromDocument(doc);
    print('currentUser is: ${currentUser.username}');
  }

  //UI methods

  void pageChange(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  void onTapH(int index) {
    pagecontroller.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  Widget buildAuthScreen() {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark),
      child: Scaffold(
        body: PageView(
          children: [
            // Timeline(),
            TextButton(
              child: Text('home'),
              onPressed: () {},
            ),
            ActivityFeed(),
            Upload(currentUser: currentUser),
            Search(),
            // Profile(profileId: currentUser?.id),
            ProfilePage(
              profileId: currentUser?.id,
            ),
          ],
          controller: pagecontroller,
          onPageChanged: pageChange,
        ),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTapH,
          activeColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
            BottomNavigationBarItem(icon: Icon(Icons.photo_camera)),
            BottomNavigationBarItem(icon: Icon(Icons.search)),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    pagecontroller.dispose();
    super.dispose();
  }

  Widget buildNotAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.teal, Colors.purple])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Social',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: login,
              child:
                  Text('Sign In with Google', style: TextStyle(fontSize: 30)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return buildAuthScreen();
    return isAuth ? buildAuthScreen() : buildNotAuthScreen();
  }
}
