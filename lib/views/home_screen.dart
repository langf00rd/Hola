import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/services/services.dart';
import 'package:reflex/views/new_message.dart';
import 'package:reflex/views/people_screen.dart';
import 'package:reflex/views/search_screen.dart';
import 'package:reflex/views/start_club.dart';
import 'package:reflex/widgets/widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var messagesBuilder = StreamBuilder<QuerySnapshot>(
    stream: kChatRoomsRef
        .where('roomUsers', arrayContains: kMyId)
        .orderBy(
          'lastMessageTime',
        )
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          margin: EdgeInsets.only(top: 100, bottom: 100),
          child: noDataSnapshotMessage(
            'You have no conversation history',
            defaultRoundButton(
              'Find people',
              () => Get.to(PeopleScreen()),
            ),
          ),
        );
      }

      return Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: snapshot.data.docs.length,
          reverse: true,
          primary: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return RoomChatItem(snapshot.data.docs[index]['roomUsers']);
          },
        ),
      );
    },
  );

  var groupMessagesBuilder = StreamBuilder<QuerySnapshot>(
    stream: kClubsRef.where('clubMembers', arrayContains: kMyId).snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
        return Container();

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
  );

  @override
  void initState() {
    super.initState();
    registerNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: got new notif message");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: !Get.isDarkMode ? Colors.white : Colors.black,
        appBar: AppBar(
          backgroundColor: !Get.isDarkMode ? Colors.white : Colors.black,
          elevation: 0,
          title: Text(
            'Pipe',
            style: TextStyle(
              fontSize: 23,
              color: Get.isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Container(
            margin: EdgeInsets.all(4),
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
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: kPrimaryColor,
              elevation: 0,
              child: Icon(
                CupertinoIcons.plus,
                color: Colors.white,
              ),
              onPressed: () => Get.to(NewMessageScreen()),
              heroTag: null,
            ),
            SizedBox(
              height: 20,
            ),
            FloatingActionButton(
              backgroundColor: kPrimaryColor,
              elevation: 0,
              child: Icon(
                CupertinoIcons.person_2_fill,
                color: Colors.white,
              ),
              onPressed: () => Get.to(PeopleScreen()),
              heroTag: null,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 55,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: fakeSearchBox(),
                ),
              ),
              Flexible(child: messagesBuilder),
              Flexible(child: groupMessagesBuilder),
            ],
          ),
        ),
      ),
    );
  }
}
