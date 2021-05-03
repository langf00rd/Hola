import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/views/search_screen.dart';
import 'package:reflex/widgets/widget.dart';

class SeeAllPeople extends StatefulWidget {
  @override
  _SeeAllPeopleState createState() => _SeeAllPeopleState();
}

class _SeeAllPeopleState extends State<SeeAllPeople> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: !Get.isDarkMode ? Colors.white : kDarkThemeBlack,
            title: Text(
              'People',
              style: TextStyle(
                fontSize: 23,
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevation: 0.4,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: kPrimaryColor,
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
          body: StreamBuilder<QuerySnapshot>(
            stream: kUsersRef.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Text('');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
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
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return snapshot.data.docs[index]['userId'] != null &&
                            snapshot.data.docs[index]['userId'] != kMyId
                        ? userTile(
                            snapshot.data.docs[index]['name'],
                            snapshot.data.docs[index]['profileImage'],
                            snapshot.data.docs[index]['userId'],
                            snapshot.data.docs[index]['interestOne'],
                            snapshot.data.docs[index]['interestTwo'],
                          )
                        : Container();
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
