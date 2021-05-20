import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:igdtuw_chat/helper/sharedpref.dart';
import 'package:igdtuw_chat/screens/chatrooms.dart';
import 'package:igdtuw_chat/screens/forgotpassword.dart';
import 'package:igdtuw_chat/services/auth.dart';
import 'package:igdtuw_chat/services/database.dart';
import 'package:igdtuw_chat/widgets.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailid = new TextEditingController();
  TextEditingController password = new TextEditingController();

  final formkey = GlobalKey<FormState>();
  bool isLoading = false;

  signIn() async {
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await AuthService()
          .signInWithEmailAndPassword(emailid.text, password.text)
          .then((value) async {
        if (value != null) {
          QuerySnapshot userInfoSnapshot =
              await DatabaseMethods().getUserInfo(emailid.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data["name"]);
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.documents[0].data["email"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRooms()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: isLoading
            ? Container(child: Center(child: CircularProgressIndicator()))
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: emailid,
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@igdtuw.ac.in")
                                      .hasMatch(val)
                                  ? null
                                  : "Please Enter Correct Email";
                            },
                            decoration: InputDecoration(
                                hintText: "Email id",
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.lightGreen)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          ),
                          TextFormField(
                            controller: password,
                            obscureText: true,
                            validator: (val) {
                              return val.length >= 6
                                  ? null
                                  : "Enter Password 6+ characters";
                            },
                            decoration: InputDecoration(
                                hintText: "Password",
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.lightGreen)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          ),
                          SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()));
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          GestureDetector(
                            onTap: () {
                              signIn();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.green),
                              width: 230,
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have account? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.toggle();
                                },
                                child: Text(
                                  "Register now",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}
