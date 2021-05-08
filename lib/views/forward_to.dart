import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart' hide Key;
import 'package:flutter/material.dart' hide Key;
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/services/services.dart';
import 'package:reflex/widgets/widget.dart';

class ForwardToScreen extends StatefulWidget {
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

  ForwardToScreen(
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
  _ForwardToScreenState createState() => _ForwardToScreenState();
}

class _ForwardToScreenState extends State<ForwardToScreen> {
  TextEditingController _searchController = TextEditingController();

  _forward(_userId) async {
    try {
      final String _room = getRoomId(_userId);

     
      if (!widget._isClub && widget._messageImage.length <= 0) {
        final plainText = widget._messageText;
        final key = Key.fromLength(32);
        final iv = IV.fromLength(16);
        final encrypter = Encrypter(AES(key));
        final encrypted = encrypter.encrypt(plainText, iv: iv);

        await sendMessage(
          _room,
          _userId,
          encrypted.base64,
        );

        await updateRoomLastInfo(_room, '📌 Forwarded message');
      }

      
      if (widget._messageImage.length > 0) {
        sendPhoto(
          widget._messageImage,
          _room,
          false,
        );

        await updateRoomLastInfo(_room, '🌄 Sent a photo');
      }
    } catch (e) {
      print(e);
    }
  }

  Widget searchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.black : Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextFormField(
        onChanged: (value) {
          if (mounted) {
            setState(() {
              _searchController.text = value;
            });
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          prefixIcon: Icon(CupertinoIcons.search, color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          hintText: 'Find someone',
          hintStyle: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget forwardUserTile(
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
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            title: Text(
              _name,
              style: TextStyle(
                fontSize: 15,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.grey[100],
              backgroundImage: NetworkImage(_profilePhoto),
            ),
            subtitle: Text(
              'Likes $_interestOne, $_interestTwo, $_interestThree',
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: Container(
              child: textButton(
                'Send ...',
                () async {
                  singleButtonDialogue('Sent');
                  await _forward(_userId);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.isDarkMode ? kDarkBodyThemeBlack : Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Get.isDarkMode ? kDarkBodyThemeBlack : Colors.white,
          appBar: AppBar(
            backgroundColor:
                !Get.isDarkMode ? Colors.white : kDarkBodyThemeBlack,
            title: Text(
              'Forward to...',
              style: TextStyle(
                fontSize: 23,
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: kPrimaryColor,
              ),
              onPressed: () => Get.back(),
            ),
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchBox(),
                  SizedBox(height: 10),
                  _searchController.value.text.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'showing results for "${_searchController.value.text}"',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: kUsersRef
                                  .where("name",
                                      isGreaterThanOrEqualTo:
                                          _searchController.text.capitalize)
                                  .where('name', isNotEqualTo: kMyName)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Error fetching users...',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  );
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                    height: 300,
                                    child: Center(
                                      child: myLoader(),
                                    ),
                                  );
                                }

                                if (snapshot.data.docs.length == 0) {
                                  return noDataSnapshotMessage(
                                    'Oops! No results',
                                    Text(
                                      'You might have to check your spelling.',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                }

                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height - 200,
                                  child: ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return snapshot.data.docs[index]
                                                  ['userId'] !=
                                              kMyId
                                          ? forwardUserTile(
                                              snapshot.data.docs[index]['name'],
                                              snapshot.data.docs[index]
                                                  ['profileImage'],
                                              snapshot.data.docs[index]
                                                  ['userId'],
                                              snapshot.data.docs[index]
                                                  ['interestOne'],
                                              snapshot.data.docs[index]
                                                  ['interestTwo'],
                                              snapshot.data.docs[index]
                                                  ['interestThree'],
                                            )
                                          : SizedBox.shrink();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : StreamBuilder<QuerySnapshot>(
                          stream: kUsersRef.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Error fetching users...',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                height: 300,
                                child: Center(
                                  child: Text(''),
                                ),
                              );
                            }

                            if (snapshot.data.docs.length == 0) {
                              return Text('');
                            }

                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height - 200,
                              child: ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return snapshot.data.docs[index]['userId'] !=
                                          kMyId
                                      ? forwardUserTile(
                                          snapshot.data.docs[index]['name'],
                                          snapshot.data.docs[index]
                                              ['profileImage'],
                                          snapshot.data.docs[index]['userId'],
                                          snapshot.data.docs[index]
                                              ['interestOne'],
                                          snapshot.data.docs[index]
                                              ['interestTwo'],
                                          snapshot.data.docs[index]
                                              ['interestThree'],
                                        )
                                      : SizedBox.shrink();
                                },
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
