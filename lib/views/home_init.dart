import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/views/club_chats_screen.dart';
import 'package:reflex/views/explore_screen.dart';
import 'package:reflex/views/home_screen.dart';
import 'package:reflex/widgets/widget.dart';

class HomeInit extends StatefulWidget {
  @override
  _HomeInitState createState() => _HomeInitState();
}

class _HomeInitState extends State<HomeInit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;

  List<Widget> _allScreens = [
    HomeScreen(),
    ClubChatsScreen(),
    Center(
      child: Text('search'),
    ),
    ExploreScreen(),
    Center(
      child: Text('updates'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Container(
        // color: Get.isDarkMode ? kDarkThemeBlack : kPrimaryColor,
        // color: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: AppMainDrawer(),
        
          body: TabBarView(children: _allScreens),
          bottomNavigationBar: Container(
            child: BottomAppBar(
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Container(
                      child: Icon(
                        CupertinoIcons.ellipses_bubble,
                        size: 27,
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: Icon(
                        CupertinoIcons.person_2,
                        size: 27,
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: Icon(
                        CupertinoIcons.search,
                        size: 27,
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: Icon(
                        CupertinoIcons.heart,
                        size: 27,
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: Icon(
                        CupertinoIcons.time,
                        size: 27,
                      ),
                    ),
                  ),
                ],
                indicatorColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor:
                    Get.isDarkMode ? Colors.white : Colors.black,
                labelColor: kPrimaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
