import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/widgets/widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        elevation: 0.3,
        onPressed: () {},
        child: Icon(CupertinoIcons.plus, color: Colors.white),
      ),
      drawer: AppMainDrawer(),
      appBar: AppBar(
        backgroundColor: !Get.isDarkMode ? Colors.white : kDarkThemeBlack,
        title: Text(
          'Messsages',
          style: TextStyle(
            fontSize: 23,
            color: Get.isDarkMode ? Colors.white : Colors.black,
            // fontFamily: kDefaultFontBold,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.4,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(kMyProfileImage),
              backgroundColor: Colors.grey[100],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                'Online',
                style: TextStyle(
                  fontSize: 15,
                  color: Get.isDarkMode ? Colors.white : Colors.grey,
                  // fontFamily: kDefaultFontBold,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
                border: Border.all(
                  color: Get.isDarkMode ? Colors.transparent : Colors.grey[200],
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: kUsersRef.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return fillInCircleTile();

                      if (!snapshot.hasData) return fillInCircleTile();

                      if (snapshot.data.docs.length <= 1)
                        return fillInCircleTile();

                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 95,
                        padding: EdgeInsets.only(top: 10),
                        child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          primary: false,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return snapshot.data.docs[index]['userId'] != null
                                ? circleTile(
                                    snapshot.data.docs[index]['name'],
                                    snapshot.data.docs[index]['profileImage'],
                                    snapshot.data.docs[index]['userId'],
                                  )
                                : Container();
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),

            // SizedBox(height: 5),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                'My chats',
                style: TextStyle(
                  fontSize: 15,
                  color: Get.isDarkMode ? Colors.white : Colors.grey,
                  // fontFamily: kDefaultFontBold,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
                border: Border.all(
                  color: Get.isDarkMode ? Colors.transparent : Colors.grey[200],
                  width: 1,
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: kUsersRef
                    .where('chatHistoryMembers', arrayContains: kMyId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return fillInMessageTile();

                  if (!snapshot.hasData) return fillInMessageTile();

                  if (snapshot.data.docs.length < 1) {
                    return noDataSnapshotMessage(
                      'You haven\'t started a conversation with anyone',
                      Text('Click on the \'+\' icon to start chatting'),
                    );
                  }

                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      primary: false,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return snapshot.data.docs[index]['userId'] != null
                            ? messageTile(
                                snapshot.data.docs[index]['name'],
                                snapshot.data.docs[index]['profileImage'],
                                snapshot.data.docs[index]['userId'],
                              )
                            : Container();
                      },
                    ),
                  );
                },
              ),
            ),
            // Divider(),
            // StreamBuilder<QuerySnapshot>(
            //   stream: kUsersRef
            //       .where('chatHistoryMembers', arrayContains: kMyId)
            //       .snapshots(),
            //   builder:
            //       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Container(
            //         height: 150,
            //         child: messageTile(
            //           kMyName,
            //           kMyProfileImage,
            //           kMyId,
            //         ),
            //       );
            //     }

            //     if (!snapshot.hasData) {
            //       return Container(
            //         height: 150,
            //         child: messageTile(
            //           kMyName,
            //           kMyProfileImage,
            //           kMyId,
            //         ),
            //       );
            //     }

            //     if (snapshot.data.docs.length < 1) {
            //       return noDataSnapshotMessage(
            //         'You haven\'t started a conversation with anyone',
            //         Text('Click on the \'+\' icon to start chatting'),
            //       );
            //     }

            //     return Container(
            //       width: MediaQuery.of(context).size.width,
            //       // height: 160,
            //       padding: EdgeInsets.only(top: 10),
            //       child: ListView.builder(
            //         itemCount: snapshot.data.docs.length,
            //         primary: false,
            //         scrollDirection: Axis.vertical,
            //         shrinkWrap: true,
            //         itemBuilder: (context, index) {
            //           return snapshot.data.docs[index]['userId'] != null
            //               ? messageTile(
            //                   snapshot.data.docs[index]['name'],
            //                   snapshot.data.docs[index]['profileImage'],
            //                   snapshot.data.docs[index]['userId'],
            //                 )
            //               : Container();
            //         },
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
