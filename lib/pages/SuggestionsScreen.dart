import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:math';
import 'package:contacts_service/contacts_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_settings/app_settings.dart';
import 'package:remove_emoji/remove_emoji.dart';


class SuggestionsScreen extends StatefulWidget {
  @override
  _SuggestionsScreenState createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
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
            return OopsNoContacts();
          } else {
            var remove = RemoveEmoji();
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

            String contactName = remove.removemoji(randomContact.displayName.toString());
            String contactPhoneNumber =
            randomContact.phones!.first.value.toString();

            String contactName2 = remove.removemoji(randomContact2.displayName.toString());
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

            return SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                            child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Expanded(
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        // Text(
                                        //   "Your Contact Suggestions",
                                        //   style: TextStyle(
                                        //       fontWeight: FontWeight.w700, color: Colors.white),
                                        //   textScaleFactor: 1.75,
                                        //   textAlign: TextAlign.center,
                                        // ),
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
                                            Center(
                                              child:TextButton(
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
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]
                            ),
                            color: Color.fromRGBO(130, 9, 50, 1.0),
                          )
                      )
                    ]
                )
            );
          }
        },
      ),
    );
  }
}

class OopsNoContacts extends StatelessWidget{
  final Image supriseMe = Image.asset("assets/CheckOnThem_SupriseMe.jpg");

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        AppSettings.openAppSettings();
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
                      "We couldn't find any contacts on your device. Please try again.\n",
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
    );
  }
}