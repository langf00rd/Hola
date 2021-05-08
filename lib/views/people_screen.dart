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
  // var peopleBuilder;
  var otherPeopleBuilder;

  @override
  void initState() {
    super.initState();

    // peopleBuilder = StreamBuilder<QuerySnapshot>(
    //   stream: kInterestSharingPeopleRef
    //       .where('userId', isNotEqualTo: kMyId)
    //       .snapshots(),
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return Center(
    //         child: Text(
    //           'Error fetching users...',
    //           style: TextStyle(
    //             color: Colors.redAccent,
    //           ),
    //         ),
    //       );
    //     }

    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Container(
    //         height: 200,
    //         child: Center(
    //           child: myLoader(),
    //         ),
    //       );
    //     }

    //     if (snapshot.data.docs.length == 0) {
    //       return Text('');
    //     }

    //     return Flexible(
    //       child: ListView.builder(
    //         physics: NeverScrollableScrollPhysics(),
    //         itemCount: snapshot.data.docs.length,
    //         itemBuilder: (context, index) {
    //           List chatMembers =
    //               snapshot.data.docs[index]['chatHistoryMembers'];

    //           return chatMembers.contains(kMyId)
    //               ? Text('')
    //               : userTile(
    //                   snapshot.data.docs[index]['name'],
    //                   snapshot.data.docs[index]['profileImage'],
    //                   snapshot.data.docs[index]['userId'],
    //                   snapshot.data.docs[index]['interestOne'],
    //                   snapshot.data.docs[index]['interestTwo'],
    //                 );
    //         },
    //       ),
    //     );
    //   },
    // );

    otherPeopleBuilder = StreamBuilder<QuerySnapshot>(
      stream: kUsersRef.where('userId', isNotEqualTo: kMyId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          return Text('');
        }

        if (snapshot.data.docs.length == 0) {
          return Text('');
        }

        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              List chatMembers =
                  snapshot.data.docs[index]['chatHistoryMembers'];

              return chatMembers.contains(kMyId)
                  ? Text('')
                  : userTile(
                      snapshot.data.docs[index]['name'],
                      snapshot.data.docs[index]['profileImage'],
                      snapshot.data.docs[index]['userId'],
                      snapshot.data.docs[index]['interestOne'],
                      snapshot.data.docs[index]['interestTwo'],
                      snapshot.data.docs[index]['interestThree'],
                    );
            },
          ),
        );
      },
    );
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
             elevation: 0,
            title: Text(
              'Find People',
              style: TextStyle(
                fontSize: 23,
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                color: Get.isDarkMode ? Colors.white : kPrimaryColor,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  CupertinoIcons.search,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: () => Get.to(SearchScreen()),
              ),
            ],
          ),
          body: Container(
            color: !Get.isDarkMode ? Colors.white : Colors.black,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  otherPeopleBuilder,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
