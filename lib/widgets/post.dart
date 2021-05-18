import 'dart:async';
import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/pages/upload.dart';
import 'package:flutter_social_app/pages/comments.dart';
import 'package:flutter_social_app/pages/home.dart';
import 'package:flutter_social_app/pages/profile_page.dart';
import 'package:flutter_social_app/widgets/progress.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import '../models/user.dart';

final DateTime timestamp = DateTime.now();

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;

  const Post({
    Key key,
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
  }) : super(key: key);

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      description: doc['description'],
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      location: doc['location'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
    );
  }

  int getLikeCount(likes) {
    // if no likes, return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        username: this.username,
        location: this.location,
        description: this.description,
        mediaUrl: this.mediaUrl,
        likes: this.likes,
        likeCount: getLikeCount(this.likes),
      );
}

class _PostState extends State<Post> {
  final String currentUserId = currentUser?.id;
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  int likeCount;
  Map likes;
  bool isLiked;
  bool showBigHeart = false;
  _PostState({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    this.likeCount,
  });

  handleLikePost() {
    bool _isLiked = likes[currentUserId] == true;

    if (_isLiked) {
      postsRef
          .document(ownerId)
          .collection('userPosts')
          .document(postId)
          .updateData({'likes.$currentUserId': false});
      removeLikefromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[currentUserId] = false;
      });
    } else if (!_isLiked) {
      postsRef
          .document(ownerId)
          .collection('userPosts')
          .document(postId)
          .updateData({'likes.$currentUserId': true});
      addLiketoActivityFeed();
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[currentUserId] = true;
        showBigHeart = true;
        Timer(Duration(milliseconds: 500), () {
          setState(() {
            showBigHeart = false;
          });
        });
      });
    }
  }

  addLiketoActivityFeed() {
    bool isNotPostOwner = currentUserId != ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .document(ownerId)
          .collection("feedItems")
          .document(postId)
          .setData({
        "type": "like",
        "username": currentUser.username,
        "userId": currentUser.id,
        "userProfileImg": currentUser.photoUrl,
        "postId": postId,
        "mediaUrl": mediaUrl,
        "timestamp": timestamp,
      });
    }
  }

  removeLikefromActivityFeed() {
    bool isNotPostOwner = currentUserId != ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .document(ownerId)
          .collection("feedItems")
          .document(postId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  Widget buildPostContainer() {
    return FutureBuilder(
      future: usersRef.document(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        bool isPostOwner = currentUserId == ownerId;
        return Stack(
          children: [
            GestureDetector(
              onDoubleTap: handleLikePost,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 500.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(mediaUrl),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  showBigHeart
                      ? Animator(
                          duration: Duration(milliseconds: 500),
                          tween: Tween(begin: 0.8, end: 300),
                          curve: Curves.elasticOut,
                          cycles: 0,
                          builder: (context, anim, child) => Center(
                            child: Container(
                              height: anim.value,
                              width: anim.value,
                              child: Icon(
                                Icons.favorite,
                                size: 150.0,
                                color: Colors.pink,
                              ),
                            ),
                          ),
                        )
                      : Text(""),
                ],
              ),
            ),
            Container(
              height: 500.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PostHeader(
                    user: user,
                    postId: postId,
                    ownerId: ownerId,
                    isPostOwner: isPostOwner,
                  ),
                  // SizedBox(
                  //   height: 350,
                  // ),
                  PostFooter(
                    likeCount: likeCount,
                    isLiked: isLiked,
                    handleLikePost: handleLikePost,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildDescriptionW() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$username ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
                child: Text(description,
                    style: TextStyle(
                      color: Colors.black87,
                    )))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 20.0),
                child: TextButton(
                  child: Text(
                    'View all comments',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => showComments(
                    context,
                    postId: postId,
                    ownerId: ownerId,
                    mediaUrl: mediaUrl,
                  ),
                )),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUserId] == true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildPostContainer(),
        SizedBox(
          height: 10,
        ),
        buildDescriptionW(),
        SizedBox(
          height: 10,
        ),
        // Divider(
        //   indent: 20,
        //   endIndent: 20,
        //   color: Colors.black38,
        // ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}

//custom widgets
class PostHeader extends StatelessWidget {
  final bool isPostOwner;
  final User user;
  final String postId;
  final String ownerId;

  deletePost() async {
    postsRef
        .document(ownerId)
        .collection('userPosts')
        .document(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // delete uploaded image for thep ost
    storageRef.child("post_$postId.jpg").delete();
    // then delete all activity feed notifications
    QuerySnapshot activityFeedSnapshot = await activityFeedRef
        .document(ownerId)
        .collection("feedItems")
        .where('postId', isEqualTo: postId)
        .getDocuments();
    activityFeedSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // then delete all comments
    QuerySnapshot commentsSnapshot = await commentsRef
        .document(postId)
        .collection('comments')
        .getDocuments();
    commentsSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  const PostHeader(
      {Key key, this.user, this.postId, this.ownerId, this.isPostOwner})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(user.photoUrl),
          backgroundColor: Colors.grey,
        ),
        title: GestureDetector(
          onTap: () => print('showing profile'),
          child: Text(
            user.username,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Text(
          'Boca Chica, Texas',
          style: TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.normal,
          ),
        ),
        trailing: isPostOwner
            ? PopupMenuButton(
                icon: Icon(Icons.more_vert, color: Colors.white),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                itemBuilder: (BuildContext bc) => [
                  PopupMenuItem(
                    child: Text('Delete this post?'),
                  ),
                  PopupMenuItem(
                    child: TextButton(
                      onPressed: () {
                        deletePost();
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              )
            : Text(''));
  }

  // handleDeletePost(BuildContext parentContext) {
  //   return PopupMenuButton(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
  //     itemBuilder: (BuildContext bc) => [
  //       PopupMenuItem(
  //         child: TextButton(
  //           onPressed: () => print('hello'),
  //           child: Text(
  //             'Delete',
  //             style: TextStyle(color: Colors.black),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

class PostFooter extends StatelessWidget {
  final int likeCount;
  final bool isLiked;
  final Function handleLikePost;

  final postId;
  final ownerId;
  final mediaUrl;

  const PostFooter(
      {Key key,
      this.likeCount,
      this.isLiked,
      this.handleLikePost,
      this.postId,
      this.ownerId,
      this.mediaUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 200,
        child: Row(
          children: [
            GestureDetector(
              onTap: handleLikePost,
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 5.0)),
            Text(
              '$likeCount',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 18,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () => showComments(
                context,
                postId: postId,
                ownerId: ownerId,
                mediaUrl: mediaUrl,
              ),
              child: Icon(
                Feather.message_circle,
                size: 28.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      trailing: IconButton(
          onPressed: () => print('deleting post'),
          icon: Icon(
            Feather.pocket,
            color: Colors.white,
          )),
    );
  }
}

showComments(BuildContext context,
    {String postId, String ownerId, String mediaUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Comments(
      postId: postId,
      postOwnerId: ownerId,
      postMediaUrl: mediaUrl,
    );
  }));
}
