import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart' hide Key;
import 'package:flutter/material.dart' hide Key;
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/services/services.dart';
import 'package:reflex/views/user.dart';
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
  final _controller = ScrollController();
  var percentage = 0;
  String _roomId = '';
  TextEditingController _textController = TextEditingController();
  bool loading = false;
  bool isTyping = false;
  bool _isUserTyping = false;

  // final AudioCache player = AudioCache();
  // final alarmAudioPath = "messageSent.mp3";

  // playMessageSentTone() {
  //   player.play(alarmAudioPath);

  //   // AudioCache cache = new AudioCache();
  //   // At the next line, DO NOT pass the entire reference such as assets/yes.mp3. This will not work.
  //   // Just pass the file name only.
  //   // cache.play("messageSent.mp3");
  // }

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
            updateRoomToken(_roomId);
            updateLastRoomVisitTime(_roomId);
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
        // height: 160,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? kDarkBodyThemeBlack : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            bottomSheetRoundItem(
                Icon(CupertinoIcons.photo_fill, color: Colors.white),
                'Share photo',
                Colors.grey[800], () async {
              if (mounted) {
                setState(() {
                  loading = true;
                });
              }
              await pickImages(_roomId, false).then((value) {
                if (mounted) {
                  setState(() {
                    // loading = false;
                  });
                }
              });
            }),
            bottomSheetRoundItem(
              Icon(CupertinoIcons.keyboard, color: Colors.white),
              'Use voice typing',
              kPrimaryColor,
              () {},
            ),
            bottomSheetRoundItem(
              Icon(CupertinoIcons.folder_fill, color: Colors.white),
              'Send file',
              kDarkDeep,
              () {},
            ),
          ],
        ),
      ),
    );
  }

  stickersSheet() {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height - 100,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? kDarkBodyThemeBlack : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              inputField(
                _textController,
                'Search GIFs and Stickers',
                '',
                TextInputType.text,
              ),
              StreamBuilder(
                stream: Stream.fromFuture(
                  GifAndStickerService.searchStickers(
                    Uri.https(
                      'api.giphy.com',
                      '/v1/stickers/search',
                      {
                        'api_key': '$kGiphyApiKey',
                        // 'limit': '5',
                        'limit': '${15}',
                        'q': '{sad}',
                        // 'total_count': '5'
                      },
                    ),
                  ),
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        Wrap(
                          children:
                              List.generate(snapshot.data.length, (index) {
                            return Column(
                              children: [
                                stickerContainer(
                                  '${snapshot.data['data'][index]['images']['original']['url']}',
                                ),
                                // Text('$index'),
                              ],
                            );
                          }),
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                  } else if (!snapshot.hasData) {
                    return Text('No Data');
                  }

                  return Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: Text('refresh'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  var messagesStreamBuilder;

  encryptMessage() {
    final plainText = _textController.text.trim();

    final key = Key.fromLength(32);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);

    sendMessage(
      _roomId,
      widget._userId,
      encrypted.base64,
    );
  }

  _getTypingState() {
    kChatRoomsRef
        .doc(_roomId)
        .collection('RoomLogs')
        .doc(widget._userId)
        .snapshots()
        .listen((event) {
      if (mounted) {
        setState(() {
          _isUserTyping = event.data()['isTyping'];
        });
      }
    });
  }

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

    kChatRoomsRef.doc(_roomId).collection('RoomLogs').doc(kMyId).update({
      'token': kMyNotificationToken,
      'roomVisitTime': DateTime.now().toUtc(),
    }).then((value) => print('done'));

    _getTypingState();

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
            Duration(milliseconds: 3),
            () => _controller.jumpTo(_controller.position.maxScrollExtent),
          );
        }

        if (snapshot.data.docs.length == 0) {
          return Container(
            child: noRoomChatsMessage(
              widget._profilePhoto,
              widget._name,
              widget._userId,
            ),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: Text(
              'Sorry, an error occured...',
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final key = Key.fromLength(32);
            final iv = IV.fromLength(16);
            final encrypter = Encrypter(AES(key));

            var messageText = encrypter
                .decrypt64(snapshot.data.docs[index]['messageText'], iv: iv)
                .toString();

            return snapshot.data.docs[index]['senderId'] != null
                ? MessageItem(
                    messageText,
                    snapshot.data.docs[index]['sendTime'],
                    snapshot.data.docs[index]['senderId'],
                    snapshot.data.docs[index]['sender'],
                    snapshot.data.docs[index]['senderProfileImage'],
                    snapshot.data.docs[index]['messageImage'],
                    snapshot.data.docs[index]['messageType'],
                    snapshot.data.docs[index].id,
                    _roomId,
                    false,
                  )
                : Container();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Get.isDarkMode ? kDarkBodyThemeBlack : Colors.black,
      child: Scaffold(
        backgroundColor:
            Get.isDarkMode ? kDarkBodyThemeBlack : Colors.grey[100],
        body: Scaffold(
          backgroundColor:
              Get.isDarkMode ? kDarkBodyThemeBlack : Colors.grey[100],
          appBar: AppBar(
            backgroundColor:kAppBarColor,
            elevation: kShadowInt,
            titleSpacing: 0,
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: Hero(
                    tag: widget._userId,
                    child: AppBarCircleAvatar(
                      widget._profilePhoto,
                      UserScreen(
                        widget._userId,
                        widget._profilePhoto,
                        widget._name,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget._name,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 3),
                      _isUserTyping != null && _isUserTyping
                          ? Text(
                              _isUserTyping ? 'is typing...' : 'active',
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'active',
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                updateLastRoomVisitTime(_roomId);
                Get.back();
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: Get.isDarkMode ? kDarkBodyThemeBlack : Colors.white,
            elevation: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => plusButtonSheet(),
                      child: Icon(
                        CupertinoIcons.plus_square_fill,
                        size: 25,
                        color: Get.isDarkMode ? Colors.white : kPrimaryColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 38,
                      width: MediaQuery.of(context).size.width - 300,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? kDarkThemeAccent
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: _textController,
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    isTyping = true;
                                  });
                                }

                                setTypingState(isTyping, _roomId);

                                Timer(Duration(seconds: 3), () {
                                  if (mounted) {
                                    setState(() {
                                      isTyping = false;
                                    });
                                  }

                                  setTypingState(isTyping, _roomId);
                                });
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.only(left: 15),
                                hintText: "Type a message...",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: GestureDetector(
                              onTap: () => stickersSheet(),
                              child: Icon(
                                CupertinoIcons.smiley,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _textController.text.isNotEmpty
                      ? Container(height: 0, width: 0)
                      : Expanded(
                          child: GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              width: 40,
                              height: 40,
                              child: Icon(
                                CupertinoIcons.mic_fill,
                                size: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(width: 10),
                  _textController.text.isNotEmpty
                      ? Expanded(
                          flex: 1,
                          child: Container(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              onPressed: () {
                                if (_textController.text.trim() != '') {
                                  encryptMessage();
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
                        )
                      : Container(width: 0, height: 0),
                ],
              ),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Get.isDarkMode ? kDarkBodyThemeBlack : Colors.white,
            ),
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              controller: _controller,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    messagesStreamBuilder,
                    loading
                        ? Column(
                            children: [
                              SizedBox(height: 30),
                              myLoader(),
                              SizedBox(height: 10),
                              Text('Sending photo... $percentage%'),
                              SizedBox(height: 30),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
