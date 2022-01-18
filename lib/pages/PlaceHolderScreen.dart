import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlaceHolderScreen extends StatelessWidget {
  final Image supriseMe = Image.asset("assets/CheckOnThem_SupriseMe.jpg");

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(130, 9, 50, 1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 16),
            child: Text(
              "Stay Connected To Your People",
              style:
              TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              textScaleFactor: 1.75,
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image(
                  image: supriseMe.image,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 16, 5, 16),
            child: Text(
              "\"Communication is merely an exchange of information, but connection is an exchange of our humanity.\"\n\n-Sean Stephenson",
              style:
              TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              textScaleFactor: 1.50,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}