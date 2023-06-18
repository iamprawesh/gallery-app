import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:galleryapp/screens/search_page.dart';

import 'main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
          (Route<dynamic> route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              height: 220,
            ),
          ).animate().scale(duration: 1.seconds),
          RichText(
            text: TextSpan(
                text: 'Ga',
                style: TextStyle(color: Colors.red, fontSize: 25),
                children: <TextSpan>[
                  TextSpan(
                      text: 'll',
                      style: TextStyle(color: Colors.green, fontSize: 25),
                      recognizer: TapGestureRecognizer()..onTap = () {}),
                  TextSpan(
                      text: 'ery',
                      style: TextStyle(color: Colors.purple, fontSize: 25),
                      recognizer: TapGestureRecognizer()..onTap = () {}),
                  TextSpan(
                      text: ' App',
                      style: TextStyle(color: Colors.yellow, fontSize: 25),
                      recognizer: TapGestureRecognizer()..onTap = () {}),
                ]),
          ).animate().scaleX(duration: 1.ms),
        ],
      ),
    );
  }
}
