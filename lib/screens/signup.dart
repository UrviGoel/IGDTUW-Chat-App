import 'package:flutter/material.dart';
import 'package:igdtuw_chat/helper/sharedpref.dart';
import 'package:igdtuw_chat/screens/chatrooms.dart';
import 'package:igdtuw_chat/services/auth.dart';
import 'package:igdtuw_chat/services/database.dart';
import 'package:igdtuw_chat/widgets.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = new TextEditingController();
  TextEditingController emailid = new TextEditingController();
  TextEditingController password = new TextEditingController();

  final formkey = GlobalKey<FormState>();
  bool isLoading = false;

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  signUp() async {
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
    }

    await authService
        .signUpWithEmailAndPassword(emailid.text, password.text)
        .then((result) {
      if (result != null) {
        print("${result.uid}");

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRooms()));
        Map<String, String> userDataMap = {
          "name": username.text,
          "email": emailid.text
        };

        databaseMethods.addUserInfo(userDataMap);

        HelperFunctions.saveUserLoggedInSharedPreference(true);
              HelperFunctions.saveUserNameSharedPreference(username.text);
              HelperFunctions.saveUserEmailSharedPreference(emailid.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key: formkey,
                          child: TextFormField(
                            controller: username,
                            validator: (val) {
                              return val.isEmpty || val.length < 3
                                  ? "Enter Username 3+ characters"
                                  : null;
                            },
                            decoration: InputDecoration(
                                hintText: "Username (eg. xyz123)",
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.lightGreen)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          ),
                        ),
                        TextFormField(
                          controller: emailid,
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@igdtuw.ac.in")
                                    .hasMatch(val)
                                ? null
                                : "Enter correct email";
                          },
                          decoration: InputDecoration(
                              hintText: "Email id",
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightGreen)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: password,
                          validator: (val) {
                            return val.length <= 6
                                ? "Enter Password 6+ characters"
                                : null;
                          },
                          decoration: InputDecoration(
                              hintText: "Password",
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightGreen)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        GestureDetector(
                          onTap: () {
                            signUp();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: Colors.green),
                            width: 230,
                            child: Text(
                              "Sign Up",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
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
                              "Already have account? ",
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
                                "Sign In",
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
              ));
  }
}
