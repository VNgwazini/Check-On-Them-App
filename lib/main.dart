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
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(0.0, 75.0, 0.0, 75.0),
          child: HomeScreen(),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 16, 10, 16),
            child: Text(
              "What type of contact suggestions are you looking for today?",
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              textScaleFactor: 1.75,
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
                        image: AssetImage('assets/CheckOnThem_Friend.jpg'),
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
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white),
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new IconButton(
                      icon: Image(
                        image: AssetImage('assets/CheckOnThem_Family.jpg'),
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
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white),
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new IconButton(
                      icon: Image(
                        image: AssetImage('assets/CheckOnThem_Colleague.jpg'),
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
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white),
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new IconButton(
                      icon: Image(
                        image: AssetImage('assets/CheckOnThem_SupriseMe.jpg'),
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
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.white),
                        textScaleFactor: 1.5,
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
    _getContacts().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  Future<Iterable<Contact>> _getContacts() async {
    _contacts = await ContactsService.getContacts();
    return _contacts;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        child: FutureBuilder(
          future: _getContacts(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            print(snapshot.data.toString().length);
            if(snapshot.data == null){
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: CircularProgressIndicator()
                    ),
                    Container(
                      child: Text("Building your suggestions...",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                        textScaleFactor: 0.5,
                      ),
                    ),
                  ],
                ),
              );
            }else{

              //First Suggestion
              var random = new Random();
              Contact randomContact =
              snapshot.data.elementAt(random.nextInt(snapshot.data.toString().length-1));
              //recalculate suggestion if null
              if(randomContact== null){
                while(randomContact == null){
                  randomContact =
                      snapshot.data.elementAt(random.nextInt(snapshot.data.toString().length-1));
                  if(randomContact.displayName != null){
                    break;
                  }
                }
              }
              String contactName = randomContact.displayName.toString();
              String contactPhoneNumber = randomContact.phones!.first.value.toString();

              //Second Suggestion
              Contact randomContact2 =
              snapshot.data.elementAt(random.nextInt(snapshot.data.toString().length-1));
              //recalculate suggestion if null
              if(randomContact2 == null){
                while(randomContact2.displayName == null){
                  randomContact2 =
                      snapshot.data.elementAt(random.nextInt(snapshot.data.toString().length-1));
                  if(randomContact2.displayName != null){
                    break;
                  }
                }
              }
              String contactName2 = randomContact2.displayName.toString();
              String contactPhoneNumber2 = randomContact2.phones!.first.value.toString();


              return Scaffold(
                appBar: AppBar(
                  title: (Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
                  )),
                  backgroundColor: Colors.black,
                  elevation: 0,
                ),
                body: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 100.0),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Contact Suggestions",
                        style:
                        TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                        textScaleFactor: 1.75,
                        textAlign: TextAlign.center,
                      ),
                      Card(
                        color: Colors.white,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: (randomContact.avatar != null &&
                                  randomContact.avatar!.isNotEmpty)
                                  ? CircleAvatar(
                                backgroundImage: MemoryImage(randomContact.avatar!),
                              )
                                  : CircleAvatar(
                                child: Text(randomContact.initials()),
                                backgroundColor: Theme.of(context).accentColor,
                              ),
                              title: Text(
                                contactName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textScaleFactor: 1.50,
                              ),
                              subtitle: Text(
                                contactPhoneNumber,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.6)),
                                textScaleFactor: 1.25,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: Text(
                                    "Feel like catching up with " +
                                        contactName.substring(0,randomContact2.displayName!.indexOf(" ")) +
                                        "?\n\nCheck On Them! ",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    textScaleFactor: 1.25,
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                            ButtonBar(
                              alignment: MainAxisAlignment.spaceAround,
                              children: [
                                FlatButton(
                                  textColor: Colors.blue,
                                  onPressed: () {
                                    // Perform some action
                                  },
                                  child: IconButton(
                                    onPressed: () => launch('tel:' + contactPhoneNumber),
                                    icon: Icon(Icons.phone_forwarded),
                                  ),
                                ),
                                FlatButton(
                                  textColor: Colors.blue,
                                  onPressed: () {
                                    // Perform some action
                                  },
                                  child: IconButton(
                                    onPressed: () => launch('sms:' + contactPhoneNumber),
                                    icon: Icon(Icons.textsms_outlined),
                                  ),
                                ),
                              ],
                            ),
                            // Image.asset('assets/card-sample-image-2.jpg'), Potential space for adds??
                          ],
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: (randomContact2.avatar != null &&
                                  randomContact2.avatar!.isNotEmpty)
                                  ? CircleAvatar(
                                backgroundImage:
                                MemoryImage(randomContact2.avatar!),
                              )
                                  : CircleAvatar(
                                child: Text(randomContact2.initials()),
                                backgroundColor: Theme.of(context).accentColor,
                              ),
                              title: Text(
                                contactName2,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textScaleFactor: 1.50,
                              ),
                              subtitle: Text(
                                contactPhoneNumber2,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.6)),
                                textScaleFactor: 1.25,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: Text(
                                    "Feel like catching up with " +
                                        contactName2.substring(0,randomContact2.displayName!.indexOf(" ")) +
                                        "?\n\nCheck On Them! ",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    textScaleFactor: 1.25,
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                            ButtonBar(
                              alignment: MainAxisAlignment.spaceAround,
                              children: [
                                FlatButton(
                                  textColor: Colors.blue,
                                  onPressed: () {
                                    // Perform some action
                                  },
                                  child: IconButton(
                                    onPressed: () => launch('tel:' + contactPhoneNumber2),
                                    icon: Icon(Icons.phone_forwarded),
                                  ),
                                ),
                                FlatButton(
                                  textColor: Colors.blue,
                                  onPressed: () {
                                    // Perform some action
                                  },
                                  child: IconButton(
                                    onPressed: () => launch('sms:' + contactPhoneNumber2),
                                    icon: Icon(Icons.textsms_outlined),
                                  ),
                                ),
                              ],
                            ),
                            // Image.asset('assets/card-sample-image-2.jpg'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  color: Colors.black,
                ),
                // : Center(child: const CircularProgressIndicator()),
                backgroundColor: Colors.black,
              );
            }
          },
        ),
    );
  }
}
