import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/widgets/widget.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppMainDrawer(),
      appBar: AppBar(
        backgroundColor: !Get.isDarkMode ? Colors.white : kDarkThemeBlack,
        title: Text(
          'Discover',
          style: TextStyle(
            fontSize: 23,
            color: Get.isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
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
              decoration: BoxDecoration(
                color: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
                border: Border.all(
                  color: Get.isDarkMode ? Colors.transparent : Colors.grey[200],
                  width: 1,
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: kUsersRef
                    // .where('chatHistoryMembers', arrayContains: kMyId != null)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data.docs.length <= 0) {
                    return Container(
                      height: 100,
                      child: noDataSnapshotMessage(
                        'Sorry, could not find clubs',
                        Text(''),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('');
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Meet new people',
                              style: TextStyle(
                                fontSize: 15,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontFamily: kDefaultFontBold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'See all',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: kPrimaryColor,
                                  fontFamily: kDefaultFontBold,
                                ),
                              ),
                              Icon(
                                CupertinoIcons.chevron_forward,
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 160,
                        child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          primary: false,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return snapshot.data.docs[index]['userId'] !=
                                        null &&
                                    snapshot.data.docs[index]['userId'] != kMyId
                                ? gridCard(
                                    snapshot.data.docs[index]['name'],
                                    snapshot.data.docs[index]['profileImage'],
                                    snapshot.data.docs[index]['userId'],
                                  )
                                : Container();
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Discover clubs to join',
                              style: TextStyle(
                                fontSize: 15,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontFamily: kDefaultFontBold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'See all',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: kPrimaryColor,
                                  fontFamily: kDefaultFontBold,
                                ),
                              ),
                              Icon(
                                CupertinoIcons.chevron_forward,
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: kClubsRef.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Text('');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('');
                          }

                          if (snapshot.data.docs.length <= 0) {
                            return Container(
                              height: 100,
                              child: noDataSnapshotMessage(
                                'Sorry, could not find clubs',
                                Text(''),
                              ),
                            );
                          }

                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 160,
                            child: ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              primary: false,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return snapshot.data.docs[index]
                                            ['clubProfileImage'] !=
                                        null
                                    ? Container(
                                        child: snapshot.data.docs[index]
                                                        ['clubName'] !=
                                                    null &&
                                                snapshot.data.docs[index]
                                                        ['clubId'] !=
                                                    kMyId
                                            ? clubGridCard(
                                                snapshot.data.docs[index]
                                                    ['clubName'],
                                                snapshot.data.docs[index]
                                                    ['clubProfileImage'],
                                              )
                                            : Container(),
                                      )
                                    : Container();

                                // return snapshot.data.docs[index]['userId'] !=
                                //             null &&
                                //         snapshot.data.docs[index]['userId'] !=
                                //             kMyId
                                //     ? gridCard(
                                //         snapshot.data.docs[index]['name'],
                                //         snapshot.data.docs[index]
                                //             ['profileImage'],
                                //         snapshot.data.docs[index]['userId'],
                                //       )
                                //     : Container();
                              },
                            ),
                          );

                          // return Container(
                          //   // height: MediaQuery.of(context).size.height,
                          //   height: 200,
                          //   width: MediaQuery.of(context).size.width,
                          //   child: GridView.builder(
                          //     scrollDirection: Axis.horizontal,
                          //     // physics: NeverScrollableScrollPhysics(),
                          //     gridDelegate:
                          //         SliverGridDelegateWithFixedCrossAxisCount(
                          //             crossAxisCount: 2),
                          //     itemBuilder: (BuildContext context, int index) {
                          // return snapshot.data.docs[index]
                          //             ['clubProfileImage'] !=
                          //         null
                          //     ? Container(
                          //         child: snapshot.data.docs[index]
                          //                         ['clubName'] !=
                          //                     null &&
                          //                 snapshot.data.docs[index]
                          //                         ['clubId'] !=
                          //                     kMyId
                          //             ? clubGridCard(
                          //                 snapshot.data.docs[index]
                          //                     ['clubName'],
                          //                 snapshot.data.docs[index]
                          //                     ['clubProfileImage'],
                          //               )
                          //             : Container(),
                          //       )
                          //     : Container();
                          //     },
                          //     itemCount: snapshot.data.docs.length,
                          //   ),
                          // );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
