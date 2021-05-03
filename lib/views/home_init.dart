import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/services/services.dart';
import 'package:reflex/views/explore_screen.dart';
import 'package:reflex/views/home_screen.dart';
import 'package:reflex/views/people_screen.dart';
import 'package:reflex/widgets/widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomeInit extends StatefulWidget {
  @override
  _HomeInitState createState() => _HomeInitState();
}

class _HomeInitState extends State<HomeInit> {
  TabController _tabController;
  int _currentTabIndex = 0;

  List<Widget> _allScreens = [
    HomeScreen(),
    PeopleScreen(),
    ExploreScreen(),
  ];

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
    registerNotification();
    // sendNotif();
    //
    // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    // FlutterLocalNotificationsPlugin();

    // var initializationSettingsAndroid =
    // new AndroidInitializationSettings('@mipmap/ic_launcher');

    // var initializationSettingsIOS = new IOSInitializationSettings();

    // var initializationSettings = new InitializationSettings(
    // initializationSettingsAndroid, initializationSettingsIOS);

    // flutterLocalNotificationsPlugin.initialize(initializationSettings,
    // onSelectNotification: onSelectNotification);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: $message['body]");

      // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      //     new FlutterLocalNotificationsPlugin();

      // const AndroidNotificationDetails androidPlatformChannelSpecifics =
      //     AndroidNotificationDetails('your channel id', 'your channel name',
      //         'your channel description',
      //         importance: Importance.max,
      //         priority: Priority.high,
      //         showWhen: false);

      // const NotificationDetails platformChannelSpecifics =
      //     NotificationDetails(android: androidPlatformChannelSpecifics);

      // await flutterLocalNotificationsPlugin.show(
      //     0, 'plain title', 'plain body', platformChannelSpecifics,
      //     payload: 'item x');

      // var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      //   'channel_ID',
      //   'channel name',
      //   'channel description',
      //   importance: Importance.max,
      //   playSound: true,
      //   sound: RawResourceAndroidNotificationSound('notifsound'),
      //   showProgress: true,
      //   priority: Priority.high,
      //   ticker: 'test ticker',
      // );

      // var platformChannelSpecifics =
      //     NotificationDetails(android: androidPlatformChannelSpecifics);

      // await flutterLocalNotificationsPlugin.show(
      //     0, message.toString(), 'notification body', platformChannelSpecifics,
      //     payload: 'test');

      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     content: ListTile(
      //       title: Text(message.data["body"]),
      //       subtitle: Text(message.toString()),
      //     ),
      //     actions: <Widget>[
      //       MaterialButton(
      //         child: Text('Ok'),
      //         onPressed: () => Navigator.of(context).pop(),
      //       ),
      //     ],
      //   ),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        child: Scaffold(
          bottomNavigationBar: Container(
            height: 55,
            child: BottomAppBar(
              color: !Get.isDarkMode ? Colors.white : Colors.black,
              elevation: 0,
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  changeTabIndex(index);
                },
                tabs: [
                  bottomNavIconTextLabel(
                    'Home',
                    Icon(
                      Icons.home,
                      size: 25,
                    ),
                  ),
                  bottomNavIconTextLabel(
                    'People',
                    Icon(
                      CupertinoIcons.person_2_fill,
                      size: 25,
                    ),
                  ),
                  // bottomNavIconTextLabel(
                  //   'Updates',
                  //   Icon(
                  //     CupertinoIcons.time,
                  //     size: 25,
                  //   ),
                  // ),
                  bottomNavIconTextLabel(
                    'Explore',
                    Icon(
                      CupertinoIcons.compass_fill,
                      size: 25,
                    ),
                  ),
                ],
                indicatorColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor:
                    Get.isDarkMode ? Colors.white : Colors.grey[500],
                labelColor: kPrimaryColor,
              ),
            ),
          ),
          body: IndexedStack(
            index: _currentTabIndex,
            children: _allScreens,
          ),
        ),
      ),
    );
  }
}
