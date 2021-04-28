import 'package:find_dropdown/find_dropdown.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:reflex/models/constants.dart';
import 'package:reflex/services/services.dart';
import 'package:reflex/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class StartClub extends StatefulWidget {
  @override
  _StartClubState createState() => _StartClubState();
}

class _StartClubState extends State<StartClub> {
  TextEditingController _clubNameController = TextEditingController();
  TextEditingController _clubDescriptionController = TextEditingController();

  final picker = ImagePicker();
  File _imageFile;
  bool loading = false;
  bool isClubPrivate = false;
  String clubCategory = 'Science and tech';

  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(
      source: source,
      imageQuality: 25,
    );
    _imageFile = File(pickedFile.path);
    setState(() {});
  }

  Future setClubProfileImage() async {
    try {
      setState(() {
        loading = true;
      });

      if (_imageFile != null) {
        String filePath = 'clubProfileImages/${DateTime.now()}.jpg';

        FirebaseStorage storage = FirebaseStorage.instance;

        UploadTask uploadTask =
            storage.ref().child(filePath).putFile(_imageFile);

        TaskSnapshot taskSnapshot = await uploadTask;

        String url = await taskSnapshot.ref.getDownloadURL();

        createClub(
          url,
          _clubNameController.text.trim().capitalize,
          isClubPrivate,
          clubCategory,
          _clubDescriptionController.text.trim(),
        );
      } else {
        setState(() {
          loading = false;
        });
        singleButtonDialogue('Set club profile photo');
      }
    } catch (e) {
      setState(() {
        loading = false;
      });

      singleButtonDialogue('An error occured');
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _clubDescriptionController.dispose();
    _clubNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Start a club',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: !loading
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: kPrimaryColor,
                ),
                onPressed: () => Get.back())
            : SizedBox.shrink(),
        actions: [
          !loading
              ? GestureDetector(
                  onTap: () {
                    if (_clubNameController.text.length > 1 &&
                        _clubNameController.text.trim() != '' &&
                        _clubDescriptionController.text.length > 1 &&
                        _clubDescriptionController.text.trim() != '')
                      setClubProfileImage();
                    else
                      singleButtonDialogue('Set club name');
                  },
                  child: Container(
                    margin: EdgeInsets.all(11),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              !loading
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 20),
                            IconButton(
                              onPressed: () => pickImage(ImageSource.camera),
                              icon: Icon(CupertinoIcons.camera),
                            ),
                            Container(
                              height: 200,
                              width: 200,
                              padding: EdgeInsets.all(20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: _imageFile != null
                                    ? Image.file(
                                        _imageFile,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        kTemporalImageUrl,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => pickImage(ImageSource.gallery),
                              icon: Icon(CupertinoIcons.photo),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 20),
                          child: normalInputField(
                            _clubNameController,
                            'Name your club',
                            'This will be visible to everyone',
                            TextInputType.name,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 20),
                          child: normalInputField(
                            _clubDescriptionController,
                            'Club description',
                            '',
                            TextInputType.name,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text('Set club as private'),
                              Container(
                                width: 60,
                                child: Switch(
                                  activeColor: kPrimaryColor,
                                  activeTrackColor: Colors.grey[300],
                                  inactiveThumbColor: Colors.grey[200],
                                  inactiveTrackColor: Colors.grey[500],
                                  onChanged: (bool value) {
                                    setState(() {
                                      isClubPrivate = !isClubPrivate;
                                    });
                                  },
                                  value: isClubPrivate,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Club category'),
                              SizedBox(height: 5),
                              FindDropdown(
                                items: kClubCategories,
                                label: "",
                                onChanged: (item) {
                                  setState(() {
                                    clubCategory = item;
                                  });
                                },
                                selectedItem: "Science and tech",
                              ),
                            ],
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
            ],
          ),
        ),
      ),
    );
  }
}
