import 'package:flutter/material.dart';
import 'package:flutter_social_app/pages/home.dart';

void main() {
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
