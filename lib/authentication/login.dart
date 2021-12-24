import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/mainscreen/homepage.dart';
import 'package:seller_app/widgets/custom_text_field.dart';
import 'package:seller_app/widgets/errordialog.dart';
import 'package:seller_app/widgets/loading_dialog.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey();
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passEditingController = TextEditingController();
  formValidate() {
    if (_emailEditingController.text.isNotEmpty &&
        _passEditingController.text.isNotEmpty) {
      //login
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please fill correct email and password",
            );
          });
    }
  }

  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(
            message: "Checking Credentials ",
          );
        });
    User? currentUser;
    await firebaseAuth
        .signInWithEmailAndPassword(
      email: _emailEditingController.text.trim(),
      password: _passEditingController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: e!.message.toString(),
          );
        },
      );
    });
    if (currentUser != null) {
      //save data to firebase and locally as well.
      saveDataLocally(currentUser!).then((value) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
      });
    }
  }

  Future saveDataLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("Sellers")
        .doc(currentUser.uid)
        .get()
        .then((snap) async {
      sharedPreferences!.setString("uid", currentUser.uid);
      sharedPreferences!.setString("email", snap.data()!["sellerEmail"]);
      sharedPreferences!.setString("name", snap.data()!["sellerName"]);
      sharedPreferences!.setString("photourl", snap.data()!["sellerAvatorUrl"]);
      sharedPreferences!.setString("uid", currentUser.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("images/seller.png"),
            ),
            height: 300.0,
          ),
          Form(
            key: _globalKey,
            child: Column(
              children: [
                CustomTextField(
                  isobsure: false,
                  hintText: "Email",
                  iconData: Icons.email,
                  isenable: true,
                  keytype: TextInputType.emailAddress,
                  textEditingController: _emailEditingController,
                ),
                CustomTextField(
                  isobsure: true,
                  hintText: "Password",
                  iconData: Icons.email,
                  isenable: true,
                  keytype: TextInputType.emailAddress,
                  textEditingController: _passEditingController,
                ),
                SizedBox(height: 2.0),
                Container(
                  child: Container(
                    child: ElevatedButton(
                      onPressed: () {
                        formValidate();
                      },
                      child: Text(
                        "LogIn",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 100.0,
                          vertical: 15.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
