import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/services/services.dart';
import 'package:reflex/views/view_photo_screen.dart';
import 'package:reflex/widgets/widget.dart';

class UpdateProfilePhoto extends StatefulWidget {
  @override
  _UpdateProfilePhotoState createState() => _UpdateProfilePhotoState();
}

class _UpdateProfilePhotoState extends State<UpdateProfilePhoto> {
  bool loading = false;
  final picker = ImagePicker();
  File _imageFile;
  bool isImageSelected = false;
  String newProfile;

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(
      source: source,
    );
    _imageFile = File(pickedFile.path);

    if (mounted) {
      setState(() {
        isImageSelected = true;
      });
    }
  }

  Future updatePhoto() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    if (_imageFile != null) {
      try {
        String filePath = 'profileImages/${DateTime.now()}.jpg';
        FirebaseStorage storage = FirebaseStorage.instance;
        UploadTask uploadTask =
            storage.ref().child(filePath).putFile(_imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        String url = await taskSnapshot.ref.getDownloadURL();

        setNewPhotoUrlOnly(url).then((value) {
          if (mounted) {
            setState(() {
              loading = false;
              newProfile = url;
            });
          }

          kGetStorage.remove('myProfilePicture');
          setState(() {});
          kGetStorage.write('myProfilePicture', url);

          singleButtonDialogue('Updated profile');
        });
      } catch (e) {
        print(e);
      }
    }
  }

  choosePhotoOptionsSheet() {
    Get.bottomSheet(
      Container(
        height: 155,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => pickImage(ImageSource.camera),
              child: Row(
                children: [
                  Icon(CupertinoIcons.camera_fill),
                  SizedBox(width: 10),
                  Text(
                    'Open camera',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => pickImage(ImageSource.gallery),
              child: Row(
                children: [
                  Icon(CupertinoIcons.photo_fill),
                  SizedBox(width: 10),
                  Text(
                    'Choose from gallery',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => Get.to(ViewPhotoScreen(kMyProfileImage)),
              child: Row(
                children: [
                  Icon(CupertinoIcons.eye_fill),
                  SizedBox(width: 10),
                  Text(
                    'View photo',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
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
        child: Scaffold(
          backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            backgroundColor: !Get.isDarkMode ? Colors.white : kDarkThemeBlack,
            title: Text(
              'Profile photo',
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
              !loading
                  ? Container(
                      margin: EdgeInsets.all(10),
                      width: 113,
                      child: signButton('Update', () => updatePhoto()),
                    )
                  : Container(),
            ],
          ),
          body: SingleChildScrollView(
            child: !loading
                ? Column(
                    children: [
                      SizedBox(height: 30),
                      _imageFile == null
                          ? Center(
                              child: GestureDetector(
                                onTap: () => choosePhotoOptionsSheet(),
                                child: Stack(
                                  children: [
                                    Hero(
                                      tag: kMyId,
                                      child: kMyProfileImage == null
                                          ? CircleAvatar(
                                              radius: 100,
                                              backgroundColor: Colors.grey[200],
                                              backgroundImage: AssetImage(
                                                  'assets/temporalPhoto.png'),
                                            )
                                          : CircleAvatar(
                                              radius: 100,
                                              backgroundColor: Colors.grey[200],
                                              backgroundImage: NetworkImage(
                                                  newProfile == null
                                                      ? kMyProfileImage
                                                      : newProfile),
                                            ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 80, left: 80),
                                      child: Icon(CupertinoIcons.camera_fill,
                                          size: 30),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Center(
                              child: GestureDetector(
                                onTap: () => choosePhotoOptionsSheet(),
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: FileImage(_imageFile),
                                ),
                              ),
                            ),
                    ],
                  )
                : Container(
                    height: 300,
                    child: Center(
                      child: myLoader(),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
