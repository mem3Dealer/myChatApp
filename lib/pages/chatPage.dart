// import 'dart:html';

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_chat_app/models/message.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/pages/register.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/widgets/chatMessages.dart';
import 'package:my_chat_app/widgets/messageTile.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:collection/collection.dart';
import 'package:my_chat_app/widgets/sendFieldandButton.dart';

class ChatPage extends StatefulWidget {
  String groupID;

  ChatPage(this.groupID);
  // ChatPage({Key? key, required this.groupID}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Stream<QuerySnapshot>? _chat;
  TextEditingController messageEditingController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference chat = FirebaseFirestore.instance.collection('chat');
  DataBaseService data = DataBaseService();
  ScrollController _scrollController = new ScrollController();
  String? senderId = FirebaseAuth.instance.currentUser?.uid;
  bool needsToScroll = false;
  Message message = Message();

  // var currentUserId = FirebaseAuth.instance.currentUser!.uid;
  List<Message>? listChat;
  List<MyUser>? listUsers;

  Future<void> addUser(String email, String name, String password) {
    return users.add({
      'email': email,
      'name': name,
      'password': password,
    }).then((value) => print('user added'));
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      if (listUsers == null) {
        final chatData = await data.getChat();
        final usersData = await data.getUsers();

        listChat = chatData.toList();
        listUsers = usersData?.reversed.toList();
        setState(() {});
      }
      // print(listChat);
      // print(listChat.toString());
    });
    super.initState();
  }

  Widget _chatMessages(List<Message> messageDataList) {
    return Container(
      child: listUsers == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              controller: _scrollController,
              reverse: true,
              shrinkWrap: true,
              itemCount: messageDataList.length,
              itemBuilder: (context, index) {
                // String localeTag =
                //     Localizations.localeOf(context).toLanguageTag();
                int _timeStamp = messageDataList[index].time!.seconds;
                var date =
                    DateTime.fromMillisecondsSinceEpoch(_timeStamp * 1000);
                var formattedDate =
                    DateFormat('HH:mm dd.MM.yy', 'ru').format(date);

                final message = messageDataList[index];

                return MessageTile(
                    time: formattedDate,
                    firstMessageOfAuthor: message.isFirst,
                    lastMessageOfAuthor: message.isLast,
                    author: message.isFirst
                        ? message.getUserName(message.sender, listUsers)
                        : '',
                    message: message.content,
                    sentByMe: senderId == message.sender);
              }),
    );
    ;
  }

  List<Message> makeMessagesDataList(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    List<Message>? _messages = snapshot.data?.docs
        .map<Message>((e) => Message.fromSnapshot(e))
        .toList();
    for (int i = 0; i < _messages!.length; i++) {
      if (i > 0 && i < _messages.length - 1)
        _messages[i].isFirst = _messages[i + 1].sender != _messages[i].sender;
      else
        _messages[i].isFirst = false;

      if (i > 0 && i < _messages.length)
        _messages[i].isLast = _messages[i - 1].sender != _messages[i].sender;
      else
        _messages[i].isLast = true;
    }
    return _messages;
  }

  String? getUserName(String uid) {
    return listUsers!
        .firstWhere((element) => element.uid == uid,
            orElse: () => MyUser(name: 'null name'))
        .name;
  }

  Widget buttonSend() {
    return GestureDetector(
      // behavior: HitTestBehavior.translucent,
      onTap: () {
        data.sendMessage(
            messageEditingController, senderId.toString(), widget.groupID);
        // print(snapshot.docs.length);
        setState(() {
          messageEditingController.text = '';
        });
        print('pressed');
      },
      child: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
            color: Colors.blueAccent, borderRadius: BorderRadius.circular(50)),
        child: Center(child: Icon(Icons.send, color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            listUsers?.firstWhere((element) => element.uid == senderId).name ??
                'Loading'),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: ElevatedButton(
          //     style: ButtonStyle(
          //         backgroundColor:
          //             MaterialStateProperty.all<Color>(Colors.amber.shade700)),
          //     child: Icon(Icons.exit_to_app),
          //     onPressed: () async {
          //       // await _auth.signOut();
          //       Navigator.pop(context);
          //     },
          //     // label: Text('Log out'),
          //   ),
          // )
        ],
      ),
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: data.testStream(widget.groupID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messageDataList = makeMessagesDataList(snapshot);
                  return Column(children: [
                    Expanded(child: _chatMessages(messageDataList)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        // height: 50,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.red,
                        child: Row(
                          // main AxisAlignment: MainAxisAlignment.start,
                          children: [
                            textField(messageEditingController),
                            buttonSend()
                          ],
                        ),
                      ),
                    ),
                  ]);
                } else {
                  // ? SingleChildScrollView(
                  //     child: Text(listChat.toString()))
                  return Container(child: Center(child: Text('loading...')));
                }
              })),
    );
  }

  // makeMessagesDataList(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {}
}

Widget textField(TextEditingController messageEditingController) {
  return Expanded(
    child: Container(
      child: TextField(
        controller: messageEditingController,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          // fillColor: Colors.pink,
          hintText: 'type here',
        ),
      ),
    ),
  );
}