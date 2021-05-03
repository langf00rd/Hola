import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/views/update_about.dart';
import 'package:reflex/views/update_profile_photo.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
              'Profile',
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
          ),
          body: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: () => Get.to(UpdateProfilePhoto()),
                    child: Hero(
                      tag: kMyId,
                      child: kMyProfileImage == null
                          ? CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.grey[200],
                              backgroundImage:
                                  AssetImage('assets/temporalPhoto.png'),
                            )
                          : CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: NetworkImage(kMyProfileImage),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () => Get.to(UpdateAbout()),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.person_fill,
                          size: 30,
                        ),
                        SizedBox(width: 20),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('About you', style: kBold15),
                              SizedBox(height: 13),
                              Text(kMyAbout),
                            ],
                          ),
                        ),
                      ],
                    ),
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
