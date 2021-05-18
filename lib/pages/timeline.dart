import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/models/user.dart';
import 'package:flutter_social_app/pages/search.dart';
import 'package:flutter_social_app/widgets/header.dart';
import 'package:flutter_social_app/widgets/post.dart';
import 'package:flutter_social_app/widgets/progress.dart';
import 'home.dart';
import 'profile_page.dart';
//temporary timeline

final usersRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  final User currentUser;

  const Timeline({Key key, this.currentUser}) : super(key: key);
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  String currentUserId = currentUser?.id;
  List<Post> posts = [];
  List<String> followingList = [];

  void initState() {
    super.initState();
    getTimeline();
    getFollowing();
  }

  getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
        .document(currentUserId)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts =
        snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
    });
  }

  buildTimeline() {
    if (posts == null) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return buildUsersToFollow();
    } else {
      return ListView(children: posts);
    }
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .document(currentUserId)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      followingList = snapshot.documents.map((doc) => doc.documentID).toList();
    });
  }

  buildUsersToFollow() {
    return StreamBuilder(
      stream:
          usersRef.orderBy('timestamp', descending: true).limit(30).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> userResults = [];
        snapshot.data.documents.forEach((doc) {
          User user = User.fromDocument(doc);
          final bool isAuthUser = currentUserId == user.id;
          final bool isFollowingUser = followingList.contains(user.id);
          // remove auth user from recommended list
          if (isAuthUser) {
            return;
          } else if (isFollowingUser) {
            return;
          } else {
            UserResult userResult = UserResult(user: user);
            userResults.add(userResult);
          }
        });
        return SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.person_add,
                        color: Theme.of(context).primaryColor,
                        size: 30.0,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        "Users to Follow",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(children: userResults),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () => getTimeline(), child: buildTimeline()));
  }
}

// child: PopupMenuButton(
//   shape:
//       RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
//   itemBuilder: (BuildContext bc) => [
//     PopupMenuItem(
//       child: Text('Delete this post?'),
//     ),
//     PopupMenuItem(
//       child: TextButton(
//         onPressed: () => print('hello'),
//         child: Text(
//           'Delete',
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//     ),
//   ],
// ),
