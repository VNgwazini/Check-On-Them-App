import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Check On Them!",
              style: TextStyle(
                color: Colors.white,
              ),
              textScaleFactor: 2.0,
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(130, 9, 50, 1.0),
    );
  }
}