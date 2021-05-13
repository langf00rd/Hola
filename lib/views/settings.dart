import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/models/models.dart';
import 'package:reflex/services/services.dart';
import 'package:reflex/views/edit_profile.dart';
import 'package:reflex/views/new_message.dart';
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
    AppBuilder.of(context).rebuild();

    kGetStorage.remove('isDarkTheme');
    kGetStorage.write('isDarkTheme', _themeSwitchValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? kDarkBodyThemeBlack : Colors.white,
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: kShadowInt,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
              color: Colors.white,
            ),
            onPressed: () => Get.to(SearchScreen()),
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.pen,
              color: Colors.white,
            ),
            onPressed: () => Get.to(EditProfileScreen()),
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
                                backgroundImage: NetworkImage(kMyProfileImage),
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
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            kMyAbout,
                            style: TextStyle(
                              fontSize: 15,
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
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
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  sideDrawerItem(
                      'Start a club',
                      Icon(
                        CupertinoIcons.person_2, color: Colors.grey,
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
                        color: Colors.grey,
                      ), () {
                    Get.to(
                      NewMessageScreen(),
                    );
                  }),
                  sideDrawerItem(
                      'Logout',
                      Icon(
                        Icons.logout,
                        color: Colors.grey,
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
                          color: Colors.grey,
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
    );
  }
}
