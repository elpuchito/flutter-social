import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

Color mainColor = Color(0xff774a63);
Color secondColor = Color(0xffd6a5c0);
Color backgroundColor = Color(0xfffcf1f2);

List<ImageProvider> images = [
  AssetImage('assets/image2.png'),
  AssetImage('assets/image1.png'),
  AssetImage('assets/image3.png'),
  AssetImage('assets/image1.png'),
  AssetImage('assets/image2.png'),
];

List<ImageProvider> avatars = [
  AssetImage('assets/avatar1.png'),
  AssetImage('assets/avatar2.png'),
  AssetImage('assets/avatar3.png'),
  AssetImage('assets/avatar1.png'),
  AssetImage('assets/avatar2.png'),
];

class SocialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark),
      child: Scaffold(
        // extendBody: true,
        backgroundColor: backgroundColor,
        body: ListView(
          children: <Widget>[
            // TestHeader(),
            CustomSocialHeader(),
            SocialInfo(),
            SocialFeed(),
          ],
        ),
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
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(75),
        ),
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

class SocialInfo extends StatelessWidget {
  const SocialInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(height: 100, color: Colors.white),
        Container(
          padding: EdgeInsets.only(top: 25),
          height: 100,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(75),
              bottomRight: Radius.circular(75),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'Photos',
                    style: TextStyle(color: secondColor, fontSize: 16),
                  ),
                  Text(
                    '567',
                    style: TextStyle(
                        color: mainColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Followers',
                    style: TextStyle(color: secondColor, fontSize: 16),
                  ),
                  Text(
                    '12.457',
                    style: TextStyle(
                        color: mainColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Follows',
                    style: TextStyle(color: secondColor, fontSize: 16),
                  ),
                  Text(
                    '123',
                    style: TextStyle(
                        color: mainColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomSocialHeader extends StatelessWidget {
  const CustomSocialHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(75))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(Icons.arrow_back, color: mainColor),
              Icon(Icons.more_vert, color: mainColor),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              'My Profile',
              style: TextStyle(fontSize: 30, color: mainColor),
            ),
          ),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                    'https://m.media-amazon.com/images/I/311xwnjSKdL.jpg'),
              ),
              boxShadow: [
                BoxShadow(
                  color: secondColor,
                  blurRadius: 40,
                  offset: Offset(0, 10),
                ),
              ],
            ),
          ),
          Container(),
          Text(
            'Oscar Dario',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w700, color: mainColor),
          ),
          Text(
            '@dariobhc',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: secondColor),
          ),
        ],
      ),
    );
  }
}

class TestHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 220,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://m.media-amazon.com/images/I/311xwnjSKdL.jpg'),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
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
        )
      ],
    );
  }
}
