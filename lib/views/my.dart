import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/services/services.dart';
import 'package:reflex/views/customize_screen.dart';
import 'package:reflex/views/edit_profile.dart';
import 'package:reflex/views/search_screen.dart';
import 'package:reflex/views/sign_screen.dart';
import 'package:reflex/views/start_club.dart';
import 'package:reflex/widgets/widget.dart';

class My extends StatefulWidget {
  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<My> {
  bool _themeSwitchValue = kGetStorage.read('isDarkTheme');

  void changeAppTheme(bool _themeBool) async {
    if (mounted) {
      setState(() {
        _themeSwitchValue = !_themeSwitchValue;
      });
    }

    Get.isDarkMode
        ? Get.changeTheme(ThemeData.light())
        : Get.changeTheme(ThemeData.dark());
    setState(() {});

    kGetStorage.remove('isDarkTheme');
    kGetStorage.write('isDarkTheme', _themeSwitchValue);
    setState(() {});
    singleButtonDialogue('Restart the app to see new theme in action');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            backgroundColor: !Get.isDarkMode ? Colors.white : kDarkThemeBlack,
            title: Text(
              'Settings',
              style: TextStyle(
                fontSize: 23,
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Get.isDarkMode ? Colors.white : kPrimaryColor,
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
              IconButton(
                icon: Icon(
                  CupertinoIcons.pen,
                  color: Get.isDarkMode ? Colors.white : kPrimaryColor,
                ),
                onPressed: () => Get.to(EditProfileScreen()),
              ),
              IconButton(
                icon: Icon(
                  Icons.share_outlined,
                  color: Get.isDarkMode ? Colors.white : kPrimaryColor,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: GestureDetector(
                    onTap: () => Get.to(EditProfileScreen()),
                    child: Row(
                      children: [
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => Get.to(EditProfileScreen()),
                          child: kMyProfileImage == null
                              ? Hero(
                                  tag: kMyId,
                                  child: CircleAvatar(
                                    radius: 38,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage:
                                        AssetImage('assets/temporalPhoto.png'),
                                  ),
                                )
                              : Hero(
                                  tag: kMyId,
                                  child: CircleAvatar(
                                    radius: 38,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage:
                                        NetworkImage(kMyProfileImage),
                                  ),
                                ),
                        ),
                        SizedBox(width: 20),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                kMyName,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                kMyAbout,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              // SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    children: [
                      // textIconRoundButton(
                      //             Icon(
                      //               CupertinoIcons.pen,
                      //               color: kPrimaryColor,
                      //             ),
                      //             'Edit account info',
                      //             () {},
                      //           ),
                      //
                      //
                      sideDrawerItem(
                          'Customize app interface',
                          Icon(
                            CupertinoIcons.paintbrush,
                            // color: Colors.black,
                          ), () {
                        Get.to(
                          CustomizeScreen(),
                        );
                      }),
                      sideDrawerItem(
                          'Start a club',
                          Icon(
                            CupertinoIcons.person_2,
                            // color: Colors.black,
                          ), () {
                        Get.to(
                          StartClub(),
                        );
                      }),
                      sideDrawerItem(
                          'New conversation',
                          Icon(
                            CupertinoIcons.plus_bubble,
                          ), () {
                        Get.to(
                          CustomizeScreen(),
                        );
                      }),
                      sideDrawerItem(
                          'Share an update',
                          Icon(
                            CupertinoIcons.timer,
                          ), () {
                        Get.to(
                          CustomizeScreen(),
                        );
                      }),
                      sideDrawerItem(
                          'Logout',
                          Icon(
                            Icons.logout,
                          ), () {
                        removeAllStorageVariables();
                        signOut();
                        Get.offAll(SignScreen());
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          sideDrawerItem(
                            Get.isDarkMode ? 'Light Mode' : 'Dark theme',
                            Icon(
                              Get.isDarkMode
                                  ? CupertinoIcons.sun_max
                                  : CupertinoIcons.moon,
                            ),
                            () {},
                          ),
                          Switch(
                            value: _themeSwitchValue,
                            onChanged: (value) => changeAppTheme(value),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
