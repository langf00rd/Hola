import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/views/start_club.dart';
import 'package:reflex/widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TabController _controller;
  TextEditingController _searchController = TextEditingController();

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            _searchController.text = value;
          });
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          hintText: 'Search for people, groups ...',
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _peopleTab() {
    return _searchController.value.text.isNotEmpty
        ? StreamBuilder<QuerySnapshot>(
            stream: kUsersRef
                .where("name",
                    isGreaterThanOrEqualTo: _searchController.text.capitalize)
                .where('name', isNotEqualTo: kMyName)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                return Center(child: myLoader());
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
                height: MediaQuery.of(context).size.height - 200,
                padding: EdgeInsets.only(top: 20),
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return snapshot.data.docs[index]['userId'] != kMyId
                        ? userTile(
                            snapshot.data.docs[index]['name'],
                            snapshot.data.docs[index]['profileImage'],
                            snapshot.data.docs[index]['userId'],
                            snapshot.data.docs[index]['interestOne'],
                            snapshot.data.docs[index]['interestTwo'],
                          )
                        : SizedBox.shrink();
                  },
                ),
              );
            },
          )
        : Container();
  }

  Widget _groupsTab() {
    return _searchController.value.text.isNotEmpty
        ? StreamBuilder<QuerySnapshot>(
            stream: kClubsRef
                .where("clubName",
                    isGreaterThanOrEqualTo: _searchController.text.capitalize)
                // .where('isClubPrivate', isNotEqualTo: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error fetching data...',
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: myLoader());
              }

              if (snapshot.data.docs.length == 0) {
                return noDataSnapshotMessage(
                  'Sorry couldn\'t find groups with that name',
                  defaultRoundButton(
                    'Create your group',
                    () => Get.to(StartClub()),
                  ),
                );
              }

              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 200,
                padding: EdgeInsets.only(top: 20),
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return snapshot.data.docs[index]['isClubPrivate'] == false
                        ? groupTile(
                            snapshot.data.docs[index]['clubName'],
                            snapshot.data.docs[index]['clubProfileImage'],
                            snapshot.data.docs[index]['clubId'],
                            snapshot.data.docs[index]['clubCategory'],
                            snapshot.data.docs[index]['clubDescription'],
                          )
                        : Container();
                  },
                ),
              );
            },
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: !Get.isDarkMode ? Colors.white : kDarkThemeBlack,
            appBar: AppBar(
              backgroundColor: !Get.isDarkMode ? Colors.white : kDarkThemeBlack,
              title: searchBox(),
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Get.isDarkMode ? Colors.white : kPrimaryColor,
                ),
                onPressed: () => Get.back(),
              ),
              bottom: _searchController.value.text.isNotEmpty
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(40),
                      child: Container(
                        child: myTabBar(
                          [
                            textTabLabel('People'),
                            textTabLabel('Open groups'),
                          ],
                          _controller,
                        ),
                      ),
                    )
                  : PreferredSize(
                      preferredSize: Size.fromHeight(0),
                      child: Container(height: 0),
                    ),
            ),
            body: TabBarView(
              children: [
                _peopleTab(),
                _groupsTab(),
              ],
              controller: _controller,
            ),
          ),
        ),
      ),
    );
  }
}
