import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/views/search_screen.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: kPrimaryColor,
          //   elevation: 0.3,
          //   onPressed: () => Get.to(StartClub()),
          //   child: Icon(CupertinoIcons.plus, color: Colors.white),
          // ),
          appBar: AppBar(
            backgroundColor: !Get.isDarkMode ? Colors.white : kDarkThemeBlack,
            title: Text(
              'Explore',
              style: TextStyle(
                fontSize: 23,
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevation: 0,
            leading: Container(
              padding: EdgeInsets.all(5),
              child: appBarCircleAvatar,
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
                // Container(
                //   decoration: BoxDecoration(
                //     color: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
                //     border: Border.all(
                //       color: Get.isDarkMode
                //           ? Colors.transparent
                //           : Colors.grey[200],
                //       width: 1,
                //     ),
                //   ),
                //   child: StreamBuilder<QuerySnapshot>(
                //     stream: kUsersRef
                //         .where('userId', isNotEqualTo: kMyId)
                //         .snapshots(),
                //     builder: (BuildContext context,
                //         AsyncSnapshot<QuerySnapshot> snapshot) {
                //       if (!snapshot.hasData) {
                //         return Text('');
                //       }

                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return Text('');
                //       }

                //       if (snapshot.data.docs.length <= 0) {
                //         return Text('');
                //       }

                //       return Container(
                //         width: MediaQuery.of(context).size.width,
                //         height: 160,
                //         child: ListView.builder(
                //           itemCount: snapshot.data.docs.length,
                //           primary: false,
                //           scrollDirection: Axis.horizontal,
                //           shrinkWrap: true,
                //           itemBuilder: (context, index) {
                //             List chatMembers =
                //                 snapshot.data.docs[index]['chatHistoryMembers'];

                //             return chatMembers.contains(kMyId)
                //                 ? Container()
                //                 : snapshot.data.docs[index]['userId'] != null &&
                //                         snapshot.data.docs[index]['userId'] !=
                //                             kMyId
                //                     ? Column(
                //                         children: [
                //                           SizedBox(height: 5),
                //                           Row(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.spaceBetween,
                //                             children: [
                //                               Container(
                //                                 padding: EdgeInsets.all(10),
                //                                 child: Text(
                //                                   'Meet new people',
                //                                   style: TextStyle(
                //                                     fontSize: 15,
                //                                     color: Get.isDarkMode
                //                                         ? Colors.white
                //                                         : Colors.black,
                //                                     fontFamily:
                //                                         kDefaultFontBold,
                //                                   ),
                //                                 ),
                //                               ),
                //                               Row(
                //                                 children: [
                //                                   GestureDetector(
                //                                     onTap: () =>
                //                                         Get.to(SeeAllPeople()),
                //                                     child: Text(
                //                                       ' SEE ALL',
                //                                       style: TextStyle(
                //                                         fontSize: 15,
                //                                         color: kPrimaryColor,
                //                                         fontFamily:
                //                                             kDefaultFontBold,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                   Icon(
                //                                     CupertinoIcons
                //                                         .chevron_forward,
                //                                     color: kPrimaryColor,
                //                                   ),
                //                                 ],
                //                               ),
                //                             ],
                //                           ),
                //                           gridCard(
                //                             snapshot.data.docs[index]['name'],
                //                             snapshot.data.docs[index]
                //                                 ['profileImage'],
                //                             snapshot.data.docs[index]['userId'],
                //                           ),
                //                         ],
                //                       )
                //                     : Container();
                //           },
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // SizedBox(height: 20),
                // Container(
                //   decoration: BoxDecoration(
                //     color: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
                //     border: Border.all(
                //       color: Get.isDarkMode
                //           ? Colors.transparent
                //           : Colors.grey[200],
                //       width: 1,
                //     ),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           SizedBox(height: 5),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Container(
                //                 padding: EdgeInsets.all(10),
                //                 child: Text(
                //                   'Popular groups',
                //                   style: TextStyle(
                //                     fontSize: 15,
                //                     color: Get.isDarkMode
                //                         ? Colors.white
                //                         : Colors.black,
                //                     fontFamily: kDefaultFontBold,
                //                   ),
                //                 ),
                //               ),
                //               Row(
                //                 children: [
                //                   GestureDetector(
                //                     onTap: () => Get.to(SeeAllClubs()),
                //                     child: Text(
                //                       ' SEE ALL',
                //                       style: TextStyle(
                //                         fontSize: 15,
                //                         color: kPrimaryColor,
                //                         fontFamily: kDefaultFontBold,
                //                       ),
                //                     ),
                //                   ),
                //                   Icon(
                //                     CupertinoIcons.chevron_forward,
                //                     color: kPrimaryColor,
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //           StreamBuilder<QuerySnapshot>(
                //             stream: kClubsRef.snapshots(),
                //             builder: (BuildContext context,
                //                 AsyncSnapshot<QuerySnapshot> snapshot) {
                //               if (!snapshot.hasData) {
                //                 return Text('');
                //               }

                //               if (snapshot.connectionState ==
                //                   ConnectionState.waiting) {
                //                 return Text('');
                //               }

                //               if (snapshot.data.docs.length <= 0) {
                //                 return Container(
                //                   height: 100,
                //                   child: noDataSnapshotMessage(
                //                     'Sorry, could not find clubs',
                //                     Text(''),
                //                   ),
                //                 );
                //               }

                //               return Container(
                //                 width: MediaQuery.of(context).size.width,
                //                 height: 160,
                //                 child: ListView.builder(
                //                   itemCount: snapshot.data.docs.length,
                //                   primary: false,
                //                   scrollDirection: Axis.horizontal,
                //                   shrinkWrap: true,
                //                   itemBuilder: (context, index) {
                //                     return snapshot.data.docs[index]
                //                                 ['clubProfileImage'] !=
                //                             null
                //                         ? Container(
                //                             child: snapshot.data.docs[index]
                //                                             ['clubName'] !=
                //                                         null &&
                //                                     snapshot.data.docs[index]
                //                                             ['clubId'] !=
                //                                         kMyId
                //                                 ? clubGridCard(
                //                                     snapshot.data.docs[index]
                //                                         ['clubName'],
                //                                     snapshot.data.docs[index]
                //                                         ['clubProfileImage'],
                //                                     snapshot.data.docs[index]
                //                                         ['clubId'],
                //                                     snapshot.data.docs[index]
                //                                         ['clubDescription'],
                //                                     snapshot.data.docs[index]
                //                                         ['clubCategory'],
                //                                   )
                //                                 : Container(),
                //                           )
                //                         : Container();
                //                   },
                //                 ),
                //               );
                //             },
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
