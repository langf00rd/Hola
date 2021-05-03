import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/services/services.dart';
import 'package:reflex/widgets/widget.dart';

class UpdateAbout extends StatefulWidget {
  @override
  _UpdateAboutState createState() => _UpdateAboutState();
}

class _UpdateAboutState extends State<UpdateAbout> {
  TextEditingController _aboutController = TextEditingController();
  bool loading = false;

  Widget suggestedAbout(String _text) {
    return GestureDetector(
      onTap: () {
        _aboutController.text = _text;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 17),
        child: Text(
          _text,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _aboutController.text = kMyAbout;
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
              'About',
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
                      child: signButton('Update', () {
                        if (_aboutController.text.isNotEmpty) {
                          if (mounted) {
                            setState(() {
                              loading = true;
                            });
                          }
                          updateAbout(_aboutController.text.trim())
                              .then((value) {
                            if (mounted) {
                              setState(() {
                                loading = false;
                              });
                            }

                            kGetStorage.remove('myAbout');
                            setState(() {});
                            kGetStorage.write(
                                'myAbout', _aboutController.text.trim());

                            singleButtonDialogue('Updated');
                          });
                        }
                      }),
                    )
                  : Container(),
            ],
          ),
          body: !loading
              ? Container(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text('Describe yourself'),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                          child: TextFormField(
                            controller: _aboutController,
                            maxLines: null,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        suggestedAbout('Solving global warming 😎'),
                        suggestedAbout('Available ❤️'),
                        suggestedAbout('Let\'s chat 🤟🏻'),
                        suggestedAbout('Changing the world ❤️❤️❤️'),
                        suggestedAbout('I am online'),
                        suggestedAbout('Watching a movie 😎'),
                      ],
                    ),
                  ),
                )
              : Center(child: myLoader()),
        ),
      ),
    );
  }
}
