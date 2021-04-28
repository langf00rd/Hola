import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reflex/widgets/widget.dart';
import 'package:reflex/models/constants.dart';

class ClubChatsScreen extends StatefulWidget {
  @override
  _ClubChatsScreenState createState() => _ClubChatsScreenState();
}

class _ClubChatsScreenState extends State<ClubChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Club chats', style: kFont23),
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(kMyProfileImage),
            ),
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            messageTile('Anime & Manga 101', kMyProfileImage, kMyId),
            messageTile('Pharoah of movies', kMyProfileImage, kMyId),
            messageTile('Audio hub', kMyProfileImage, kMyId),
            messageTile('HOT Stage', kMyProfileImage, kMyId),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
