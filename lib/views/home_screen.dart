import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/views/club_chats_screen.dart';
import 'package:reflex/views/new_message.dart';
import 'package:reflex/views/search_screen.dart';
import 'package:reflex/widgets/widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabController _tabController;
  int _currentTabIndex = 0;
  var messagesBuilder;

  void changeTabIndex(int index) {
    if (mounted) {
      setState(() {
        _currentTabIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    messagesBuilder = Container(
      color: !Get.isDarkMode ? Colors.white : Colors.black,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: kChatRoomsRef
                    .where('roomUsers', arrayContains: kMyId)
                    .orderBy(
                      'lastMessageTime',
                    )
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      margin: EdgeInsets.only(top: 100),
                      child: noDataSnapshotMessage(
                        'You haven\'t started a conversation with anyone',
                        Text('Click on the pencil icon to start chatting'),
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
                        return RoomChatItem(
                            snapshot.data.docs[index]['roomUsers']);
                      },
                    ),
                  );
                },
              ),
            ),
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
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: !Get.isDarkMode ? Colors.white : Colors.black,
            appBar: AppBar(
              backgroundColor: !Get.isDarkMode ? Colors.white : Colors.black,
              elevation: 0,
              // title: fakeSearchBox(),
              title: Text(
                'Messenger',
                style: TextStyle(
                  fontSize: 23,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Padding(
                padding: EdgeInsets.all(1),
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
                IconButton(
                  icon: Icon(
                    CupertinoIcons.camera_fill,
                    color: Get.isDarkMode ? Colors.white : kPrimaryColor,
                  ),
                  onPressed: () {},
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(45),
                child: BottomAppBar(
                  color: !Get.isDarkMode ? Colors.white : Colors.black,
                  elevation: 0,
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) {
                      changeTabIndex(index);
                    },
                    tabs: [
                      Tab(
                        text: 'Messages',
                      ),
                      Tab(
                        text: 'Groups',
                      ),
                      Tab(
                        text: 'Active now',
                      ),
                    ],
                    indicatorColor: kPrimaryColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor:
                        Get.isDarkMode ? Colors.white : Colors.grey[500],
                    labelColor: kPrimaryColor,
                  ),
                ),
              ),
            ),
            body: IndexedStack(
              index: _currentTabIndex,
              children: [
                messagesBuilder,
                ClubChatsScreen(),
                Text('online'),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: 'homeFAB',
              backgroundColor: kPrimaryColor,
              elevation: 0.3,
              onPressed: () => Get.to(NewMessageScreen()),
              child: Icon(
                CupertinoIcons.plus,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
