import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/models/user.dart';
import 'package:flutter_social_app/widgets/progress.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/services.dart';

import 'edit_profile.dart';
import 'home.dart';

Color mainColor = Color(0xff774a63);
Color secondColor = Color(0xffd6a5c0);
Color backgroundColor = Color(0xfffcf1f2);

class ProfilePage extends StatefulWidget {
  final String profileId;

  const ProfilePage({Key key, this.profileId}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String currentUserId = currentUser?.id;
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
        body: buildProfileHeader(),
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

  Widget buildProfileHeader() {
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
                    SocialFeed(),
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
