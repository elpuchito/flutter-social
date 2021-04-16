import 'package:flutter/material.dart';

Widget header(context,
    {bool isAppTittle = false, String tittleText, removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTittle ? 'Flutter Social' : tittleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTittle ? 'Signatra' : '',
        fontSize: isAppTittle ? 50 : 22,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
