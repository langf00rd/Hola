import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/services/services.dart';
import 'package:reflex/views/club_messaging_screen.dart';
import 'package:reflex/views/search_screen.dart';
import 'package:reflex/views/user.dart';
import 'package:reflex/views/view_photo_screen.dart';
import 'package:reflex/widgets/widget.dart';
import 'package:intl/intl.dart';

class ClubInfoScreen extends StatefulWidget {
  final _clubId;
  final String _profilePhoto;
  final String _clubName;
  final String _clubDescription;
  final String _clubCategory;

  ClubInfoScreen(
    this._clubId,
    this._profilePhoto,
    this._clubName,
    this._clubDescription,
    this._clubCategory,
  );

  @override
  _ClubInfoScreenState createState() => _ClubInfoScreenState();
}

class _ClubInfoScreenState extends State<ClubInfoScreen> {
  var _clubCreated;
  String _clubAdminId = '';
  String _clubAdminName = '';
  // List _clubMembers = [];
  String _joinState;
  int _membersNum = 0;
  String _clubAdminProfileImage;
  bool loading = true;

  Future _getClubData() async {
    try {
      DocumentReference clubRef = kClubsRef.doc(widget._clubId);

      await clubRef.get().then((doc) {
        if (mounted) {
          setState(() {
            _clubCreated = doc.data()['clubCreated'];
            _clubAdminId = doc.data()['clubAdminId'];
            _clubAdminName = doc.data()['clubAdminName'];
            // _clubMembers = doc.data()['clubMembers'];
          });
        }
      });

      DateTime myDateTime =
          _clubCreated != null ? _clubCreated.toDate() : DateTime.now();
      String _convertedDate = DateFormat.yMMMd().format(myDateTime);

      if (mounted) {
        setState(() {
          _clubCreated = _convertedDate;
        });
      }

      _initGetJoinState();
    } catch (e) {
      print(e);
    }
  }

  _initGetJoinState() async {
    try {
      // if (mounted) {
      //   setState(() {
      //     loading = true;
      //   });
      // }

      await kClubsRef
          .doc(widget._clubId)
          .collection('Members')
          .doc(kMyId)
          .get()
          .then(
        (doc) async {
          if (doc.exists) {
            if (mounted) {
              setState(() {
                _joinState = 'Joined';
                loading = false;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                //     // _joinState = 'NotJoined';
                loading = false;
              });
            }
          }
        },
      );
    } catch (e) {
      singleButtonDialogue('Sorry, an error occured');
    }
  }

  void _getClubAdminData() async {
    try {
      if (_clubAdminId != '') {
        DocumentReference usersRef = kUsersRef.doc(_clubAdminId);

        await usersRef.get().then((doc) {
          if (mounted) {
            setState(() {
              _clubAdminProfileImage = doc.data()['profileImage'];
            });
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  initJoinClub() {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    addMeToClub(
      _clubAdminId,
      widget._clubId,
      widget._clubName,
    ).then((value) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }

      singleButtonDialogue('You joined ${widget._clubName}');
      _initGetJoinState();
      _getMembersNum();
    });
  }

  _getMembersNum() async {
    await kClubsRef
        .doc(widget._clubId)
        .collection('Members')
        .where('joinState', isEqualTo: 'Joined')
        .get()
        .then((myDocuments) {
      if (mounted) {
        setState(() {
          _membersNum = myDocuments.docs.length;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getClubData();
    _getMembersNum();
    _getClubAdminData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.isDarkMode ? kDarkBodyThemeBlack : Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: !Get.isDarkMode ? Colors.white : kDarkBodyThemeBlack,
          appBar: AppBar(
            backgroundColor:
                !Get.isDarkMode ? Colors.white : kDarkBodyThemeBlack,
            title: Text(
              widget._clubName,
              style: TextStyle(
                fontSize: 23,
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Get.isDarkMode ? Colors.white : kPrimaryColor,
              ),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  CupertinoIcons.search,
                  color: Get.isDarkMode ? Colors.white : kPrimaryColor,
                ),
                onPressed: () => Get.to(SearchScreen()),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.to(
                        ViewPhotoScreen(widget._profilePhoto),
                      ),
                      child: Hero(
                        tag: widget._clubId,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: NetworkImage(widget._profilePhoto),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  !loading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _joinState != null && _joinState == 'Joined'
                                ? textColorRoundButton(
                                    Icon(
                                      CupertinoIcons.bubble_left_fill,
                                      color: kPrimaryColor,
                                    ),
                                    'Chat',
                                    () => Get.to(
                                      ClubMessagingScreen(
                                        widget._clubId,
                                        widget._profilePhoto,
                                        widget._clubName,
                                        widget._clubDescription,
                                        widget._clubCategory,
                                      ),
                                    ),
                                  )
                                : Container(width: 0, height: 0),
                            _clubAdminId != kMyId && _joinState == null
                                ? textColorRoundButton(
                                    Icon(
                                      CupertinoIcons.plus,
                                      color: kPrimaryColor,
                                    ),
                                    'Join',
                                    () {
                                      initJoinClub();
                                    },
                                  )
                                : Container(width: 0, height: 0),
                            _joinState != null &&
                                    _clubAdminId != kMyId &&
                                    _joinState == 'Joined'
                                ? textColorRoundButton(
                                    Icon(
                                      CupertinoIcons.xmark,
                                      color: kPrimaryColor,
                                    ),
                                    'Leave',
                                    () {
                                      if (mounted) {
                                        setState(() {
                                          loading = true;
                                        });
                                      }
                                      leaveClub(widget._clubId).then((value) {
                                        _initGetJoinState();
                                        _getMembersNum();

                                        singleButtonDialogue(
                                            'You left ${widget._clubName}');

                                        if (mounted) {
                                          setState(() {
                                            loading = false;
                                          });
                                        }
                                      });
                                    },
                                  )
                                : Container(width: 0, height: 0),
                            _clubAdminId == kMyId
                                ? textColorRoundButton(
                                    Icon(
                                      Icons.more_horiz,
                                      color: kPrimaryColor,
                                    ),
                                    'More',
                                    () {},
                                  )
                                : Container(width: 0, height: 0),
                            textColorRoundButton(
                              Icon(
                                Icons.mail,
                                color: kPrimaryColor,
                              ),
                              'Invite',
                              () {},
                            ),
                          ],
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Center(
                            child: myLoader(),
                          ),
                        ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          widget._clubName,
                          style: TextStyle(
                            fontSize: 17,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          widget._clubDescription,
                          style: TextStyle(
                            fontSize: 15,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 10),
                        Text(
                          _membersNum > 1
                              ? '$_membersNum members'
                              : '$_membersNum member',
                          style: TextStyle(
                            fontSize: 15,
                            color: Get.isDarkMode ? Colors.white : Colors.grey,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _clubCreated != null
                              ? 'Group created $_clubCreated'
                              : '',
                          style: TextStyle(
                            fontSize: 15,
                            color: Get.isDarkMode ? Colors.white : Colors.grey,
                          ),
                        ),
                        SizedBox(height: 10),
                        _clubAdminProfileImage != null
                            ? Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.to(
                                      UserScreen(
                                        _clubAdminId,
                                        _clubAdminProfileImage,
                                        _clubAdminName,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 13,
                                      backgroundImage:
                                          NetworkImage(_clubAdminProfileImage),
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    _clubAdminName,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
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
