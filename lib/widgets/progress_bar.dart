import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    padding: EdgeInsets.only(top: 12.0),
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      backgroundColor: Colors.blue,
      valueColor: AlwaysStoppedAnimation(Colors.red),
    ),
  );
}
