import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //text in top bar of app
      title: 'Check On Them - App',
      //content under the title in the main area
      home: SeeContactsButton(),
    );
  }
}
// //structure, displays a stateful widget
// class RandomWords extends StatefulWidget {
//   const RandomWords({Key? key}) : super(key: key);
//
//   @override
//   _RandomWordsState createState() => _RandomWordsState();
// }
// //content that populate structure, aka our stateful widget's state
// class _RandomWordsState extends State<RandomWords> {
//   //leading _ means this variable is private to class
//   //saves suggestions word parings
//   final _suggestions = <WordPair>[];
//   final _biggerFont = const TextStyle(fontSize: 18.0);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Startup Name Generator'),
//       ),
//       body: _buildSuggestions(),
//     );
//   }
//
// //builds listview that displays suggestions
//   Widget _buildSuggestions() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16.0),
//       //callback called once per suggested word pairing and places each suggestion into a listTile row;
//       itemBuilder: (context, i) {
//         if(i.isOdd) return const Divider();
//
//         //we divide by do to determine how many pairs we have
//         final index = i ~/ 2;
//         //if we reach the end of out pairings list
//         if(index >= _suggestions.length){
//           //make 10 more
//           _suggestions.addAll(generateWordPairs().take(10));
//         }
//         return _buildRow(_suggestions[index]);
//       }
//     );
//   }
//
//   //builds each row element which is a tile with text on it
//   Widget _buildRow(WordPair pair){
//     //create a tile item
//     return ListTile(
//       title: Text(
//         //what the tile says
//         pair.asPascalCase,
//         //the text stye is, similar to style={{CSS}} in react
//         style: _biggerFont,
//       ),
//     );
//   }
// }

class SeeContactsButton  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        onPressed: () async {
          //request permission via async function and store response in appropriate object
          final PermissionStatus permissionStatus = await _getPermission();
          //check if permission status is granted
          if(permissionStatus == PermissionStatus.granted){
            //access contacts here
          }
          //if permission is not granted, then show a dialog asking the user to grant access
          else{
            showDialog(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text('Permission error'),
                  content: Text('Please grant contact access permission privileges to the "Check On Them - App" in the system settings'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('OK'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                )
            );
          }
        },
      child: Container(child: Text('See Contacts')),
    );
  }

  //future is an object that will be populated or available later
  Future<PermissionStatus> _getPermission() async {
    //specify and store the type of permission we expect to store in our permission object
    final PermissionStatus permission = await Permission.contacts.status;
    //if the permission is neither granted or denied
    if(permission != PermissionStatus.granted && permission != PermissionStatus.denied){
      //map the permission to it corresponding status
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      //return the specific status for this particular permission, unless its null
      return permissionStatus[Permission.contacts] ??
          //then return a denied status instead;
        PermissionStatus.denied;
    }else{
      return permission;
    }
  }
}


