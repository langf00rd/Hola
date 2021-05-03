import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/views/start_club.dart';
import 'package:reflex/widgets/widget.dart';

class NewMessageScreen extends StatefulWidget {
  @override
  _NewMessageScreenState createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  TextEditingController _searchController = TextEditingController();

  Widget searchBox() {
    return Container(
      child: TextFormField(
        onChanged: (value) {
          if (mounted) {
            setState(() {
              _searchController.text = value;
            });
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(CupertinoIcons.search, color: Colors.grey),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          hintText: 'Search for people',
          hintStyle: TextStyle(fontSize: 15),
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
          backgroundColor: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
          appBar: AppBar(
            backgroundColor: !Get.isDarkMode ? Colors.white : kDarkThemeBlack,
            title: Text(
              'New message',
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
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.group_solid,
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => Get.to(StartClub()),
                              child: Text(
                                'Create group',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Get.to(StartClub()),
                          child: Icon(
                            CupertinoIcons.chevron_forward,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                                          ? userTile(
                                              snapshot.data.docs[index]['name'],
                                              snapshot.data.docs[index]
                                                  ['profileImage'],
                                              snapshot.data.docs[index]
                                                  ['userId'],
                                              snapshot.data.docs[index]
                                                  ['interestOne'],
                                              snapshot.data.docs[index]
                                                  ['interestTwo'],
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
                          stream: kInterestSharingPeopleRef
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
                                  child: Text(''),
                                ),
                              );
                            }

                            if (snapshot.data.docs.length == 0) {
                              return Text('');
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Suggested people',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                                Container(
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
                                          ? userTile(
                                              snapshot.data.docs[index]['name'],
                                              snapshot.data.docs[index]
                                                  ['profileImage'],
                                              snapshot.data.docs[index]
                                                  ['userId'],
                                              snapshot.data.docs[index]
                                                  ['interestOne'],
                                              snapshot.data.docs[index]
                                                  ['interestTwo'],
                                            )
                                          : SizedBox.shrink();
                                    },
                                  ),
                                ),
                              ],
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
