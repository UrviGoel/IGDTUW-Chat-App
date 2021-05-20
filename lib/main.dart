import 'package:flutter/material.dart';
import 'package:igdtuw_chat/helper/authenticate.dart';
import 'package:igdtuw_chat/helper/sharedpref.dart';
import 'package:igdtuw_chat/screens/chatrooms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'IGDTUW CHAT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: userIsLoggedIn != null
            ? userIsLoggedIn
                ? ChatRooms()
                : Authenticate()
            : Container(
                child: Center(
                child: Authenticate(),
              )));
  }
}
