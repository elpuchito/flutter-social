import 'package:flutter/material.dart';

Widget circularProgress() {
  return Container(
    child: Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.pink),
      ),
    ),
  );
}

Widget linearProgress() {
  return Container(
    padding: EdgeInsets.only(bottom: 12),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.pink),
    ),
  );
}
