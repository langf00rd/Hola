import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/views/home_init.dart';
import 'package:reflex/views/set_profile_photo_screen.dart';
import 'package:reflex/widgets/widget.dart';

class SignScreen extends StatefulWidget {
  @override
  _SignScreenState createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool loading = false;

  Future getUserData(resultUser) async {
    try {
      DocumentReference usersRef = kUsersRef.doc(resultUser.uid);

      await usersRef.get().then((doc) async {
        String _interestOne = doc.data()['interestOne'].toString();
        String _interestTwo = doc.data()['interestTwo'].toString();
        String _profileImg = doc.data()['profileImage'];

        kGetStorage.write('myInterestOne', _interestOne);
        kGetStorage.write('myInterestTwo', _interestTwo);
        kGetStorage.write('myProfilePicture', _profileImg);
        kGetStorage.write('myName', resultUser.displayName);
        kGetStorage.write('myId', resultUser.uid);

        Get.offAll(() => HomeInit());
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }

      print(e);

      singleButtonDialogue('Sorry, an unexpected error occured');
    }
  }

  Future loginUser() async {
    try {
      if (mounted) {
        setState(() {
          loading = true;
        });
      }

      UserCredential result =
          await kFirebaseAuthInstance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      DocumentReference usersRef = kUsersRef.doc(result.user.uid);

      await usersRef.get().then(
        (doc) async {
          if (doc.exists) getUserData(result.user);
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }

      if (e.code == 'user-not-found') {
        Get.off(
          SetProfilePhotoScreen(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          ),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor,
      child: SafeArea(
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
                    ? signButton('Done', () {
                        if (_passwordController.text.length > 1 &&
                            _emailController.text.length > 1)
                          loginUser();
                        else
                          singleButtonDialogue('Please input your info.');
                      })
                    : Container(),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: !loading
                  ? Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: kPrimaryColor,
                            child: Center(
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey[100],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(30),
                            color: Colors.white,
                            child: Column(
                              children: [
                                inputField(
                                  _emailController,
                                  'Your e-mail',
                                  'An e-mail is required to join the network',
                                  TextInputType.name,
                                ),
                                SizedBox(height: 40),
                                inputField(
                                  _passwordController,
                                  'Password',
                                  '',
                                  TextInputType.text,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: myLoader(),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
