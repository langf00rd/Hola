import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/services/services.dart';
import 'package:reflex/widgets/widget.dart';

class SharePhotoScreen extends StatefulWidget {
  final String _roomId;
  final String _name;
  final bool _isClub;

  SharePhotoScreen(
    this._roomId,
    this._name,
    this._isClub,
  );

  @override
  _SharePhotoScreenState createState() => _SharePhotoScreenState();
}

class _SharePhotoScreenState extends State<SharePhotoScreen> {
  final picker = ImagePicker();
  File _imageFile;
  bool isImageSelected = false;
  bool loading = false;
  TextEditingController _photoDescriptionController = TextEditingController();

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

  Future uploadImage() async {
    try {
      if (_imageFile != null) {
        if (mounted) {
          setState(() {
            loading = true;
          });
        }

        String filePath = 'imagePosts/${DateTime.now()}.jpg';

        FirebaseStorage storage = FirebaseStorage.instance;

        UploadTask uploadTask =
            storage.ref().child(filePath).putFile(_imageFile);

        TaskSnapshot taskSnapshot = await uploadTask;

        String url = await taskSnapshot.ref.getDownloadURL();

        await sendPhoto(
          _photoDescriptionController.text,
          url,
          widget._roomId,
          widget._isClub,
        );

        if (_photoDescriptionController.text.isEmpty)
          widget._isClub
              ? await kClubChatRoomsRef.doc(widget._roomId).update({
                  'lastRoomMessageTime': DateTime.now(),
                  'lastRoomMessage': 'Sent a photo',
                  'lastRoomMessageSenderId': kMyId,
                })
              : await kChatRoomsRef.doc(widget._roomId).update({
                  'lastRoomMessageTime': DateTime.now(),
                  'lastRoomMessage': 'Sent a photo',
                  'lastRoomMessageSenderId': kMyId,
                });

        if (_photoDescriptionController.text.isNotEmpty)
          widget._isClub
              ? await kClubChatRoomsRef.doc(widget._roomId).update({
                  'lastRoomMessageTime': DateTime.now(),
                  'lastRoomMessage': _photoDescriptionController.text,
                  'lastRoomMessageSenderId': kMyId,
                })
              : await kChatRoomsRef.doc(widget._roomId).update({
                  'lastRoomMessageTime': DateTime.now(),
                  'lastRoomMessage': _photoDescriptionController.text,
                  'lastRoomMessageSenderId': kMyId,
                });

        Get.back();
      }

      if (_imageFile == null) singleButtonDialogue('Please choose a photo');
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }

      print(e);

      singleButtonDialogue('can not send');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0.3,
          title: Text(
            widget._name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                CupertinoIcons.photo,
                color: Colors.white,
              ),
              onPressed: () => pickImage(ImageSource.gallery),
            ),
            IconButton(
              icon: Icon(
                LineIcons.camera,
                color: Colors.white,
              ),
              onPressed: () => pickImage(ImageSource.camera),
            ),
            _imageFile != null && !loading
                ? Container(
                    height: 60,
                    padding: EdgeInsets.all(10),
                    child: MaterialButton(
                      elevation: 0,
                      color: kPrimaryColor,
                      onPressed: () {
                        uploadImage();
                      },
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: kPrimaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'Share photo',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        bottomNavigationBar: !loading
            ? BottomAppBar(
                color: Colors.transparent,
                elevation: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: 40,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            controller: _photoDescriptionController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                CupertinoIcons.pen,
                                color: Colors.white,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(left: 15),
                              hintText: "Add photo caption...",
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink(),
        body: !loading
            ? Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _imageFile != null
                          ? Expanded(
                              flex: 5,
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.file(
                                    _imageFile,
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              flex: 5,
                              child: Container(
                                color: Colors.black,
                              ),
                            ),
                    ],
                  ),
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height - 180,
                child: Center(
                  child: myLoader(),
                ),
              ),
      ),
    );
  }
}
