import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/pages/home.dart';
import 'package:flutter_social_app/pages/test_video_signIn.dart';
import 'package:flutter_social_app/test_image_signin.dart';

void main() {
  // Firestore.instance.settings(timestampsInSnapshotsEnabled: true).then((_) {
  //   print('timestamps enabed in snapshot');
  // }, onError: (_) {
  //   print('error enabling timestamps');
  // });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Social',
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.teal[200],
      ),
      home: Home(),
    );
  }
}
