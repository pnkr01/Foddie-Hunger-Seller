import 'package:flutter/material.dart';
import 'package:seller_app/authentication/auth_screen.dart';
import 'package:seller_app/global/global.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey,
                Colors.pink,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          sharedPreferences!.getString("name")!,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            firebaseAuth.signOut().then((value) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => AuthScreen()));
            });
          },
          child: Text("Sign Out"),
        ),
      ),
    );
  }
}
