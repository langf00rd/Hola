import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/views/messaging_screen.dart';
import 'package:reflex/views/search_screen.dart';
import 'package:reflex/views/view_photo_screen.dart';
import 'package:reflex/widgets/widget.dart';

class UserScreen extends StatefulWidget {
  final _userId;
  final String _profilePhoto;
  final String _name;
  UserScreen(this._userId, this._profilePhoto, this._name);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List userInterests = [];
  String email = '';
  bool loading = true;
  var joinDate;
  String about = '';
  var phoneNumber;

  Future getUserData() async {
    try {
      DocumentReference usersRef = kUsersRef.doc(widget._userId);

      await usersRef.get().then((doc) {
        setState(() {
          userInterests = doc.data()['interests'];
          email = doc.data()['email'];
          joinDate = doc.data()['joinDate'];
          phoneNumber = doc.data()['phoneNumber'];
          about = doc.data()['aboutUser'];
        });
      });
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: !Get.isDarkMode ? Colors.grey[100] : kDarkThemeBlack,
          appBar: AppBar(
            backgroundColor: !Get.isDarkMode ? Colors.white : kDarkThemeBlack,
            title: Text(
              widget._name,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
                    border: Border.all(
                      color: Get.isDarkMode
                          ? Colors.transparent
                          : Colors.grey[200],
                      width: 1,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(
                          ViewPhotoScreen(widget._profilePhoto),
                        ),
                        child: Hero(
                          tag: widget._userId,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: NetworkImage(widget._profilePhoto),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        widget._name,
                        style: TextStyle(
                          fontSize: 17,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          about,
                          style: TextStyle(
                            fontSize: 15,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          colorRoundButton(
                            Icon(
                              CupertinoIcons.bubble_left_fill,
                              color: kPrimaryColor,
                            ),
                            () => Get.to(
                              MessagingScreen(
                                widget._name,
                                widget._profilePhoto,
                                widget._userId,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          colorRoundButton(
                            Icon(
                              Icons.share,
                              color: kPrimaryColor,
                            ),
                            () {},
                          ),
                          SizedBox(width: 20),
                          colorRoundButton(
                            Icon(
                              CupertinoIcons.phone_fill,
                              color: kPrimaryColor,
                            ),
                            () {},
                          ),
                          SizedBox(width: 20),
                          colorRoundButton(
                            Icon(
                              CupertinoIcons.video_camera_solid,
                              color: kPrimaryColor,
                            ),
                            () {},
                          ),
                          SizedBox(width: 20),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                // SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '${widget._name}\'s interests',
                    style: TextStyle(
                      fontSize: 15,
                      color: Get.isDarkMode ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
                    border: Border.all(
                      color: Get.isDarkMode
                          ? Colors.transparent
                          : Colors.grey[200],
                      width: 1,
                    ),
                  ),
                  child: Container(
                    // scrollDirection: Axis.horizontal,
                    child: Wrap(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (var interest in userInterests)
                          Container(
                            // color: Colors.grey[100],
                            padding: EdgeInsets.symmetric(
                              vertical: 7,
                              horizontal: 12,
                            ),
                            margin: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Icon(
                                  (interest == 'Reading')
                                      ? CupertinoIcons.book_fill
                                      : CupertinoIcons.heart_fill

                                  //  :(interest == 'Reading')
                                  // ? CupertinoIcons.book_fill
                                  // : CupertinoIcons.heart_fill,

                                  ,
                                  color: Colors.red,
                                  size: 15,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  interest,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
