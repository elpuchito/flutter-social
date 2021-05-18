import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/models/user.dart';
import 'package:flutter_social_app/pages/home.dart';
import 'package:flutter_social_app/pages/timeline.dart';
import 'package:flutter_social_app/widgets/progress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'activity_feed.dart';
import 'post_screen.dart';

final usersRef = Firestore.instance.collection('users');

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchCtrler = TextEditingController();
  Future searchResultsFuture;

  handleSearch(String query) {
    Future<QuerySnapshot> users = usersRef
        .where('displayName', isGreaterThanOrEqualTo: query)
        .getDocuments();
    setState(() {
      searchResultsFuture = users;
    });
  }

  clearSearch() {
    searchCtrler.clear();
  }

  Widget buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 120,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: searchCtrler,
          onFieldSubmitted: handleSearch,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide.none),
              hintText: 'Search here',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              prefixIcon: Icon(
                Icons.search_outlined,
                size: 30,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: clearSearch,
              )),
        ),
      ),
    );
  }

  Widget buildFeed() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Container(
          child: FutureBuilder(
        future: getActivityFeed(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          return ListView(
            children: snapshot.data,
          );
        },
      )),
    );
  }
  // Widget buildPostContainer() {
  //   //the line below is for responsive design
  //   // final orientation = MediaQuery.of(context).orientation;
  //   return Stack(
  //     children: [
  //       GestureDetector(
  //         onDoubleTap: () => print('liking post'),
  //         child: Container(
  //           width: MediaQuery.of(context).size.width,
  //           height: 500.0,
  //           decoration: BoxDecoration(
  //             image: DecorationImage(
  //                 fit: BoxFit.cover,
  //                 image: NetworkImage(
  //                     'https://m.media-amazon.com/images/I/311xwnjSKdL.jpg')),
  //             borderRadius: BorderRadius.all(Radius.circular(20.0)),
  //           ),
  //         ),
  //       ),
  //       Container(
  //         height: 500.0,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             buildPostHeader(),
  //             // SizedBox(
  //             //   height: 350,
  //             // ),
  //             buildPostFooter(),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget buildPostHeader() {
  //   return ListTile(
  //     leading: CircleAvatar(
  //       backgroundImage: CachedNetworkImageProvider(
  //           'https://m.media-amazon.com/images/I/81wgxPYNv+L._SS500_.jpg'),
  //       backgroundColor: Colors.grey,
  //     ),
  //     title: GestureDetector(
  //       onTap: () => print('showing profile'),
  //       child: Text(
  //         'elpuchito',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ),
  //     subtitle: Text(
  //       'Boca Chica, Texas',
  //       style: TextStyle(
  //         color: Colors.white54,
  //         fontWeight: FontWeight.normal,
  //       ),
  //     ),
  //     trailing: IconButton(
  //         onPressed: () => print('deleting post'),
  //         icon: Icon(
  //           Icons.more_vert,
  //           color: Colors.white,
  //         )),
  //   );
  // }

  // Widget buildPostFooter() {
  //   return ListTile(
  //     leading: Container(
  //       width: 200,
  //       child: Row(
  //         children: [
  //           GestureDetector(
  //             onTap: () => print('like this post'),
  //             child: Icon(
  //               Icons.favorite_border,
  //               size: 28.0,
  //               color: Colors.pink,
  //             ),
  //           ),
  //           Padding(padding: EdgeInsets.only(right: 5.0)),
  //           Text(
  //             '56K',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.normal,
  //               fontSize: 18,
  //             ),
  //           ),
  //           Padding(padding: EdgeInsets.only(right: 20.0)),
  //           GestureDetector(
  //             onTap: () => print('showing comments'),
  //             child: Icon(
  //               Icons.chat,
  //               size: 28.0,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     trailing: IconButton(
  //         onPressed: () => print('deleting post'),
  //         icon: Icon(
  //           Icons.save,
  //           color: Colors.white,
  //         )),
  //   );
  // }

  Widget builSearchResult() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snap) {
        if (!snap.hasData) {
          return circularProgress();
        }
        List<UserResult> searchResults = [];
        snap.data.documents.forEach((doc) {
          User user = User.fromDocument(doc);
          UserResult searchResult = UserResult(user: user);
          searchResults.add(searchResult);
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    builSearchResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: buildSearchField(),
      body: searchResultsFuture == null ? buildFeed() : builSearchResult(),
    );
  }

  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .document(currentUser.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .getDocuments();
    List<ActivityFeedItem> feedItems = [];
    snapshot.documents.forEach((doc) {
      feedItems.add(ActivityFeedItem.fromDocument(doc));
      // print('Activity Feed Item: ${doc.data}');
    });
    return feedItems;
  }
}

class UserResult extends StatelessWidget {
  final User user;

  const UserResult({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => showProfile(context, profileId: user.id),
            child: ListTile(
              tileColor: Colors.white,
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                user.displayName,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.username,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
