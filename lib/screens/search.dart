import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:igdtuw_chat/helper/constants.dart';
import 'package:igdtuw_chat/helper/sharedpref.dart';
import 'package:igdtuw_chat/screens/chat.dart';
import 'package:igdtuw_chat/services/database.dart';
import 'package:igdtuw_chat/widgets.dart';

class Search extends StatefulWidget {

  final String myname;

  Search({this.myname}); 

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  bool isLoading = false;
  TextEditingController searchEditingController = new TextEditingController();
  bool haveUserSearched = false;
  QuerySnapshot searchResultSnapshot;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  initiateSearch() async {

    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByName(searchEditingController.text)
          .then((snapshot){
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");

        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList(){
    return haveUserSearched ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchResultSnapshot.documents.length,
        itemBuilder: (context, index){
          print("Here");
          print("${searchResultSnapshot.documents[index].data["name"]}");
        return userTile(
          searchResultSnapshot.documents[index].data["name"],
          searchResultSnapshot.documents[index].data["email"],
        );
        }) : Container();
  }

  sendMessage(String userName) async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    print(Constants.myName);
    List<String> users = ["urvi157",userName];

    String chatRoomId = getChatRoomId(Constants.myName,userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => Chat(
        chatRoomId: chatRoomId,
      )
    ));

  }

  Widget userTile(String userName,String userEmail){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Text("Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) :  Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Colors.grey[400],
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchEditingController,
                      decoration: InputDecoration(
                        hintText: "Search username ...",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF757575),
                              const Color(0xFF616161)
                            ],
                            begin: FractionalOffset.topLeft,
                            end: FractionalOffset.bottomRight
                          ),
                          borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(9),
                        child: Icon(Icons.search, color: Colors.white,)
                        //Image.asset("assets/images/search_white.png",
                        //   height: 25, width: 25,)
                          ),
                  )
                ],
              ),
            ),
            userList()
          ],
        ),
      ),
    );
  }
}