import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/views/customize_screen.dart';
import 'package:reflex/views/messaging_screen.dart';
import 'package:reflex/views/start_club.dart';
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

class AppMainDrawer extends StatefulWidget {
  @override
  _AppMainDrawerState createState() => _AppMainDrawerState();
}

class _AppMainDrawerState extends State<AppMainDrawer> {
  bool _themeSwitchValue = kGetStorage.read('isDarkTheme');

  void changeAppTheme(bool _themeBool) async {
    if (mounted) {
      setState(() {
        _themeSwitchValue = !_themeSwitchValue;
      });
    }

    kGetStorage.remove('isDarkTheme');

    Get.changeTheme(
      Get.isDarkMode ? ThemeData.light() : ThemeData.dark(),
    );

    kGetStorage.write('isDarkTheme', _themeSwitchValue);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: kPrimaryColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width / 2 + 100,
                // color: Colors.white,
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(kMyProfileImage),
                    ),
                    sideDrawerItem(
                        'My profile',
                        Icon(
                          CupertinoIcons.person,
                          color: Colors.white,
                        ), () {
                      Get.to(
                        CustomizeScreen(),
                      );
                    }),
                    Divider(),
                    sideDrawerItem(
                        'Customize app interface',
                        Icon(
                          CupertinoIcons.paintbrush,
                          color: Colors.white,
                        ), () {
                      Get.to(
                        CustomizeScreen(),
                      );
                    }),
                    sideDrawerItem(
                        'Start a club',
                        Icon(
                          CupertinoIcons.person_2,
                          color: Colors.white,
                        ), () {
                      Get.to(
                        StartClub(),
                      );
                    }),
                    sideDrawerItem(
                        'New conversation',
                        Icon(
                          CupertinoIcons.plus_bubble,
                          color: Colors.white,
                        ), () {
                      Get.to(
                        CustomizeScreen(),
                      );
                    }),
                    sideDrawerItem(
                        'Share an update',
                        Icon(
                          CupertinoIcons.timer,
                          color: Colors.white,
                        ), () {
                      Get.to(
                        CustomizeScreen(),
                      );
                    }),
                    sideDrawerItem(
                        'Logout',
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                        ), () {
                      Get.to(
                        CustomizeScreen(),
                      );
                    }),
                    Row(
                      children: [
                        sideDrawerItem(
                          'Dark Mode',
                          Icon(
                            CupertinoIcons.moon_fill,
                            color: Colors.white,
                          ),
                          () {},
                        ),
                        Switch(
                          value: _themeSwitchValue,
                          onChanged: (value) => changeAppTheme(value),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget sideDrawerItem(String _text, Icon _icon, Function _func) {
  return GestureDetector(
    onTap: _func,
    child: Container(
      padding: EdgeInsets.fromLTRB(0, 15, 10, 15),
      child: Row(
        children: [
          _icon,
          SizedBox(width: 8),
          Text(_text, style: kWhiteFont16),
        ],
      ),
    ),
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
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}

Widget messageTile(String _name, _profilePhoto, _userId) {
  return Container(
    child: Column(
      children: [
        ListTile(
          onTap: () => Get.to(
            MessagingScreen(_name, _profilePhoto, _userId),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _name == kMyName ? 'Saved' : _name,
                style: TextStyle(
                  fontSize: 16,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                  // fontFamily: kDefaultFontBold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          leading: _name != kMyName
              ? Hero(
                  tag: _userId,
                  child: Container(
                    height: 60,
                    width: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey[200],
                      image: DecorationImage(
                        image: NetworkImage(_profilePhoto),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 60,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey[200],
                  ),
                  child: Icon(
                    CupertinoIcons.bookmark_fill,
                    color: kPrimaryColor,
                  ),
                ),
          subtitle: Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'yeah i also love chimichangas and ice cream cones with cherry',
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.grey,
                        // fontFamily: kDefaultFont,
                      ),
                    ),
                  ),
                  Text(
                    '12:43 pm',
                    style: kGrey11,
                  ),
                ],
              ),
            ],
          ),
        ),
        // Divider(),
      ],
    ),
  );
}

Widget circleTile(String _name, _profilePhoto, _userId) {
  return Container(
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
                color: Colors.grey[200],
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
        // ),
        // Divider(),
      ],
    ),
  );
}

Widget gridCard(String _name, String _profilePhoto, String _userId) {
  return Container(
    height: 200,
    width: 180,
    margin: EdgeInsets.all(5),
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: !Get.isDarkMode ? Colors.grey[100] : kDarkBodyThemeBlack,
      border: Border.all(
        color: !Get.isDarkMode ? Colors.grey[200] : Colors.transparent,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(_profilePhoto),
          backgroundColor: Colors.grey[200],
        ),
        SizedBox(height: 6),
        Text(
          _name,
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6),
        squareButton(
          'Send message',
          () => Get.to(
            MessagingScreen(
              _name,
              _profilePhoto,
              _userId,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget clubGridCard(String _name, String _profilePhoto) {
  // return Container(
  //   height: 200,
  //   width: 180,
  //   margin: EdgeInsets.all(5),
  //   padding: EdgeInsets.all(5),
  //   // decoration: BoxDecoration(
  //   //   color: !Get.isDarkMode
  //   //       ? kPrimaryColor.withOpacity(0.15)
  //   //       : Colors.transparent,
  //   //   // border: Border.all(
  //   //   //   color: Colors.grey[100],
  //   //   //   width: 1,
  //   //   // ),
  //   //   borderRadius: BorderRadius.circular(10),
  //   // ),
  //   decoration: BoxDecoration(
  //     color: !Get.isDarkMode ? Colors.grey[100] : kDarkBodyThemeBlack,
  //     border: Border.all(
  //       color: !Get.isDarkMode ? Colors.grey[200] : Colors.transparent,
  //       width: 1,
  //     ),
  //     borderRadius: BorderRadius.circular(4),
  //   ),
  //   child: Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       CircleAvatar(
  //         radius: 35,
  //         backgroundImage: NetworkImage(_profilePhoto),
  //         backgroundColor: Colors.grey[200],
  //       ),
  //       SizedBox(height: 6),
  //       Text(
  //         _name,
  //         softWrap: false,
  //         maxLines: 1,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //       SizedBox(height: 6),
  //       squareButton('Join club', () {}),
  //     ],
  //   ),
  // );
  //
  //

  return Container(
    height: 200,
    width: 180,
    margin: EdgeInsets.all(5),
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: !Get.isDarkMode ? Colors.grey[100] : kDarkBodyThemeBlack,
      border: Border.all(
        color: !Get.isDarkMode ? Colors.grey[200] : Colors.transparent,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(_profilePhoto),
          backgroundColor: Colors.grey[200],
        ),
        SizedBox(height: 6),
        Text(
          _name,
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6),
        squareButton(
          'Join club',
          () {},
        ),
      ],
    ),
  );
}

Widget squareButton(String _btnText, Function _func) {
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

Widget searchBox() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15),
    // height: 40,
    child: TextFormField(
      onChanged: (value) {
        // kGetController.queryText.value = value;

        // if (value != '') {
        //   kGetController.hasInitSearch.value = true;
        //   kGetController.update();
        // } else {
        //   kGetController.hasInitSearch.value = false;
        //   kGetController.update();
        // }
      },
      decoration: InputDecoration(
        suffixIcon: Icon(
          CupertinoIcons.search,
          color: Colors.grey[400],
          size: 19,
        ),
        contentPadding: EdgeInsets.all(10),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0.8,
            color: Colors.grey[200],
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0.8,
            color: Colors.grey[200],
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        hintText: 'Search for chats',
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    ),
  );
}

class MessageItem extends StatefulWidget {
  final _messageText;
  final _messageTimeStamp;
  final String _senderName;
  final String _senderId;
  final String _senderProfileImage;
  final String _messageImage;
  final String _messageType;
  final String _messageId;
  final String _roomId;

  MessageItem(
    this._messageText,
    this._messageTimeStamp,
    this._senderName,
    this._senderId,
    this._senderProfileImage,
    this._messageImage,
    this._messageType,
    this._messageId,
    this._roomId,
  );

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {
    DateTime myDateTime = widget._messageTimeStamp.toDate();
    String dateString = DateFormat('K:mm').format(myDateTime);
    var myMessage = widget._senderId == kMyId;

    return GestureDetector(
      onTap: () => print('show delete dilogue or smn'),
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
                  ? GestureDetector(
                      // onTap: () => Get.to(
                      //   OtherUserScreen(widget._senderId, widget._senderName),
                      // ),
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.grey[100],
                        backgroundImage:
                            NetworkImage(widget._senderProfileImage),
                      ),
                    )
                  : Container(),
              SizedBox(width: 10),
              widget._messageText == null || widget._messageText == ''
                  ? Container()
                  : GestureDetector(
                      onDoubleTap: () {
                        final roomMessagesRef = kChatRoomsRef
                            .doc(widget._roomId)
                            .collection('RoomMessages');

                        if (widget._senderId == kMyId)
                          roomMessagesRef.doc(widget._messageId).delete();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: myMessage ? kPrimaryColor : Colors.grey[100],
                          borderRadius: BorderRadius.circular(11),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 2 + 100,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget._messageText,
                              style: TextStyle(
                                // color: Colors.black,
                                color: myMessage ? Colors.white : Colors.black,
                                // color: Get.isDarkMode ? Colors.white : Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              dateString,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                            ),
                            // !myMessage
                            //     ? Text(
                            //         dateString,
                            //         style: TextStyle(
                            //           fontSize: 12,
                            //           color: Colors.grey[400],
                            //         ),
                            //       )
                            //     : Container(width: 0, height: 0),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
          widget._messageType == 'photoMessage' && widget._messageImage != null
              ? GestureDetector(
                  onTap: () => Get.to(
                    ViewPhotoScreen(widget._messageImage),
                  ),
                  // onLongPress: () => Get.to(
                  //   () => ViewPhotoScreen(widget._postImage),
                  // ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    margin: EdgeInsets.only(top: 10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 2 + 100,
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
          // SizedBox(height: 10),
          // myMessage
          //     ? Text(
          //         dateString,
          //         style: TextStyle(
          //           fontSize: 12,
          //           color: Colors.grey[400],
          //         ),
          //       )
          //     : SizedBox.shrink(),
          // !myMessage
          //     ? Container(
          //         margin: EdgeInsets.only(left: 40),
          //         child: Text(
          //           '${widget._senderName} $dateString',
          //           style: TextStyle(
          //             fontSize: 12,
          //             color: Colors.grey[400],
          //           ),
          //         ),
          //       )
          //     : SizedBox.shrink(),
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
    child: messageTile(
      kMyName,
      kMyProfileImage,
      kMyId,
    ),
  );
}
