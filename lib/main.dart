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
  Image supriseMe = Image.asset("assets/CheckOnThem_SupriseMe.jpg");

  @override
  Widget build(BuildContext context) {
    precacheImage(supriseMe.image, context);

    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 1)),
        builder: (context, AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return MaterialApp(home: Splash());
        }else{
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
                padding: EdgeInsets.fromLTRB(0.0, 75.0, 0.0, 75.0),
                child: HomeScreen(),
              ),
              backgroundColor: Color.fromRGBO(130, 9, 50, 1.0),
            ),
          );
        }
        }
    );
  }
}

class Splash extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child:           Text("Check On Them!",
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


class HomeScreen extends StatelessWidget {
  Image supriseMe = Image.asset("assets/CheckOnThem_SupriseMe.jpg");

  void navToContacts(BuildContext context) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(130, 9, 50, 1.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5, 16, 5, 16),
            child: Text(
              "Stay Conntected To Your People",
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
                new IconButton(
                  icon: Image(
                    image: supriseMe.image,
                    fit: BoxFit.fill,
                  ),
                  iconSize: 350,
                  onPressed: () async { navToContacts(context); },
                ),
                TextButton(
                  onPressed: () async { navToContacts(context); },
                  child: Text(
                    "Get Contact Suggestions",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Color.fromRGBO(130, 9, 50, 1.0)),
                    textScaleFactor: 1.75,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
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
    _contacts = await ContactsService.getContacts(
      //make call faster by excluding thumbnails
      withThumbnails: false,
    );
    return _contacts;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _getContacts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // print(snapshot.data.toString().length);
          if (snapshot.data == null) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          } else {

            //First Suggestion
            var random = new Random();
            var randomInt1 = random.nextInt(_contacts.length);
            var randomInt2 = random.nextInt(_contacts.length);
            Contact randomContact = new Contact();
            Contact randomContact2 = new Contact();

            if( _contacts.elementAt(randomInt1).phones!.isNotEmpty && randomInt2 != randomInt1){
              //good value
              randomContact = _contacts
                  .elementAt(randomInt1);
            }else{
              while(_contacts.elementAt(randomInt1).phones!.isEmpty){
                if(_contacts.elementAt(randomInt1).phones!.isNotEmpty && randomInt2 != randomInt1){
                  break;
                }else{
                  //recalculate random index
                  randomInt1 = random.nextInt(_contacts.length);
                }
              }
              //update suggestion with good value
              randomContact = _contacts.elementAt(randomInt1);
            }


            if( _contacts.elementAt(randomInt2).phones!.isNotEmpty && randomInt2 != randomInt1){
              //good value
              randomContact2 = _contacts
                  .elementAt(randomInt2);
            }else{
              while(_contacts.elementAt(randomInt2).phones!.isEmpty){
                if(_contacts.elementAt(randomInt2).phones!.isNotEmpty && randomInt2 != randomInt1){
                  break;
                }else{
                  //recalculate random index
                  randomInt2 = random.nextInt(_contacts.length);
                }
              }
              //update suggestion with good value
              randomContact2 = _contacts.elementAt(randomInt2);
            }

            String contactName = randomContact.displayName.toString();
            String contactPhoneNumber =
                randomContact.phones!.first.value.toString();

            String contactName2 = randomContact2.displayName.toString();
            String contactPhoneNumber2 =
                randomContact2.phones!.first.value.toString();

            return Scaffold(
              appBar: AppBar(
                title: (Text(
                  "Home",
                  style: TextStyle(color: Colors.white),
                )),
                backgroundColor: Color.fromRGBO(130, 9, 50, 1.0),
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
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.white),
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
                                    backgroundImage:
                                        MemoryImage(randomContact.avatar!),
                                  )
                                : CircleAvatar(
                                    child: Text(randomContact.initials()),
                                    backgroundColor:
                                    Color.fromRGBO(130, 9, 50, 1.0),
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
                                child: contactName.contains(" ") ? Text(
                                  "Feel like catching up with " +
                                      contactName.substring(
                                          0,
                                          randomContact.displayName!
                                              .indexOf(" ")) +
                                      "?\n\nCheck On Them! ",
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(130, 9, 50, 1.0),
                                  ),
                                  textScaleFactor: 1.25,
                                  textAlign: TextAlign.center,
                                )
                                : Text(
                                  "Feel like catching up with " +
                                      contactName +
                                      "?\n\nCheck On Them! ",
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(130, 9, 50, 1.0),
                                  ),
                                  textScaleFactor: 1.25,
                                  textAlign: TextAlign.center,
                                ),
                              )),
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceAround,
                            children: [
                              FlatButton(
                                textColor: Color.fromRGBO(130, 9, 50, 1.0),
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
                                textColor: Color.fromRGBO(130, 9, 50, 1.0),
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
                                    backgroundColor:
                                    Color.fromRGBO(130, 9, 50, 1.0),
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
                                child: contactName2.contains(" ") ? Text(
                                  "Feel like catching up with " +
                                      contactName2.substring(
                                          0,
                                          randomContact2.displayName!
                                              .indexOf(" ")) +
                                      "?\n\nCheck On Them! ",
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(130, 9, 50, 1.0),
                                  ),
                                  textScaleFactor: 1.25,
                                  textAlign: TextAlign.center,
                                )
                                    : Text(
                                  "Feel like catching up with " +
                                      contactName2 +
                                      "?\n\nCheck On Them! ",
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(130, 9, 50, 1.0),
                                  ),
                                  textScaleFactor: 1.25,
                                  textAlign: TextAlign.center,
                                ),
                              )),
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceAround,
                            children: [
                              FlatButton(
                                textColor: Color.fromRGBO(130, 9, 50, 1.0),
                                onPressed: () {
                                  // Perform some action
                                },
                                child: IconButton(
                                  onPressed: () =>
                                      launch('tel:' + contactPhoneNumber2),
                                  icon: Icon(Icons.phone_forwarded),
                                ),
                              ),
                              FlatButton(
                                textColor: Color.fromRGBO(130, 9, 50, 1.0),
                                onPressed: () {
                                  // Perform some action
                                },
                                child: IconButton(
                                  onPressed: () =>
                                      launch('sms:' + contactPhoneNumber2),
                                  icon: Icon(Icons.textsms_outlined),
                                ),
                              ),
                            ],
                          ),
                          // Image.asset('assets/card-sample-image-2.jpg'),
                        ],
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MaterialApp(
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
                                          padding: EdgeInsets.fromLTRB(0.0, 75.0, 0.0, 75.0),
                                          child: HomeScreen(),
                                        ),
                                        backgroundColor: Color.fromRGBO(130, 9, 50, 1.0),
                                      ),
                                    )));
                          },
                          child: Text("Back",
                          style: TextStyle(
                              color: Color.fromRGBO(130, 9, 50, 1.0),
                          ),
                            textScaleFactor: 1.25,
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => super.widget));

                          },
                          child: Text("Refresh",
                            style: TextStyle(
                              color: Color.fromRGBO(130, 9, 50, 1.0),
                            ),
                            textScaleFactor: 1.25,
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                color: Color.fromRGBO(130, 9, 50, 1.0),
              ),
              // : Center(child: const CircularProgressIndicator()),
              backgroundColor: Color.fromRGBO(130, 9, 50, 1.0),
            );
          }
        },
      ),
    );
  }
}
