import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_settings/app_settings.dart';
// import 'package:settings_ui/settings_ui.dart';


//app icon = <a href='https://www.freepik.com/photos/technology'>Technology photo created by wayhomestudio - www.freepik.com</a>
// <a href='https://www.freepik.com/photos/human'>Human photo created by wayhomestudio - www.freepik.com</a>
// <a href='https://www.freepik.com/photos/people'>People photo created by wayhomestudio - www.freepik.com</a>
// <a href='https://www.freepik.com/photos/people'>People photo created by wayhomestudio - www.freepik.com</a>
// <a href='https://www.freepik.com/photos/book'>Book photo created by wayhomestudio - www.freepik.com</a>
// <a href='https://www.freepik.com/photos/people'>People photo created by wayhomestudio - www.freepik.com</a>
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static List<Widget> _widgetOptions = <Widget>[
    ContactsPage(),
    HomeScreen(),
    //TODO: implement settings page
    // SettingsListPage(title: 'Flutter Demo Home Page'),
  ];

  Image supriseMe = Image.asset("assets/CheckOnThem_SupriseMe.jpg");
  int screen = 0;
  late PermissionStatus _permissionStatus;

  void initState() {
      setState(() {});
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      navToContacts(context, index);
    });
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
            return MaterialApp(home: Splash());
          } else if(!_permissionStatus.isGranted){
            return MaterialApp(
              //text in top bar of app
              title: 'Check On Them!',
              // theme: ThemeData(
              //   brightness: Brightness.light,
              // ),
              // darkTheme: ThemeData(
              //   brightness: Brightness.dark,
              // ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 16),
                        child: Text(
                          "Oops! Something went wrong.",
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
                bottomNavigationBar: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_box),
                      label: 'Suggestions',
                    ),
                    // BottomNavigationBarItem(
                    //   icon: Icon(Icons.settings),
                    //   label: 'Settings',
                    // ),
                  ],
                  currentIndex: screen,
                  selectedItemColor: Color.fromRGBO(130, 9, 50, 1.0),
                  onTap: _onItemTapped,
                ),
                backgroundColor: Color.fromRGBO(130, 9, 50, 1.0),
              ),
            );
          }
          else {
            return MaterialApp(
              //text in top bar of app
              title: 'Check On Them!',
              // theme: ThemeData(
              //   brightness: Brightness.light,
              // ),
              // darkTheme: ThemeData(
              //   brightness: Brightness.dark,
              // ),
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
                bottomNavigationBar: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_box),
                      label: 'Suggestions',
                    ),
                    // BottomNavigationBarItem(
                    //   icon: Icon(Icons.settings),
                    //   label: 'Settings',
                    // ),
                  ],
                  currentIndex: screen,
                  selectedItemColor: Color.fromRGBO(130, 9, 50, 1.0),
                  onTap: _onItemTapped,
                ),
                backgroundColor: Color.fromRGBO(130, 9, 50, 1.0),
              ),
            );
          }
        });
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

class HomeScreen extends StatelessWidget {
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
  Image supriseMe = Image.asset("assets/CheckOnThem_SupriseMe.jpg");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _getContacts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // print(snapshot.data.toString().length);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          }else if(_contacts.isEmpty){
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 16),
                    child: Text(
                      "Oops! Something went wrong.",
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
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 16, 5, 5),
                          child: TextButton(
                            onPressed: () {
                              openAppSettings();
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
            );
          } else {
            //First Suggestion
            var random = new Random();
            var randomInt1 = random.nextInt(_contacts.length);
            var randomInt2 = random.nextInt(_contacts.length);
            Contact randomContact = new Contact();
            Contact randomContact2 = new Contact();

            if (_contacts.elementAt(randomInt1).phones!.isNotEmpty &&
                randomInt2 != randomInt1) {
              //good value
              randomContact = _contacts.elementAt(randomInt1);
            } else {
              while (_contacts.elementAt(randomInt1).phones!.isEmpty) {
                if (_contacts.elementAt(randomInt1).phones!.isNotEmpty &&
                    randomInt2 != randomInt1) {
                  break;
                } else {
                  //recalculate random index
                  randomInt1 = random.nextInt(_contacts.length);
                }
              }
              //update suggestion with good value
              randomContact = _contacts.elementAt(randomInt1);
            }

            if (_contacts.elementAt(randomInt2).phones!.isNotEmpty &&
                randomInt2 != randomInt1) {
              //good value
              randomContact2 = _contacts.elementAt(randomInt2);
            } else {
              while (_contacts.elementAt(randomInt2).phones!.isEmpty) {
                if (_contacts.elementAt(randomInt2).phones!.isNotEmpty &&
                    randomInt2 != randomInt1) {
                  break;
                } else {
                  //recalculate random index
                  randomInt2 = random.nextInt(_contacts.length);
                }
              }
              if (randomInt2 == randomInt1) {
                while (randomInt2 == randomInt1) {
                  //recalculate random index
                  randomInt2 = random.nextInt(_contacts.length);
                }
              }
              if (_contacts.elementAt(randomInt2).phones!.isNotEmpty) {
                //update suggestion with good value
                randomContact2 = _contacts.elementAt(randomInt2);
              }
            }

            String contactName = randomContact.displayName.toString();
            String contactPhoneNumber =
                randomContact.phones!.first.value.toString();

            String contactName2 = randomContact2.displayName.toString();
            String contactPhoneNumber2 =
                randomContact2.phones!.first.value.toString();

            //TODO move this logic to a separate function
            //remove non digit characters from strings
            contactPhoneNumber = contactPhoneNumber.replaceAll("(", "");
            contactPhoneNumber = contactPhoneNumber.replaceAll(")", "");
            contactPhoneNumber = contactPhoneNumber.replaceAll(" ", "");
            contactPhoneNumber = contactPhoneNumber.replaceAll("-", "");

            //remove non digit characters from strings
            contactPhoneNumber2 = contactPhoneNumber2.replaceAll("(", "");
            contactPhoneNumber2 = contactPhoneNumber2.replaceAll(")", "-");
            contactPhoneNumber2 = contactPhoneNumber2.replaceAll(" ", "");
            contactPhoneNumber2 = contactPhoneNumber2.replaceAll("-", "");

            String urlLaunchBodyToken = Platform.isAndroid ? "?":"&";
            Uri message = Uri.parse(", you just crossed my mind and I wanted to see how you were doing these days!");

            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
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
                              child: contactName.contains(" ")
                                  ? Text(
                                "Feel like catching up with " +
                                    contactName.substring(
                                        0,
                                        randomContact.displayName!
                                            .indexOf(" ")) +
                                    "?\n\nCheck On Them! ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                  Color.fromRGBO(130, 9, 50, 1.0),
                                ),
                                textScaleFactor: 1.25,
                                textAlign: TextAlign.center,
                              )
                                  : Text(
                                "Feel like catching up with " +
                                    contactName +
                                    "?\n\nCheck On Them! ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                  Color.fromRGBO(130, 9, 50, 1.0),
                                ),
                                textScaleFactor: 1.25,
                                textAlign: TextAlign.center,
                              ),
                            )),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {

                              },
                              child: IconButton(
                                onPressed: () =>
                                    launch('tel:' + contactPhoneNumber),
                                icon: Icon(Icons.phone_forwarded),
                              ),
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(Color.fromRGBO(130, 9, 50, 1.0))
                              ),
                            ),
                            TextButton(
                              onPressed: () {

                              },
                              child: IconButton(
                                onPressed: () => contactName.contains(" ")
                                    ? launch("sms:" +
                                    contactPhoneNumber +
                                    urlLaunchBodyToken +
                                    "body=Hey%20" +
                                    contactName.substring(
                                        0,
                                        randomContact.displayName!
                                            .indexOf(" "))
                                    + message.toString())
                                    :launch("sms:" +
                                    contactPhoneNumber +
                                    urlLaunchBodyToken +
                                    "body=Hey%20" + contactName + message.toString())
                                ,
                                icon: Icon(Icons.textsms_outlined),
                              ),
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(Color.fromRGBO(130, 9, 50, 1.0))
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
                              child: contactName2.contains(" ")
                                  ? Text(
                                "Feel like catching up with " +
                                    contactName2.substring(
                                        0,
                                        randomContact2.displayName!
                                            .indexOf(" ")) +
                                    "?\n\nCheck On Them! ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                  Color.fromRGBO(130, 9, 50, 1.0),
                                ),
                                textScaleFactor: 1.25,
                                textAlign: TextAlign.center,
                              )
                                  : Text(
                                "Feel like catching up with " +
                                    contactName2 +
                                    "?\n\nCheck On Them! ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                  Color.fromRGBO(130, 9, 50, 1.0),
                                ),
                                textScaleFactor: 1.25,
                                textAlign: TextAlign.center,
                              ),
                            )),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {

                              },
                              child: IconButton(
                                onPressed: () =>
                                    launch('tel:' + contactPhoneNumber2),
                                icon: Icon(Icons.phone_forwarded),
                              ),
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(Color.fromRGBO(130, 9, 50, 1.0))
                              ),
                            ),
                            TextButton(
                              onPressed: () {

                              },
                              child: IconButton(
                                onPressed: () => contactName2.contains(" ")
                                    ? launch("sms:" +
                                    contactPhoneNumber2 +
                                    urlLaunchBodyToken +
                                    "body=Hey%20" +
                                    contactName2.substring(
                                        0,
                                        randomContact2.displayName!
                                            .indexOf(" "))
                                    + message.toString())
                                    :launch("sms:" +
                                    contactPhoneNumber2 +
                                    urlLaunchBodyToken +
                                    "body=Hey%20" + contactName2 + message.toString())
                                ,
                                icon: Icon(Icons.textsms_outlined),
                              ),
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(Color.fromRGBO(130, 9, 50, 1.0))
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
                          setState(() {
                          });
                        },
                        child: Text(
                          "More Suggestions",
                          style: TextStyle(
                            color: Color.fromRGBO(130, 9, 50, 1.0),
                          ),
                          textScaleFactor: 1.25,
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              color: Color.fromRGBO(130, 9, 50, 1.0),
            );
          }
        },
      ),
    );
  }
}

// class SettingsListPage extends StatefulWidget {
//   SettingsListPage({Key? key, required this.title}) : super(key: key);
//   final String title;
//   @override
//   _SettingsListPageState createState() => _SettingsListPageState();
// }
//
// class _SettingsListPageState extends State<SettingsListPage> {
//   bool isSwitched = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return SettingsList(
//       sections: [
//         //ToDo: Add list of languages
//         SettingsSection(
//           title: Text('System Settings'),
//           tiles: [
//             SettingsTile(
//               title: Text('Language'),
//               value: Text('English'),
//               leading: Icon(Icons.language),
//               onPressed: (BuildContext context) {},
//             ),
//           ],
//         ),
//         SettingsSection(
//           //ToDo: switch is reset on page load, not persistent
//         title: Text('Appearance'),
//           tiles: [
//             SettingsTile.switchTile(
//               title: Text('Dark Mode'),
//               leading: Icon(Icons.phone_android),
//               onToggle: (value) {
//                 setState(() {
//                   isSwitched = value;
//                 });
//               },initialValue: isSwitched,
//             ),
//           ],
//         ),
//         SettingsSection(
//           title: Text('Message'),
//           tiles: [
//             SettingsTile(
//               title: Text('Preset'),
//               value: Text('Crossed My Mind'),
//               leading: Icon(Icons.language),
//               onPressed: (BuildContext context) {},
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
