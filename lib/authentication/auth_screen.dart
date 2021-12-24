import 'package:flutter/material.dart';
import 'package:seller_app/authentication/login.dart';
import 'package:seller_app/authentication/register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
            "Foddie Hunger",
            style: TextStyle(
              fontSize: 30.0,
              fontFamily: "Lobster",
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            automaticIndicatorColorAdjustment: true,
            indicatorColor: Colors.redAccent,
            indicatorWeight: 5.0,
            tabs: [
              Tab(
                icon: Icon(Icons.login),
                text: "LogIn",
              ),
              Tab(
                icon: Icon(Icons.app_registration),
                text: "Register",
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey,
                Colors.pink,
              ],
            ),
          ),
          child: TabBarView(
            children: [
              LogInScreen(),
              RegisterScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
