import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/views/start_club.dart';
import 'package:reflex/widgets/widget.dart';

class ClubChatsScreen extends StatefulWidget {
  @override
  _ClubChatsScreenState createState() => _ClubChatsScreenState();
}

class _ClubChatsScreenState extends State<ClubChatsScreen> {
  var groupChatsBuilder;

  @override
  void initState() {
    super.initState();

    groupChatsBuilder = Expanded(
      child: Container(
        color: !Get.isDarkMode ? Colors.white : Colors.black,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: kClubsRef
                      .where('clubMembers', arrayContains: kMyId)
                      //TODO .orderBy('lastRoomMessageTime')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error fetching chats...',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Container(
                        height: 200,
                        child: Center(
                          child: myLoader(),
                        ),
                      );

                    if (!snapshot.hasData) return Text('');

                    if (snapshot.data.docs.length < 1) {
                      return Container(
                        height: 300,
                        child: noDataSnapshotMessage(
                          'Join groups to engage in group conversations',
                          defaultRoundButton(
                            'Create a group',
                            () => Get.to(StartClub()),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ClubMessageTile(
                          snapshot.data.docs[index]['clubName'],
                          snapshot.data.docs[index]['clubProfileImage'],
                          snapshot.data.docs[index]['clubId'],
                          snapshot.data.docs[index]['clubDescription'],
                          snapshot.data.docs[index]['clubCategory'],
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return groupChatsBuilder;
  }
}
