import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/models/user.dart';
import 'package:flutter_social_app/widgets/post.dart';
import 'package:flutter_social_app/widgets/post_tile.dart';
import 'package:flutter_social_app/widgets/progress.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/services.dart';

import 'edit_profile.dart';
import 'home.dart';

Color mainColor = Color(0xff774a63);
Color secondColor = Color(0xffd6a5c0);
Color backgroundColor = Color(0xfffcf1f2);
final postsRef = Firestore.instance.collection('posts');

class ProfilePage extends StatefulWidget {
  final String profileId;

  const ProfilePage({Key key, this.profileId}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String currentUserId = currentUser?.id;
  bool isLoading = false;
  int postCount = 0;
  String orientation = 'grid';
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    getProfilePosts();
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snap = await postsRef
        .document(widget.profileId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    setState(() {
      isLoading = false;
      postCount = snap.documents.length;
      posts = snap.documents.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  void toggleOrientation(String orientation) {
    setState(() {
      this.orientation = orientation;
    });
  }

  buildProfilePosts() {
    if (isLoading) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return Center(
        child: Text('This user has no posts '),
      );
    } else if (orientation == 'grid') {
      List<GridTile> gridTiles = [];
      posts.forEach((post) {
        gridTiles.add(GridTile(child: PostTile(post: post)));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    } else if (orientation == 'list') {
      return Column(
        children: posts,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: buildProfileContainer(),
      ),
    );
  }

  Widget buildEditButton() {
    if (currentUserId == widget.profileId) {
      return CustomButton(
        text: 'Edit Profile',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfile(currentUserId: currentUserId),
            ),
          );
        },
      );
    }
  }

  Widget tOrientationW() {
    return Row(
      children: [
        IconButton(
            icon: Icon(Icons.grid_on_outlined),
            onPressed: () => toggleOrientation('grid')),
        SizedBox(
          width: 30,
        ),
        IconButton(
            icon: Icon(Icons.list_outlined),
            onPressed: () => toggleOrientation('list'))
      ],
    );
  }

  Widget buildProfileContainer() {
    var size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: usersRef.document(widget.profileId).get(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return circularProgress();
          }
          User user = User.fromDocument(snap.data);
          return SingleChildScrollView(
            child: Stack(
              children: [
                //main column
                Column(
                  children: [
                    Container(
                      width: size.width,
                      height: 220,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://m.media-amazon.com/images/I/81wgxPYNv+L._SS500_.jpg'),
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SocialInfo(),
                    SizedBox(
                      height: 15,
                    ),
                    SocialProffesion(),
                    SizedBox(
                      height: 15,
                    ),
                    buildEditButton(),
                    SizedBox(
                      height: 15,
                    ),
                    tOrientationW(),

                    SizedBox(
                      height: 15,
                    ),
                    // SocialFeed(),
                    buildProfilePosts(),
                  ],
                ),
                Positioned(
                  top: 160,
                  left: (size.width / 2) - 60,
                  child: Container(
                    width: 120,
                    height: 120,
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                          CachedNetworkImageProvider(user.photoUrl),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // image: DecorationImage(
                      //     image: CachedNetworkImageProvider(user.photoUrl)
                      // image: NetworkImage(
                      //     'https://m.media-amazon.com/images/I/311xwnjSKdL.jpg'),
                      // ),
                      boxShadow: [
                        BoxShadow(
                          color: secondColor,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),

                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.watch_later_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onPressed: () {})
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Function onTap;
  const CustomButton({
    Key key,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child:
              Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        onTap: onTap);
  }
}

class SocialInfo extends StatelessWidget {
  const SocialInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  '12.457',
                  style: TextStyle(
                      color: mainColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  'Followers',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: secondColor, fontSize: 16),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  '123',
                  style: TextStyle(
                      color: mainColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  'Following',
                  style: TextStyle(color: secondColor, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SocialProffesion extends StatelessWidget {
  const SocialProffesion({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'Oscar Dario',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                ' │ ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                'Developer',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SocialFeed extends StatelessWidget {
  const SocialFeed({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(25),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: new Text('$index'),
            ),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
          );
        },
        staggeredTileBuilder: (index) {
          return StaggeredTile.count(1, index.isEven ? 2 : 1);
        },
      ),
    );
  }
}
