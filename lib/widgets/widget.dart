import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart' hide Key;
import 'package:flutter/material.dart' hide Key;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/services/services.dart';
import 'package:reflex/views/club_info.dart';
import 'package:reflex/views/club_messaging_screen.dart';
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
      Text(placeholderText, style: kBold18),
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
      Text(placeholderText, style: kBold18),
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
        borderRadius: BorderRadius.circular(60),
      ),
      onPressed: _func,
      child: Row(
        children: [
          Text(
            _btnText,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 10),
          Icon(
            LineIcons.check,
            color: Colors.white,
          ),
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
  String lastRoomMessage = '...';
  String lastRoomMessageSenderId = '';

  _getRoomData() async {
    var _roomId = await getRoomId(widget._userId);

    await kChatRoomsRef
        .doc(_roomId)
        .collection('RoomLogs')
        .doc(kMyId)
        .snapshots()
        .forEach((element) {
      if (mounted) {
        setState(() {
          roomVisitTime = element.data()['roomVisitTime'];
        });
      }

      kChatRoomsRef.doc(_roomId).snapshots().forEach((element) {
        if (mounted) {
          setState(() {
            lastRoomMessage = element.data()['lastRoomMessage'];
            lastRoomMessageSenderId = element.data()['lastRoomMessageSenderId'];
          });
        }
      });

      // kClubChatRoomsRef
      //     .doc(widget._userId)
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

      kChatRoomsRef
          .doc(_roomId)
          .collection('RoomMessages')

          // TODO get unread counter on messages i didnt send
          // .where('sender', isNotEqualTo: kMyName)
          .where('sendTime', isGreaterThan: roomVisitTime)
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

  @override
  void initState() {
    super.initState();
    _getRoomData();
  }

  @override
  Widget build(BuildContext context) {
    DateTime myDateTime =
        roomVisitTime != null ? roomVisitTime.toDate() : DateTime.now();
    String _convertedTime = DateFormat('K:mm').format(myDateTime);

    return Container(
      // height: 200,
      child: Column(
        children: [
          ListTile(
            onTap: () => Get.to(
              MessagingScreen(
                widget._name,
                widget._profilePhoto,
                widget._userId,
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget._name == kMyName ? 'Saved' : widget._name,
                  style: TextStyle(
                    fontSize: 15,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  _convertedTime,
                  style: kGrey13,
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
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    image: DecorationImage(
                      image: NetworkImage(widget._profilePhoto),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            subtitle: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          lastRoomMessageSenderId != kMyId
                              ? lastRoomMessage
                              : 'You: $lastRoomMessage',
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.grey,
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
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                '$_num',
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
  var roomVisitTime;
  var lastRoomMessageTime;
  String lastRoomMessage = '';
  String lastRoomMessageSenderId = '';

  _getRoomData() async {
    await kClubChatRoomsRef
        .doc(widget._clubId)
        .collection('RoomLogs')
        .doc(kMyId)
        .snapshots()
        .forEach((element) {
      if (mounted) {
        setState(() {
          roomVisitTime = element.data()['roomVisitTime'];
        });
      }

      kClubChatRoomsRef.doc(widget._clubId).snapshots().forEach((element) {
        if (mounted) {
          setState(() {
            lastRoomMessage = element.data()['lastRoomMessage'];
            lastRoomMessageTime = element.data()['lastRoomMessageTime'];
            lastRoomMessageSenderId = element.data()['lastRoomMessageSenderId'];
          });
        }
      });

      //get unred count
      kClubChatRoomsRef
          .doc(widget._clubId)
          .collection('RoomMessages')
          .where('sendTime', isGreaterThan: roomVisitTime)
          .snapshots()
          .listen((event) {
        if (mounted) {
          setState(() {
            _num = event.docs.length;
          });
        }
      });

      //TODO made a change
      kClubChatRoomsRef
          .doc(widget._clubId)
          .collection('RoomMessages')
          // .where('sender', isNotEqualTo: kMyName)
          .where('sendTime', isGreaterThan: roomVisitTime)
          // .snapshots().length
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

  @override
  void initState() {
    super.initState();
    _getRoomData();
  }

  @override
  Widget build(BuildContext context) {
    DateTime myDateTime = lastRoomMessageTime != null
        ? lastRoomMessageTime.toDate()
        : DateTime.now();
    String _convertedTime = DateFormat('K:mm').format(myDateTime);

    return Container(
      child: Column(
        children: [
          ListTile(
            onTap: () => Get.to(
              ClubMessagingScreen(
                widget._clubId,
                widget._profilePhoto,
                widget._name,
                widget._clubDescription,
                widget._clubCategory,
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget._name == kMyName ? 'Saved' : widget._name,
                  style: TextStyle(
                    fontSize: 15,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  _convertedTime,
                  style: kGrey13,
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
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  image: DecorationImage(
                    image: NetworkImage(widget._profilePhoto),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            subtitle: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          // lastRoomMessageSenderId != kMyId
                          //     ? 'lastRoomMessage'
                          //     : 'You: $lastRoomMessage',
                          '$lastRoomMessage',
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.grey,
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
                                color: Colors.red,
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
          onTap: () => Get.to(
            UserScreen(_userId, _profilePhoto, _name),
          ),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          title: Text(
            _name,
            style: TextStyle(
              fontSize: 15,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          leading: Hero(
            tag: _userId,
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: !Get.isDarkMode ? Colors.grey[200] : kDarkBodyThemeBlack,
                image: DecorationImage(
                  image: NetworkImage(_profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
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
          onTap: () => Get.to(
            ClubInfoScreen(
              _clubId,
              _profilePhoto,
              _name,
              _clubDescription,
              _clubCategory,
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          title: Text(
            _name,
            style: TextStyle(
              fontSize: 15,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          leading: Hero(
            tag: _clubId,
            child: Container(
              height: 60,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: !Get.isDarkMode ? Colors.grey[200] : kDarkBodyThemeBlack,
                image: DecorationImage(
                  image: NetworkImage(_profilePhoto),
                  fit: BoxFit.cover,
                ),
              ),
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
          // trailing: Container(
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(100),
          //     color: Colors.grey[200],
          //   ),
          //   child: colorRoundButton(
          //     Icon(
          //       CupertinoIcons.bubble_left_fill,
          //       color: kPrimaryColor,
          //     ),
          //     () => Get.to(
          //       MessagingScreen(_name, _profilePhoto, _clubId),
          //     ),
          //   ),
          // ),
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

Widget fakeSearchBox() {
  return GestureDetector(
    onTap: () => Get.to(SearchScreen()),
    child: Container(
      height: 40,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: !Get.isDarkMode ? Colors.grey[200] : kDarkBodyThemeBlack,
        // border: Border.all(
        //   color: Colors.grey[200],
        //   width: 1,
        // ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.search,
              color: Colors.grey[400],
              size: 19,
            ),
            SizedBox(width: 10),
            Text(
              'Search for messages',
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
  final String _messageImage;
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
        // height: 140,
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
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            widget._messageImage != null
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
            SizedBox(height: 20),
            decryptedMessage != null ||
                    decryptedMessage == '' && widget._messageImage == null
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
            SizedBox(height: 20),
            bottomSheetItem(
              Icon(Icons.forward, color: kPrimaryColor),
              'Forward...',
              () {},
            ),
          ],
        ),
      ),
    );
  }

  String decryptedMessage = '';

  decryptMessage() {
    final key = Key.fromLength(32);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    var plainMessageText = widget._messageText;
    final decrypted = encrypter.decrypt64(plainMessageText, iv: iv);

    print(decrypted);

    if (mounted) {
      setState(() {
        decryptedMessage = decrypted;
      });
    }
  }

  rawTextMessage() {
    if (mounted) {
      setState(() {
        decryptedMessage = widget._messageText;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget._isClub ? rawTextMessage() : decryptMessage();
  }

  @override
  Widget build(BuildContext context) {
    DateTime myDateTime = widget._messageTimeStamp.toDate();
    String dateString = DateFormat('K:mm').format(myDateTime);
    var myMessage = widget._senderId == kMyId;

    return GestureDetector(
      onTap: () => decryptMessage(),
      onLongPress: () => showMessageItemSheet(),
      child: Column(
        crossAxisAlignment:
            myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment:
                myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              !myMessage
                  ? CircleAvatar(
                      radius: 13,
                      backgroundColor: Colors.grey[100],
                      backgroundImage: NetworkImage(widget._senderProfileImage),
                    )
                  : Container(),
              SizedBox(width: 10),
              decryptedMessage == null || decryptedMessage == ''
                  // decryptedMessage == 'Sent a photo'
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: myMessage ? kPrimaryColor : Colors.grey[100],
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
                            decryptedMessage,
                            style: TextStyle(
                              color: myMessage ? Colors.white : Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
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
            ],
          ),
          widget._messageType == 'photoMessage' && widget._messageImage != null
              ? Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  margin: EdgeInsets.only(top: 10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2 + 100,
                  ),
                  child: GestureDetector(
                    onTap: () => Get.to(
                      ViewPhotoScreen(widget._messageImage),
                    ),
                    child: ExtendedImage.network(
                      widget._messageImage,
                      fit: BoxFit.fill,
                      cache: true,
                      loadStateChanged: (ExtendedImageState state) {
                        switch (state.extendedImageLoadState) {
                          case LoadState.loading:
                            return Container(
                              height: 200,
                              width:
                                  MediaQuery.of(context).size.width / 2 + 100,
                              color: Colors.grey[100],
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

Widget noRoomChatsMessage(String _imgUrl, _name) {
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
                child: Text(
                  'Your conversation with $_name is \n end-to-end encrypted',
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
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
  return GestureDetector(
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

Widget clubInfoButton(String _text, Icon _icon, Function _func) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    color: Get.isDarkMode ? Colors.grey[900] : Colors.grey[100],
    padding: EdgeInsets.all(10),
    child: GestureDetector(
      onTap: _func,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _icon,
          SizedBox(width: 5),
          Text(_text),
        ],
      ),
    ),
  );
}
