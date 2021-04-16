import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/pages/home.dart';
import 'package:flutter_social_app/widgets/progress.dart';
import '../models/user.dart';

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
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  int likeCount;
  Map likes;

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

  Widget buildPostContainer() {
    return FutureBuilder(
      future: usersRef.document(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        return Stack(
          children: [
            GestureDetector(
              onDoubleTap: () => print('liking post'),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 500.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://m.media-amazon.com/images/I/311xwnjSKdL.jpg')),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
            ),
            Container(
              height: 500.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PostHeader(user: user),
                  // SizedBox(
                  //   height: 350,
                  // ),
                  PostFooter(likeCount: likeCount),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text("Post");
  }
}

//custom widgets
class PostHeader extends StatelessWidget {
  final User user;

  const PostHeader({Key key, this.user}) : super(key: key);
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
          'elpuchito',
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
      trailing: IconButton(
          onPressed: () => print('deleting post'),
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          )),
    );
  }
}

class PostFooter extends StatelessWidget {
  final int likeCount;

  const PostFooter({Key key, this.likeCount}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 200,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => print('like this post'),
              child: Icon(
                Icons.favorite_border,
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
              onTap: () => print('showing comments'),
              child: Icon(
                Icons.chat,
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
            Icons.save,
            color: Colors.white,
          )),
    );
  }
}
