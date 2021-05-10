import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart' hide Key;
import 'package:flutter/material.dart' hide Key;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/services/services.dart';
import 'package:reflex/views/club_info.dart';
import 'package:reflex/views/club_messaging_screen.dart';
import 'package:reflex/views/forward_to.dart';
import 'package:reflex/views/messaging_screen.dart';
import 'package:reflex/views/search_screen.dart';
import 'package:reflex/views/user.dart';
import 'package:reflex/views/view_photo_screen.dart';

Widget inputField(
  final TextEditingController textController,
  final String placeholderText,
  final String explanatoryText,
  final keyboardType,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(placeholderText, style: placeholderTextStyle),
      SizedBox(height: 10),
      // explanatoryText != ''
      //     ? Text(explanatoryText, style: kGrey16)
      //     : Container(height: 0),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200], width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextFormField(
          maxLines: null,
          controller: textController,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.only(left: 10),
          ),
        ),
      ),
    ],
  );
}

Widget textTabLabel(String _tabText) {
  return Padding(
    padding: EdgeInsets.only(bottom: 15.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _tabText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget myTabBar(_tabs, _controller) {
  return TabBar(
    tabs: _tabs,
    controller: _controller,
    indicatorColor: kPrimaryColor,
    indicatorSize: TabBarIndicatorSize.tab,
    unselectedLabelColor: Colors.grey[600],
    labelColor: kPrimaryColor,
  );
}

Widget normalInputField(
  final TextEditingController textController,
  final String placeholderText,
  final String explanatoryText,
  final keyboardType,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(placeholderText, style: placeholderTextStyle),
      SizedBox(height: 10),
      explanatoryText != ''
          ? Text(explanatoryText, style: kGrey16)
          : Container(height: 0),
      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]),
          ),
        ),
        child: TextFormField(
          maxLines: null,
          controller: textController,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    ],
  );
}

myLoader() {
  return CircularProgressIndicator();
}

void singleButtonDialogue(String _alertTitle) {
  Get.dialog(
    AlertDialog(
      contentPadding: EdgeInsets.all(15),
      elevation: 0,
      content: Container(
        height: 115,
        child: Column(
          children: [
            Text(_alertTitle),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    color: kPrimaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      'Okay',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget signButton(String _btnText, _func) {
  return Container(
    height: 40,
    child: MaterialButton(
      elevation: 0,
      color: kPrimaryColor,
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(4),
      ),
      onPressed: _func,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _btnText,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 10),
          // Icon(
          //   LineIcons.check,
          //   color: Colors.white,
          // ),
        ],
      ),
    ),
  );
}

Widget sideDrawerItem(String _text, Icon _icon, Function _func) {
  return GestureDetector(
    onTap: _func,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
      child: Row(
        children: [
          _icon,
          SizedBox(width: 8),
          Text(_text, style: kFont16),
        ],
      ),
    ),
  );
}

Widget sectionDescription(String _text) {
  return Container(
    padding: EdgeInsets.all(8),
    margin: EdgeInsets.only(top: 10),
    child: Text(
      _text,
      style: TextStyle(
        fontSize: 15,
        color: Get.isDarkMode ? Colors.grey : Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class RoomChatItem extends StatefulWidget {
  final _roomUsers;
  RoomChatItem(this._roomUsers);

  @override
  _RoomChatItemState createState() => _RoomChatItemState();
}

class _RoomChatItemState extends State<RoomChatItem> {
  String _roomProfileImage = kTemporalImageUrl;
  String _roomName = '';
  String _otherUserId = '';

  Future getRoomInfo() async {
    try {
      var otherUserId = widget._roomUsers.firstWhere(
        (id) => id != kMyId,
        orElse: () => null,
      );

      if (mounted) {
        setState(() {
          _otherUserId = otherUserId;
        });
      }

      DocumentReference otherUserRef = kUsersRef.doc(otherUserId);

      await otherUserRef.get().then((doc) async {
        String _otherUserProfileImage = doc.data()['profileImage'].toString();
        String _otherUserName = doc.data()['name'];

        if (mounted) {
          setState(() {
            _roomProfileImage = _otherUserProfileImage;
            _roomName = _otherUserName;
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getRoomInfo();
  }

  @override
  Widget build(BuildContext context) {
    return _roomName != '' && _roomProfileImage != null
        ? MessageTile(_roomName, _roomProfileImage, _otherUserId)
        : Container();
  }
}

class MessageTile extends StatefulWidget {
  final String _name;
  final String _profilePhoto;
  final String _userId;

  MessageTile(this._name, this._profilePhoto, this._userId);

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  int _num = 0;
  var roomVisitTime;
  var lastMessageTime;
  String lastRoomMessage = '...';
  String lastRoomMessageSenderId = '';

  // _getRoomData() async {
  //   var _roomId = await getRoomId(widget._userId);

  //   await kChatRoomsRef
  //       .doc(_roomId)
  //       .collection('RoomLogs')
  //       .doc(kMyId)
  //       .snapshots()
  //       .forEach((element) {
  //     if (mounted) {
  //       setState(() {
  //         roomVisitTime = element.data()['roomVisitTime'];
  //       });
  //     }

  //     _getUnread();

  //     kChatRoomsRef.doc(_roomId).snapshots().forEach((element) {
  //       if (mounted) {
  //         setState(() {
  //           lastRoomMessage = element.data()['lastRoomMessage'];
  //           lastRoomMessageSenderId = element.data()['lastRoomMessageSenderId'];
  //           lastMessageTime = element.data()['lastMessageTime'];
  //         });
  //       }
  //     });

  //     // kClubChatRoomsRef
  //     //     .doc(widget._userId)
  //     //     .collection('RoomMessages')
  //     //     .where('sendTime', isGreaterThan: roomVisitTime)
  //     //     .snapshots()
  //     //     .listen((event) {
  //     //   if (mounted) {
  //     //     setState(() {
  //     //       _num = event.docs.length;
  //     //     });
  //     //   }
  //     // });

  //     //get unread count
  //   });
  // }

  // var _newProfilePhoto = CircleAvatar(
  //                 radius: 25,
  //                 backgroundColor:
  //                     Get.isDarkMode ? Colors.black : Colors.grey[100],
  //                 backgroundImage: NetworkImage(widget._profilePhoto),
  //               );

  var _newProfilePhoto;

  _getRoomData() async {
    var _roomId = await getRoomId(widget._userId);

    kChatRoomsRef.doc(_roomId).snapshots().forEach((element) {
      if (mounted) {
        setState(() {
          lastRoomMessage = element.data()['lastRoomMessage'];
          lastRoomMessageSenderId = element.data()['lastRoomMessageSenderId'];
          lastMessageTime = element.data()['lastMessageTime'];
        });
      }
    });

    await _getLastRoomVisitTime();
  }

  _getLastRoomVisitTime() async {
    var _roomId = await getRoomId(widget._userId);

    kChatRoomsRef
        .doc(_roomId)
        .collection('RoomLogs')
        .doc(kMyId)
        .snapshots()
        .listen((event) {
      if (mounted) {
        setState(() {
          roomVisitTime = event.data()['roomVisitTime'];
        });
      }

      _getUnread();
    });
  }

  _getUnread() async {
    var _roomId = await getRoomId(widget._userId);

    kChatRoomsRef
        .doc(_roomId)
        .collection('RoomMessages')
        // .where('senderId', isEqualTo: kMyId != true)
        .where('sendTime', isGreaterThan: roomVisitTime)
        .snapshots()
        .listen((event) {
      if (mounted) {
        setState(() {
          _num = event.docs.length;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getRoomData();

    _newProfilePhoto = NetworkImage(widget._profilePhoto);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_newProfilePhoto, context);
  }

  @override
  Widget build(BuildContext context) {
    DateTime myDateTime =
        lastMessageTime != null ? lastMessageTime.toDate() : DateTime.now();
    String _convertedTime = DateFormat('HH:mm a').format(myDateTime);

    return Container(
      child: Column(
        children: [
          ListTile(
            horizontalTitleGap: 10,
            onTap: () => Get.to(
              MessagingScreen(
                widget._name,
                widget._profilePhoto,
                widget._userId,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget._name == kMyName ? 'Saved' : widget._name,
                  style: TextStyle(
                    fontSize: 15,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    fontWeight: _num > 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  _convertedTime,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: _num > 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            leading: GestureDetector(
              onTap: () => Get.to(
                UserScreen(
                  widget._userId,
                  widget._profilePhoto,
                  widget._name,
                ),
              ),
              child: Hero(
                tag: widget._userId,
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: _newProfilePhoto,
                  backgroundColor:
                      Get.isDarkMode ? Colors.black : Colors.grey[100],
                ),
              ),
            ),
            subtitle: Column(
              children: [
                SizedBox(height: 3),
                Container(
                  // height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Flexible(
                          child: Text(
                            lastRoomMessageSenderId != kMyId
                                ? lastRoomMessage
                                : 'You: $lastRoomMessage',
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              color: _num > 0 ? Colors.black : Colors.grey,
                              fontWeight: _num > 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      _num > 0
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 7,
                              ),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                '$_num',
                                // '1',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider(),
        ],
      ),
    );
  }
}

class ClubMessageTile extends StatefulWidget {
  final String _name;
  final String _profilePhoto;
  final String _clubId;
  final String _clubDescription;
  final String _clubCategory;

  ClubMessageTile(
    this._name,
    this._profilePhoto,
    this._clubId,
    this._clubDescription,
    this._clubCategory,
  );

  @override
  ClubMessageTileState createState() => ClubMessageTileState();
}

class ClubMessageTileState extends State<ClubMessageTile> {
  int _num = 0;
  var _roomVisitTime;
  var _lastRoomMessageTime;
  String _lastRoomMessage = '...';

  _getRoomData() async {
    await kClubChatRoomsRef
        .doc(widget._clubId)
        .collection('RoomLogs')
        .doc(kMyId)
        .snapshots()
        .forEach((element) {
      if (mounted) {
        setState(() {
          _roomVisitTime = element.data()['roomVisitTime'];
        });
      }

      kClubChatRoomsRef.doc(widget._clubId).snapshots().forEach((element) {
        if (mounted) {
          setState(() {
            _lastRoomMessage = element.data()['lastRoomMessage'];
            _lastRoomMessageTime = element.data()['lastRoomMessageTime'];
          });
        }
      });

      //get unread count
      // kClubChatRoomsRef
      //     .doc(widget._clubId)
      //     .collection('RoomMessages')
      //     .where('sendTime', isGreaterThan: roomVisitTime)
      //     .snapshots()
      //     .listen((event) {
      //   if (mounted) {
      //     setState(() {
      //       _num = event.docs.length;
      //     });
      //   }
      // });

      //get unread count
      kClubChatRoomsRef
          .doc(widget._clubId)
          .collection('RoomMessages')
          .where('sendTime', isGreaterThan: _roomVisitTime)
          .get()
          .then((value) {
        if (mounted) {
          setState(() {
            _num = value.docs.length;
          });
        }
      });
    });
  }

  var _newProfilePhoto;

  @override
  void initState() {
    super.initState();
    _getRoomData();
    _newProfilePhoto = NetworkImage(widget._profilePhoto);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_newProfilePhoto, context);
  }

  @override
  Widget build(BuildContext context) {
    DateTime myDateTime = _lastRoomMessageTime != null
        ? _lastRoomMessageTime.toDate()
        : DateTime.now();
    String _convertedTime = DateFormat('HH:mm a').format(myDateTime);

    return Container(
      child: Column(
        children: [
          ListTile(
            horizontalTitleGap: 10,
            onTap: () => Get.to(
              ClubMessagingScreen(
                widget._clubId,
                widget._profilePhoto,
                widget._name,
                widget._clubDescription,
                widget._clubCategory,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget._name == kMyName ? 'Saved' : widget._name,
                  style: TextStyle(
                    fontSize: 15,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    fontWeight: _num > 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  _convertedTime,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: _num > 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            leading: GestureDetector(
              onTap: () => Get.to(
                ClubInfoScreen(
                  widget._clubId,
                  widget._profilePhoto,
                  widget._name,
                  widget._clubDescription,
                  widget._clubCategory,
                ),
              ),
              child: Hero(
                tag: widget._clubId,
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: _newProfilePhoto,
                  backgroundColor:
                      Get.isDarkMode ? Colors.black : Colors.grey[100],
                ),
              ),
            ),
            subtitle: Column(
              children: [
                SizedBox(height: 3),
                Container(
                  // height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Flexible(
                          child: Text(
                            // lastRoomMessageSenderId != kMyId
                            //     ? 'lastRoomMessage'
                            //     : 'You: $lastRoomMessage',
                            '$_lastRoomMessage',
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(
                              color: _num > 0 ? Colors.black : Colors.grey,
                              fontWeight: _num > 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      _num > 0
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 7,
                              ),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                '$_num',
                                // '1',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider(),
        ],
      ),
    );
  }
}

Widget userTile(
  String _name,
  _profilePhoto,
  _userId,
  _interestOne,
  _interestTwo,
  _interestThree,
) {
  return Container(
    child: Column(
      children: [
        ListTile(
          horizontalTitleGap: 10,
          onTap: () => Get.to(
            UserScreen(_userId, _profilePhoto, _name),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          title: Text(
            _name,
            style: TextStyle(
              fontSize: 15,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          leading: Hero(
            tag: _userId,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[100],
              backgroundImage: NetworkImage(_profilePhoto),
            ),
          ),
          subtitle: Text(
            'Likes $_interestOne, $_interestTwo, $_interestThree',
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: TextStyle(
              color: Colors.grey,
              // fontFamily: kDefaultFont,
            ),
          ),
          trailing: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[200],
            ),
            child: colorRoundButton(
              Icon(
                CupertinoIcons.bubble_left_fill,
                color: kPrimaryColor,
              ),
              () => Get.to(
                MessagingScreen(_name, _profilePhoto, _userId),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// Widget forwardUserTile(
//   String _name,
//   _profilePhoto,
//   _roomId,
//   _interestOne,
//   _interestTwo,
//   _interestThree,
// ) {
//   _forward() {}

//   return Container(
//     child: Column(
//       children: [
//         ListTile(
//           horizontalTitleGap: 10,
//           contentPadding: EdgeInsets.symmetric(horizontal: 10),
//           title: Text(
//             _name,
//             style: TextStyle(
//               fontSize: 15,
//               color: Get.isDarkMode ? Colors.white : Colors.black,
//             ),
//           ),
//           leading: CircleAvatar(
//             backgroundColor: Colors.grey[100],
//             backgroundImage: NetworkImage(_profilePhoto),
//           ),
//           subtitle: Text(
//             'Likes $_interestOne, $_interestTwo, $_interestThree',
//             overflow: TextOverflow.ellipsis,
//             softWrap: true,
//             style: TextStyle(
//               color: Colors.grey,
//               // fontFamily: kDefaultFont,
//             ),
//           ),
//           trailing: Container(
//             // width: 120,
//             child: textButton(
//               'Send ...',
//               () => _forward(),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget groupTile(
  String _name,
  String _profilePhoto,
  String _clubId,
  String _clubCategory,
  String _clubDescription,
) {
  return Container(
    child: Column(
      children: [
        ListTile(
          horizontalTitleGap: 10,
          onTap: () => Get.to(
            ClubInfoScreen(
              _clubId,
              _profilePhoto,
              _name,
              _clubDescription,
              _clubCategory,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          title: Text(
            _name,
            style: TextStyle(
              fontSize: 15,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          leading: Hero(
            tag: _clubId,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[100],
              backgroundImage: NetworkImage(_profilePhoto),
            ),
          ),
          subtitle: Text(
            _clubCategory,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: TextStyle(
              color: Colors.grey,
              // fontFamily: kDefaultFont,
            ),
          ),
          trailing: Icon(
            CupertinoIcons.chevron_forward,
          ),
        ),
        // Divider(),
      ],
    ),
  );
}

Widget circleTile(String _name, _profilePhoto, _userId) {
  return GestureDetector(
    onTap: () => Get.to(
      MessagingScreen(_name, _profilePhoto, _userId),
    ),
    child: Container(
      height: 70,
      width: 70,
      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  image: DecorationImage(
                    image: NetworkImage(_profilePhoto),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: 10,
                height: 10,
                margin: EdgeInsets.only(left: 7),
                decoration: BoxDecoration(
                  color: kAccentColor,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            _name,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: kFont13,
          ),
        ],
      ),
    ),
  );
}

// Widget gridCard(String _name, String _profilePhoto, String _userId) {
//   return Container(
//     height: 200,
//     width: 180,
//     margin: EdgeInsets.all(5),
//     padding: EdgeInsets.all(5),
//     decoration: BoxDecoration(
//       color: !Get.isDarkMode ? Colors.grey[100] : kDarkBodyThemeBlack,
//       border: Border.all(
//         color: !Get.isDarkMode ? Colors.grey[200] : Colors.transparent,
//         width: 1,
//       ),
//       borderRadius: BorderRadius.circular(4),
//     ),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         GestureDetector(
//           onTap: () => Get.to(
//             UserScreen(_userId, _profilePhoto, _name),
//           ),
//           child: CircleAvatar(
//             radius: 35,
//             backgroundImage: NetworkImage(_profilePhoto),
//             backgroundColor: Colors.grey[200],
//           ),
//         ),
//         SizedBox(height: 6),
//         Text(
//           _name,
//           softWrap: false,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//         SizedBox(height: 6),
//         defaultRoundButton(
//           'Send message',
//           () => Get.to(
//             MessagingScreen(
//               _name,
//               _profilePhoto,
//               _userId,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget clubGridCard(
//   String _name,
//   String _profilePhoto,
//   String _clubId,
//   String _clubDescription,
//   String _clubCategory,
// ) {
//   return Container(
//     height: 200,
//     width: 180,
//     margin: EdgeInsets.all(5),
//     padding: EdgeInsets.all(5),
//     decoration: BoxDecoration(
//       color: !Get.isDarkMode ? Colors.grey[100] : kDarkBodyThemeBlack,
//       border: Border.all(
//         color: !Get.isDarkMode ? Colors.grey[200] : Colors.transparent,
//         width: 1,
//       ),
//       borderRadius: BorderRadius.circular(4),
//     ),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         GestureDetector(
//           onTap: () => Get.to(
//             ClubInfoScreen(
//               _clubId,
//               _profilePhoto,
//               _name,
//               _clubDescription,
//               _clubCategory,
//             ),
//           ),
//           child: Hero(
//             tag: _clubId,
//             child: CircleAvatar(
//               radius: 35,
//               backgroundImage: NetworkImage(_profilePhoto),
//               backgroundColor: Colors.grey[200],
//             ),
//           ),
//         ),
//         SizedBox(height: 6),
//         Text(
//           _name,
//           softWrap: false,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//         SizedBox(height: 6),
//         Text('200 members'),
//         // defaultRoundButton(
//         //   'Join club',
//         //   () {},
//         // ),
//       ],
//     ),
//   );
// }

Widget defaultRoundButton(String _btnText, Function _func) {
  return Container(
    height: 33,
    // width: 90,
    child: MaterialButton(
      elevation: 0,
      color: !Get.isDarkMode ? kPrimaryColor.withOpacity(0.2) : Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(40),
      ),
      onPressed: _func,
      child: Text(
        _btnText,
        style: TextStyle(color: kPrimaryColor),
      ),
    ),
  );
}

Widget textIconRoundButton(Icon _icon, String _btnText, Function _func) {
  return GestureDetector(
    onTap: _func,
    child: Container(
      height: 33,
      // width: 90,
      child: MaterialButton(
        elevation: 0,
        color: !Get.isDarkMode ? kPrimaryColor.withOpacity(0.2) : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(40),
        ),
        onPressed: _func,
        child: Row(
          children: [
            _icon,
            SizedBox(width: 10),
            Text(
              _btnText,
              style: TextStyle(color: kPrimaryColor),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget textButton(String _btnText, Function _func) {
  return GestureDetector(
    onTap: _func,
    child: Container(
      height: 33,
      child: MaterialButton(
        elevation: 0,
        color: !Get.isDarkMode ? kPrimaryColor.withOpacity(0.2) : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(40),
        ),
        onPressed: _func,
        child: Text(
          _btnText,
          style: TextStyle(color: kPrimaryColor),
        ),
      ),
    ),
  );
}

Widget colorRoundButton(Icon _icon, Function _pressed) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      color: !Get.isDarkMode ? Colors.grey[200] : kDarkBodyThemeBlack,
    ),
    child: IconButton(
      icon: _icon,
      onPressed: _pressed,
    ),
  );
}

Widget textColorRoundButton(Icon _icon, String _text, _pressed) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: 7,
    ),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: !Get.isDarkMode ? Colors.grey[200] : kDarkBodyThemeBlack,
          ),
          child: IconButton(
            icon: _icon,
            onPressed: _pressed,
          ),
        ),
        SizedBox(height: 4),
        Text(
          _text,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}

Widget fakeSearchBox() {
  return GestureDetector(
    onTap: () => Get.to(SearchScreen()),
    child: Container(
      height: 60,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: !Get.isDarkMode ? Colors.grey[200] : Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.search,
              color: Colors.grey[500],
              size: 19,
            ),
            SizedBox(width: 10),
            Text(
              'Search for chats',
              style: kGrey14,
              // textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget bottomNavIconTextLabel(String _text, Icon _icon) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    // height: 55,
    child: Column(
      children: [
        _icon,
        Text(
          _text,
          style: TextStyle(
            fontSize: 11,
          ),
        ),
      ],
    ),
  );
}

class MessageItem extends StatefulWidget {
  final _messageText;
  final _messageTimeStamp;
  final String _senderId;
  final String _senderName;
  final String _senderProfileImage;
  final List _messageImage;
  final String _messageType;
  final String _messageId;
  final String _roomId;
  final bool _isClub;

  MessageItem(
    this._messageText,
    this._messageTimeStamp,
    this._senderId,
    this._senderName,
    this._senderProfileImage,
    this._messageImage,
    this._messageType,
    this._messageId,
    this._roomId,
    this._isClub,
  );

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  showMessageItemSheet() {
    Get.bottomSheet(
      Container(
        height: 200,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: Column(
          children: [
            bottomSheetItem(
              Icon(Icons.forward, color: kPrimaryColor),
              'Forward...',
              () => Get.to(ForwardToScreen(
                widget._messageText,
                widget._messageTimeStamp,
                widget._senderId,
                widget._senderName,
                widget._senderProfileImage,
                widget._messageImage,
                widget._messageType,
                widget._messageId,
                widget._roomId,
                widget._isClub,
              )),
            ),
            widget._senderId == kMyId
                ? bottomSheetItem(
                    Icon(CupertinoIcons.delete, color: kPrimaryColor),
                    'Delete message',
                    () {
                      final roomMessagesRef = kChatRoomsRef
                          .doc(widget._roomId)
                          .collection('RoomMessages');

                      final clubRoomMessagesRef = kClubChatRoomsRef
                          .doc(widget._roomId)
                          .collection('RoomMessages');

                      if (widget._senderId == kMyId)
                        !widget._isClub
                            ? roomMessagesRef.doc(widget._messageId).delete()
                            : clubRoomMessagesRef
                                .doc(widget._messageId)
                                .delete();

                      Get.back();
                    },
                  )
                : Container(),
            widget._messageImage.length > 0
                ? bottomSheetItem(
                    Icon(Icons.download_outlined, color: kPrimaryColor),
                    'Download photo',
                    () {
                      final roomMessagesRef = kChatRoomsRef
                          .doc(widget._roomId)
                          .collection('RoomMessages');

                      if (widget._senderId == kMyId)
                        roomMessagesRef.doc(widget._messageId).delete();

                      Get.back();
                    },
                  )
                : Container(),
            widget._messageText != '' && widget._messageImage.length < 1
                ? bottomSheetItem(
                    Icon(Icons.copy, color: kPrimaryColor),
                    'Copy message text',
                    () {
                      final roomMessagesRef = kChatRoomsRef
                          .doc(widget._roomId)
                          .collection('RoomMessages');

                      if (widget._senderId == kMyId)
                        roomMessagesRef.doc(widget._messageId).delete();

                      Get.back();
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var myMessage = widget._senderId == kMyId;

    DateTime myDateTime = widget._messageTimeStamp != null
        ? widget._messageTimeStamp.toDate()
        : DateTime.now();
    String dateString = DateFormat('K:mm').format(myDateTime);

    return GestureDetector(
      onLongPress: () => showMessageItemSheet(),
      child: Column(
        crossAxisAlignment:
            myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              !myMessage
                  ? GestureDetector(
                      onTap: () => Get.to(
                        UserScreen(
                          widget._senderId,
                          widget._senderProfileImage,
                          widget._senderName,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[100],
                        backgroundImage:
                            NetworkImage(widget._senderProfileImage),
                      ),
                    )
                  : Container(),
              SizedBox(width: 10),
              widget._messageText == 'null check' || widget._messageText == ''
                  ? Container()
                  : Flexible(
                      child: Column(
                        crossAxisAlignment: myMessage
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  myMessage ? kPrimaryColor : Colors.grey[100],
                              borderRadius: BorderRadius.circular(17),
                            ),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width / 2 + 100,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 14,
                            ),
                            child: Text(
                              widget._messageText,
                              style: TextStyle(
                                color: myMessage ? Colors.white : Colors.black,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: myMessage
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Text(
                                widget._senderName == kMyName
                                    ? ''
                                    : widget._senderName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                              SizedBox(width: 7),
                              Text(
                                dateString,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ],
          ),
          widget._messageImage.length > 0
              ? Column(
                  children: [
                    for (var image in widget._messageImage)
                      // widget._messageImage.length > 0
                      Container(
                        // padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        margin: EdgeInsets.only(top: 5),
                        // constraints: BoxConstraints(
                        //   maxWidth: MediaQuery.of(context).size.width / 2 + 100,
                        // ),
                        height: 300,
                        width: 300,
                        // color: Colors.grey[700],
                        child: GestureDetector(
                          onTap: () => Get.to(
                            ViewPhotoScreen(image),
                          ),
                          child: ExtendedImage.network(
                            image,
                            fit: BoxFit.fill,
                            cache: true,
                            // borderRadius: BorderRadius.circular(200),
                            // height: 300,
                            // width: 300,
                            loadStateChanged: (ExtendedImageState state) {
                              switch (state.extendedImageLoadState) {
                                case LoadState.loading:
                                  return Container(
                                    height: 200,
                                    width:
                                        MediaQuery.of(context).size.width / 2 +
                                            100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: myLoader(),
                                    ),
                                  );
                                  break;

                                case LoadState.completed:
                                  return ExtendedRawImage(
                                    image: state.extendedImageInfo?.image,
                                  );
                                  break;
                                case LoadState.failed:
                                  state.reLoadImage();
                                  return Text('');
                                  break;
                              }

                              return Text('');
                            },
                          ),
                        ),
                      ),
                  ],
                )
              : Container(),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

Widget noDataSnapshotMessage(String _bigText, _smallWidget) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 30),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _bigText,
            style: kFont23,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          _smallWidget,
        ],
      ),
    ),
  );
}

Widget noRoomChatsMessage(String _imgUrl, String _name, String _userId) {
  return Padding(
    padding: EdgeInsets.fromLTRB(30, 30, 30, 20),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey[100],
            backgroundImage: NetworkImage(_imgUrl),
          ),
          SizedBox(height: 15),
          Icon(CupertinoIcons.padlock, color: Colors.lightGreen),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Your conversation with $_name is \n end-to-end encrypted',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget bottomSheetItem(_icon, _text, _func) {
  return Container(
    margin: EdgeInsets.only(bottom: 15),
    child: GestureDetector(
      onTap: _func,
      child: Row(
        children: [
          _icon,
          SizedBox(width: 10),
          Text(
            _text,
            style: TextStyle(
              fontSize: 16,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget fillInCircleTile() {
  return Container(
    margin: EdgeInsets.only(top: 10),
    height: 95,
    child: circleTile(
      'Me',
      kMyProfileImage,
      kMyId,
    ),
  );
}

Widget fillInMessageTile() {
  return Container(
    height: 150,
    child: MessageTile(
      kMyName,
      kMyProfileImage,
      kMyId,
    ),
  );
}

stickerContainer(_url) {
  return Container(width: 100, child: Image.network(_url));
}
