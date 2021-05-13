import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/services/services.dart';
import 'package:reflex/views/home_screen.dart';
import 'package:reflex/widgets/widget.dart';

class SetProfilePhotoScreen extends StatefulWidget {
  final String email;
  final String password;
  SetProfilePhotoScreen(this.email, this.password);

  @override
  _SetProfilePhotoScreenState createState() => _SetProfilePhotoScreenState();
}

class _SetProfilePhotoScreenState extends State<SetProfilePhotoScreen> {
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final picker = ImagePicker();
  File _imageFile;
  bool isImageSelected = false;
  bool loading = false;

  bool hasSelectedItem = false;
  var selectedMenuItems;
  String interestOne = '';
  String interestTwo = '';
  String interestThree = '';

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

  Future initSignUp() async {
    try {
      setState(() {
        loading = true;
      });

      var resultUser =
          await kFirebaseAuthInstance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      if (_imageFile != null) {
        String filePath = 'profileImages/${DateTime.now()}.jpg';
        FirebaseStorage storage = FirebaseStorage.instance;
        UploadTask uploadTask =
            storage.ref().child(filePath).putFile(_imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        String url = await taskSnapshot.ref.getDownloadURL();

        updateDisplayNamePhotoUrl(url, resultUser.user.uid);
      }

      if (_imageFile == null)
        setDataInFirestore(kTemporalImageUrl, resultUser.user.uid);
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }

      singleButtonDialogue('Couldn\'t set profile photo, try another image');
    }
  }

  void updateDisplayNamePhotoUrl(url, userId) async {
    try {
      await setNewAuthDisplaynamePhotoUrl(
        _nameController.text.trim(),
        url,
      );

      setDataInFirestore(url, userId);
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }

      singleButtonDialogue('error adding profile photo');
    }
  }

  Future setDataInFirestore(url, userId) async {
    try {
      insertSignupData(
        widget.email,
        _nameController.text.trim(),
        widget.password,
        userId,
        _aboutController.text.trim(),
        url,
        interestOne,
        interestTwo,
        interestThree,
        selectedMenuItems,
      );

      Get.offAll(loginUser());
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      print(e);
      singleButtonDialogue('Sorry, an error occured');
    }
  }

  Future getUserData(resultUser) async {
    try {
      DocumentReference usersRef = kUsersRef.doc(resultUser.uid);

      await usersRef.get().then((doc) async {
        String _interestOne = doc.data()['interestOne'].toString();
        String _interestTwo = doc.data()['interestTwo'].toString();
        String _interestThree = doc.data()['interestThree'].toString();
        String _profileImg = doc.data()['profileImage'];
        String _about = doc.data()['aboutUser'];

        await kGetStorage.write('myInterestOne', _interestOne);
        await kGetStorage.write('myInterestTwo', _interestTwo);
        await kGetStorage.write('myInterestThree', _interestThree);
        await kGetStorage.write('myProfilePicture', _profileImg);
        await kGetStorage.write('myName', resultUser.displayName);
        await kGetStorage.write('myId', resultUser.uid);
        await kGetStorage.write('myAbout', _about);

        Get.offAll(() => HomeScreen());
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }

      singleButtonDialogue('Sorry, an unexpected error occured');
    }
  }

  Future loginUser() async {
    try {
      setState(() {
        loading = true;
      });

      UserCredential result =
          await kFirebaseAuthInstance.signInWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      DocumentReference usersRef = kUsersRef.doc(result.user.uid);

      await usersRef.get().then(
        (doc) async {
          if (doc.exists) {
            getUserData(result.user);
          } else {
            setState(() {
              loading = false;
            });

            singleButtonDialogue("Sorry, this account does not exist");
          }
        },
      );
    } catch (e) {
      setState(() {
        loading = false;
      });

      if (e.code == 'user-not-found') {
        singleButtonDialogue(
          'Sorry, account not found',
        );
      } else if (e.code == 'wrong-password') {
        singleButtonDialogue(
          'Oops, Wrong password',
        );
      } else {
        singleButtonDialogue(
          'Sorry, an error occured',
        );
      }
    }
  }

  choosePhotoOptionsSheet() {
    Get.bottomSheet(
      Container(
        height: 130,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
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
                  Icon(CupertinoIcons.camera),
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
                  Icon(CupertinoIcons.photo),
                  SizedBox(width: 10),
                  Text(
                    'Choose from gallery',
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomSheet: Container(
          color: Colors.white,
          height: 60,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              !loading
                  ? signButton(
                      'Next',
                      () {
                        initSignUp();
                      },
                    )
                  : Container(),
            ],
          ),
        ),
        body: !loading
            ? Container(
                height: MediaQuery.of(context).size.height - 100,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Center(
                        child: Text(
                          'Set personal info.',
                          style: kFont23,
                        ),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () => choosePhotoOptionsSheet(),
                        child: Center(
                          child: Container(
                            height: 150,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[100],
                              backgroundImage: _imageFile != null
                                  ? FileImage(_imageFile)
                                  : AssetImage('./assets/temporalPhoto.png'),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                          child: Column(
                            children: [
                              inputField(
                                _nameController,
                                "What's your name?",
                                '',
                                TextInputType.name,
                              ),
                              SizedBox(height: 20),
                              inputField(
                                _aboutController,
                                'Describe yourself',
                                '',
                                TextInputType.multiline,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 30, top: 30),
                            child: Text(
                              'What are your interests?',
                              style: placeholderTextStyle,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: FindDropdown<String>.multiSelect(
                              items: kInterestsItems,
                              label: "",
                              onChanged: (items) {
                                if (mounted) {
                                  setState(() {
                                    selectedMenuItems = items;
                                    interestOne = items[1];
                                    interestTwo = items[0];
                                    interestThree = items[3];
                                    hasSelectedItem = true;
                                  });
                                }
                              },
                              selectedItems: ["Reading"],
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 50),
                    ],
                  ),
                ),
              )
            : Center(
                child: myLoader(),
              ),
      ),
    );
  }
}
