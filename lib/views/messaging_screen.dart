import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/services/services.dart';
import 'package:reflex/views/share_photo_screen.dart';
import 'package:reflex/widgets/widget.dart';

class MessagingScreen extends StatefulWidget {
  final String _name;
  final String _profilePhoto;
  final String _userId;
  MessagingScreen(this._name, this._profilePhoto, this._userId);

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  String _roomId = '';
  TextEditingController _textController = TextEditingController();
  final _controller = ScrollController();

  Future updateUserChatHistoryMembers() async {
    List _chatHistoryMembers = [
      kMyId,
    ];

    final userDoc = kUsersRef.doc(widget._userId);

    await userDoc.update({
      'chatHistoryMembers': FieldValue.arrayUnion(_chatHistoryMembers),
    });

    await userDoc
        .collection('ChatHistoryMembers')
        .doc(kMyId)
        .set({kMyId: true, 'firstChatDate': DateTime.now()}).then(
            (value) => updateMyChatHistoryMembers());
  }

  Future updateMyChatHistoryMembers() async {
    List _chatHistoryMembers = [
      widget._userId,
    ];

    final myDoc = kUsersRef.doc(kMyId);

    await myDoc.update({
      'chatHistoryMembers': FieldValue.arrayUnion(_chatHistoryMembers),
    });

    await myDoc
        .collection('ChatHistoryMembers')
        .doc(widget._userId)
        .set({widget._userId: true, 'firstChatDate': DateTime.now()});
  }

  Future checkRoomExist() async {
    try {
      setState(() {
        _roomId = getRoomId(widget._userId);
      });

      DocumentReference roomsRef = kChatRoomsRef.doc(_roomId);

      await roomsRef.get().then(
        (doc) {
          if (!doc.exists) {
            createRoom(_roomId, widget._userId);
            updateUserChatHistoryMembers();
          }
        },
      );
    } catch (e) {
      singleButtonDialogue('Sorry, an unexpected error occured');
    }
  }

  plusButtonSheet() {
    Get.bottomSheet(
      Container(
        height: 220,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
        child: Column(
          children: [
            bottomSheetItem(
              Icon(CupertinoIcons.photo, color: kPrimaryColor),
              'Share photo / Camera',
              () => Get.to(
                SharePhotoScreen(
                  _roomId,
                  widget._name,
                ),
              ),
            ),
            SizedBox(height: 20),
            bottomSheetItem(
              Icon(CupertinoIcons.keyboard, color: kPrimaryColor),
              'Use voice typing',
              () {},
            ),
            SizedBox(height: 20),
            bottomSheetItem(
              Icon(CupertinoIcons.folder, color: kPrimaryColor),
              'Send a file',
              () {},
            ),
            SizedBox(height: 20),
            bottomSheetItem(
              Icon(CupertinoIcons.smiley, color: kPrimaryColor),
              'Share sticker / GIF',
              () {},
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // var _messagesRef = kChatRoomsRef.snapshots();
  var messagesStreamBuilder;

  @override
  void dispose() {
    _textController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkRoomExist();
    _roomId = getRoomId(widget._userId);
    messagesStreamBuilder = StreamBuilder<QuerySnapshot>(
      stream: kChatRoomsRef
          .doc(_roomId)
          .collection('RoomMessages')
          .orderBy('sendTime')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error fetching messages...',
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: MediaQuery.of(context).size.height - 200,
            child: Center(
              child: myLoader(),
            ),
          );
        }

        if (snapshot.data.docs.length > 0) {
          Timer(
            Duration(seconds: 1),
            () => _controller.jumpTo(_controller.position.maxScrollExtent),
          );
        }

        if (snapshot.data.docs.length == 0) {
          return Container(
            height: 300,
            child: noDataSnapshotMessage(
              'Start a new conversation',
              Text('Learn more about each other'),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Container(
            height: 300,
            child: Text('loading...'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return snapshot.data.docs[index]['senderId'] != null
                ? MessageItem(
                    snapshot.data.docs[index]['messageText'],
                    snapshot.data.docs[index]['sendTime'],
                    snapshot.data.docs[index]['sender'],
                    snapshot.data.docs[index]['senderId'],
                    snapshot.data.docs[index]['senderProfileImage'],
                    snapshot.data.docs[index]['messageImage'],
                    snapshot.data.docs[index]['messageType'],
                    snapshot.data.docs[index].id,
                    _roomId,
                  )
                : Container();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final roomMessagesRef = kChatRoomsRef
    //     .doc(_roomId)
    //     .collection('RoomMessages')
    //     .orderBy('sendTime');

    return Container(
      color: Get.isDarkMode ? kDarkThemeBlack : kPrimaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Scaffold(
            backgroundColor:
                Get.isDarkMode ? kDarkBodyThemeBlack : Colors.white,
            appBar: AppBar(
              backgroundColor: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
              elevation: 0,
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Hero(
                      tag: widget._userId,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(widget._profilePhoto),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      widget._name,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                        color: !Get.isDarkMode ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: kPrimaryColor,
                ),
                onPressed: () => Get.back(),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    CupertinoIcons.phone,
                    color: kPrimaryColor,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: kPrimaryColor,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              color: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
              elevation: 0,
              child: Container(
                padding: EdgeInsets.all(3),
                // decoration: BoxDecoration(
                //   border: Border(
                //     top: BorderSide(
                //       width: 1,
                //       color: Get.isDarkMode
                //           ? Colors.transparent
                //           : Colors.grey[100],
                //     ),
                //   ),
                // ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () => plusButtonSheet(),
                        child: Icon(
                          CupertinoIcons.plus_circle_fill,
                          size: 25,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Icon(
                          CupertinoIcons.mic,
                          size: 25,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? Colors.transparent
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _textController,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.only(left: 15),
                            // filled: true,
                            // fillColor: Colors.grey[800],
                            hintText: "Type a message...",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          if (_textController.text.trim() != '') {
                            sendMessage(
                              _roomId,
                              _textController.text.trim(),
                            );

                            _textController.text = '';
                          } else
                            return;
                        },
                        icon: Icon(
                          CupertinoIcons.paperplane_fill,
                          size: 25,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                color: Get.isDarkMode ? kDarkBodyThemeBlack : Colors.white,
                // image: DecorationImage(
                // image: NetworkImage('https://telegram.org/file/464001326/1/eHuBKzF9Lh4.288899/1f135a074a169f90e5'),
                // fit: BoxFit.cover,
                // colorFilter: ColorFilter.mode(
                //   Colors.black26,
                //   BlendMode.darken,
                // ),
                // ),
              ),
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                controller: _controller,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      messagesStreamBuilder,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
