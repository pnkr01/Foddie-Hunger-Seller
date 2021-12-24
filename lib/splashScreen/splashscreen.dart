import 'dart:async';
import 'package:flutter/material.dart';
import 'package:seller_app/authentication/auth_screen.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/mainscreen/homepage.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  setTimer() {
    Timer(Duration(seconds: 2), () async {
      if (firebaseAuth.currentUser != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AuthScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("images/splash.jpg"),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Sell Food Online",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40.0,
                  fontFamily: "Lobster",
                  color: Colors.blueAccent,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
