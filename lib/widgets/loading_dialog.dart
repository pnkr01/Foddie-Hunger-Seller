import 'package:flutter/material.dart';
import 'package:seller_app/widgets/progress_bar.dart';

class LoadingDialog extends StatelessWidget {
  final String? message;
  LoadingDialog({this.message});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          SizedBox(height: 15.0),
          Text(message! + "Please Wait.."),
        ],
      ),
    );
  }
}
