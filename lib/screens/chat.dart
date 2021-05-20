import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:igdtuw_chat/helper/constants.dart';
import 'package:igdtuw_chat/services/database.dart';
import 'package:igdtuw_chat/widgets.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;

  Chat({this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();

  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
              );
            }) : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green, title: Text("Kajal126")),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          decoration: InputDecoration(
                              hintText: "Type here ...",
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                          ),
                        )),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.green[300],
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.send, color: Colors.white, size: 18,),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 20,
          right: sendByMe ? 20 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 20)
            : EdgeInsets.only(right: 20),
        padding: EdgeInsets.only(
            top: 15, bottom: 15, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(21),
                topRight: Radius.circular(21),
                bottomLeft: Radius.circular(21)
            ) :
            BorderRadius.only(
        topLeft: Radius.circular(21),
          topRight: Radius.circular(21),
          bottomRight: Radius.circular(21)),
            gradient: LinearGradient(
              colors: sendByMe ? [
                const Color(0xFFA5D6A7),
                const Color(0xFF81C784)
              ]
                  : [
                const Color(0xFFD6D6D6),
                const Color(0xFFBDBDBD)
              ],
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w300)),
      ),
    );
  }
}