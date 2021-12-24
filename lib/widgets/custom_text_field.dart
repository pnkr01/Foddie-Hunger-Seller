import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final IconData? iconData;
  final String? hintText;
  bool isobsure;
  bool? isenable;
  final TextInputType? keytype;
  CustomTextField({
    this.textEditingController,
    this.iconData,
    this.hintText,
    this.isenable,
    required this.isobsure,
    this.keytype,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: TextFormField(
        controller: textEditingController,
        enabled: isenable,
        keyboardType: keytype,
        obscureText: isobsure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            iconData,
            color: Colors.blue,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
        ),
      ),
    );
  }
}
