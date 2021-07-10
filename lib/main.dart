import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:url_launcher/url_launcher.dart';

//app icon = <a href='https://www.freepik.com/photos/technology'>Technology photo created by wayhomestudio - www.freepik.com</a>
// <a href='https://www.freepik.com/photos/human'>Human photo created by wayhomestudio - www.freepik.com</a>
// <a href='https://www.freepik.com/photos/people'>People photo created by wayhomestudio - www.freepik.com</a>
// <a href='https://www.freepik.com/photos/people'>People photo created by wayhomestudio - www.freepik.com</a>
// <a href='https://www.freepik.com/photos/book'>Book photo created by wayhomestudio - www.freepik.com</a>
// <a href='https://www.freepik.com/photos/people'>People photo created by wayhomestudio - www.freepik.com</a>
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //text in top bar of app
      title: 'Check On Them!',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Check On Them!',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(0.0, 75.0, 0.0, 75.0),
          child: HomeScreen(),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child:  Column(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(10,16,10,16),
            child:           Text(
              "What type of contact suggestions are you looking for today?",
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
              textScaleFactor: 1.5,
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new IconButton(
                      icon: Image(
                        image: AssetImage(
                            'assets/CheckOnThem_Friend.jpg'),
                        fit: BoxFit.fill,
                      ),
                      iconSize: 150,
                      onPressed: () async {
                        //request permission via async function and store response in appropriate object
                        final PermissionStatus permissionStatus =
                        await _getPermission();
                        //check if permission status is granted
                        if (permissionStatus == PermissionStatus.granted) {
                          //access contacts here
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactsPage()));
                        }
                        //if permission is not granted, then show a dialog asking the user to grant access
                        else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CupertinoAlertDialog(
                                    title: Text('Permission error'),
                                    content: Text(
                                        'Please grant contact access permission privileges to the "Check On Them - App" in the system settings'),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: Text('OK'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      )
                                    ],
                                  ));
                        }
                      },
                    ),
                    Text(
                      // 'Ready to reconnect with the people in your contacts?\n\nTap here to, Check On Them!',
                        "Friend",
                        style: TextStyle(fontWeight: FontWeight.w700),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new IconButton(
                      icon: Image(
                        image: AssetImage(
                            'assets/CheckOnThem_Family.jpg'),
                        fit: BoxFit.fill,
                      ),
                      iconSize: 150,
                      onPressed: () async {
                        //request permission via async function and store response in appropriate object
                        final PermissionStatus permissionStatus =
                        await _getPermission();
                        //check if permission status is granted
                        if (permissionStatus == PermissionStatus.granted) {
                          //access contacts here
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactsPage()));
                        }
                        //if permission is not granted, then show a dialog asking the user to grant access
                        else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CupertinoAlertDialog(
                                    title: Text('Permission error'),
                                    content: Text(
                                        'Please grant contact access permission privileges to the "Check On Them - App" in the system settings'),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: Text('OK'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      )
                                    ],
                                  ));
                        }
                      },
                    ),
                    Text(
                      // 'Ready to reconnect with the people in your contacts?\n\nTap here to, Check On Them!',
                        "Family",
                        style: TextStyle(fontWeight: FontWeight.w700),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new IconButton(
                      icon: Image(
                        image: AssetImage(
                            'assets/CheckOnThem_Colleague.jpg'),
                        fit: BoxFit.fill,
                      ),
                      iconSize: 150,
                      onPressed: () async {
                        //request permission via async function and store response in appropriate object
                        final PermissionStatus permissionStatus =
                        await _getPermission();
                        //check if permission status is granted
                        if (permissionStatus == PermissionStatus.granted) {
                          //access contacts here
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactsPage()));
                        }
                        //if permission is not granted, then show a dialog asking the user to grant access
                        else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CupertinoAlertDialog(
                                    title: Text('Permission error'),
                                    content: Text(
                                        'Please grant contact access permission privileges to the "Check On Them - App" in the system settings'),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: Text('OK'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      )
                                    ],
                                  ));
                        }
                      },
                    ),
                    Text(
                      // 'Ready to reconnect with the people in your contacts?\n\nTap here to, Check On Them!',
                        "Colleague",
                        style: TextStyle(fontWeight: FontWeight.w700),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new IconButton(
                      icon: Image(
                        image: AssetImage(
                            'assets/CheckOnThem_SupriseMe.jpg'),
                        fit: BoxFit.fill,
                      ),
                      iconSize: 150,
                      onPressed: () async {
                        //request permission via async function and store response in appropriate object
                        final PermissionStatus permissionStatus =
                        await _getPermission();
                        //check if permission status is granted
                        if (permissionStatus == PermissionStatus.granted) {
                          //access contacts here
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactsPage()));
                        }
                        //if permission is not granted, then show a dialog asking the user to grant access
                        else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CupertinoAlertDialog(
                                    title: Text('Permission error'),
                                    content: Text(
                                        'Please grant contact access permission privileges to the "Check On Them - App" in the system settings'),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: Text('OK'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      )
                                    ],
                                  ));
                        }
                      },
                    ),
                    Text(
                      // 'Ready to reconnect with the people in your contacts?\n\nTap here to, Check On Them!',
                        "Suprise Me!",
                        style: TextStyle(fontWeight: FontWeight.w700),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //future is an object that will be populated or available later
  Future<PermissionStatus> _getPermission() async {
    //specify and store the type of permission we expect to store in our permission object
    final PermissionStatus permission = await Permission.contacts.status;
    //if the permission is neither granted or denied
    if (permission != PermissionStatus.granted) {
      //map the permission to it corresponding status
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      //return the specific status for this particular permission, unless its null
      return permissionStatus[Permission.contacts] ??
          //then return a denied status instead;
          PermissionStatus.denied;
    } else {
      return permission;
    }
  }
}

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late Iterable<Contact> _contacts;

  @override
  void initState() {
    getContacts().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  Future<void> getContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    var random = new Random();
    Contact randomContact =
        _contacts.elementAt(random.nextInt(_contacts.length));
    String contactName = randomContact.displayName.toString();
    String contactPhoneNumber = randomContact.phones!.first.value.toString();

    return Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
                //https://media.giphy.com/media/TJxrHj7AurjqljHSv2/giphy.gif
                image: new AssetImage("assets/dog_On_phone.webp"),
                fit: BoxFit.fill)),
        child: Scaffold(
          appBar: AppBar(
            title: (Text("Today's Contact Suggestion")),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: randomContact != null
              ? Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(20.0, 75.0, 20.0, 0.0),
                  child: Card(
                    color: Colors.amber,
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: (randomContact.avatar != null &&
                                  randomContact.avatar!.isNotEmpty)
                              ? CircleAvatar(
                                  backgroundImage:
                                      MemoryImage(randomContact.avatar!),
                                )
                              : CircleAvatar(
                                  child: Text(randomContact.initials()),
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                ),
                          title: Text(contactName ?? ''),
                          subtitle: Text(
                            contactPhoneNumber,
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "Feel like catching up with " +
                                    contactName +
                                    "?\n\nCheck On Them! ",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                                textScaleFactor: 1.0,
                                textAlign: TextAlign.center,
                              ),
                            )),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceAround,
                          children: [
                            FlatButton(
                              textColor: const Color(0xFF6200EE),
                              onPressed: () {
                                // Perform some action
                              },
                              child: IconButton(
                                onPressed: () =>
                                    launch('tel:' + contactPhoneNumber),
                                icon: Icon(Icons.phone_forwarded),
                              ),
                            ),
                            FlatButton(
                              textColor: const Color(0xFF6200EE),
                              onPressed: () {
                                // Perform some action
                              },
                              child: IconButton(
                                onPressed: () =>
                                    launch('sms:' + contactPhoneNumber),
                                icon: Icon(Icons.textsms_outlined),
                              ),
                            ),
                          ],
                        ),
                        // Image.asset('assets/card-sample-image-2.jpg'),
                      ],
                    ),
                  ),
                )
              : Center(child: const CircularProgressIndicator()),
          backgroundColor: Colors.transparent,
        ));
  }
}
