import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/views/search_screen.dart';
import 'package:reflex/widgets/widget.dart';

class PeopleScreen extends StatefulWidget {
  @override
  _PeopleScreenState createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  var peopleBuilder;

  @override
  void initState() {
    super.initState();

    peopleBuilder = Container(
      color: !Get.isDarkMode ? Colors.white : Colors.black,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                child: StreamBuilder<QuerySnapshot>(
              stream: kInterestSharingPeopleRef
                  .where('userId', isNotEqualTo: kMyId)
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

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 200,
                    child: Center(
                      child: myLoader(),
                    ),
                  );
                }

                if (snapshot.data.docs.length == 0) {
                  return Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: noDataSnapshotMessage(
                      'Couldn\'t find people sharing your interests',
                      defaultRoundButton(
                        'Search for people',
                        () => Get.to(SearchScreen()),
                      ),
                    ),
                  );
                }

                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      List chatMembers =
                          snapshot.data.docs[index]['chatHistoryMembers'];

                      return chatMembers.contains(kMyId)
                          ? Text('')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'These people share your interests',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                userTile(
                                  snapshot.data.docs[index]['name'],
                                  snapshot.data.docs[index]['profileImage'],
                                  snapshot.data.docs[index]['userId'],
                                  snapshot.data.docs[index]['interestOne'],
                                  snapshot.data.docs[index]['interestTwo'],
                                ),
                              ],
                            );

                      // return snapshot.data.docs[index]['userId'] != kMyId
                      //     ? userTile(
                      //         snapshot.data.docs[index]['name'],
                      //         snapshot.data.docs[index]['profileImage'],
                      //         snapshot.data.docs[index]['userId'],
                      //         snapshot.data.docs[index]['interestOne'],
                      //       )
                      //     : SizedBox.shrink();
                    },
                  ),
                );
              },
            )),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: !Get.isDarkMode ? Colors.white : kDarkBodyThemeBlack,

          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: kPrimaryColor,
          //   elevation: 0,
          //   onPressed: () => Get.to(NewMessageScreen()),
          //   child: Icon(CupertinoIcons.plus, color: Colors.white),
          // ),
          appBar: AppBar(
            backgroundColor: !Get.isDarkMode ? Colors.white : Colors.black,
            elevation: 0,
            title: Text(
              'Find People',
              style: TextStyle(
                fontSize: 23,
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
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
          body: peopleBuilder,
        ),
      ),
    );
  }
}
