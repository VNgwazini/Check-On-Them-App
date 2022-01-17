import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:check_on_them_app/pages/SuggestionsScreen.dart';
import 'package:check_on_them_app/pages/PlaceHolderScreen.dart';
import 'package:check_on_them_app/pages/SplashScreen.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static List<Widget> _widgetOptions = <Widget>[
    SuggestionsScreen(),
    PlaceHolderScreen(),
    //TODO: implement settings page
  ];

  Image supriseMe = Image.asset("assets/CheckOnThem_SupriseMe.jpg");
  int screen = 0;
  late PermissionStatus _permissionStatus;

  void initState() {
    setState(() {});
    super.initState();
  }

  void navToContacts(BuildContext context, int index) async {
    //check if permission status is granted
    if(Platform.isAndroid){
      if (await _getPermission() == PermissionStatus.granted) {
        //nav to contacts tab
        setState(() {
          screen = index;
        });
      }
      //if permission is not granted, then open settings
      else {
        await openAppSettings().whenComplete(() =>
            navToContacts(context, index)
        );
      }
    }else{
      //nav to contacts tab
      setState(() {
        screen = index;
      });
    }
  }

  //future is an object that will be populated or available later
  Future<PermissionStatus> _getPermission() async {
    //specify and store the type of permission we expect to store in our permission object
    _permissionStatus = await Permission.contacts.request();
    //if the permission is neither granted or denied
    if (_permissionStatus != PermissionStatus.granted) {
      //map the permission to it corresponding status
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.contacts].request();
      //return the specific status for this particular permission, unless its null
      return permissionStatus[Permission.contacts] ??
          //then return a denied status instead;
          PermissionStatus.denied;
    } else {
      return _permissionStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(supriseMe.image, context);

    return FutureBuilder(
        future: _getPermission(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(home: SplashScreen());
          } else if(!_permissionStatus.isGranted){
            return MaterialApp(
              title: 'Check On Them!',
              home: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Check On Them!',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Color.fromRGBO(130, 9, 50, 1.0),
                  elevation: 0,
                ),
                body: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 16),
                          child: Text(
                            "Oops! Something went wrong.",
                            style:
                            TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                            textScaleFactor: 1.50,
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
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 16, 5, 5),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      AppSettings.openAppSettings();
                                      navToContacts(context, 0);
                                    });
                                  },
                                  child: Text(
                                    "Open Settings",
                                    style:
                                    TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromRGBO(130, 9, 50, 1.0)
                                    ),
                                    textScaleFactor: 1.50,
                                    textAlign: TextAlign.center,
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.white)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Text(
                                  "Please give us permission to access your contacts in the settings.\n",
                                  style:
                                  TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                                  textScaleFactor: 1.50,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                backgroundColor: Color.fromRGBO(130, 9, 50, 1.0),
              ),
            );
          }
          else {
            return MaterialApp(
              //text in top bar of app
              title: 'Check On Them!',
              home: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Check On Them!',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Color.fromRGBO(130, 9, 50, 1.0),
                  elevation: 0,
                ),
                body: Container(
                  alignment: Alignment.center,
                  child: _widgetOptions.elementAt(screen),
                ),
                backgroundColor: Color.fromRGBO(130, 9, 50, 1.0),
              ),
            );
          }
        });
  }
}