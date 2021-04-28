import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reflex/models/constants.dart';

Future insertSignupData(
  String _email,
  String _username,
  String _password,
  String _uid,
  String _aboutUser,
  String _profileImgUrl,
  String _interestOne,
  String _interestTwo,
  final _selectedMenuItems,
) async {
  await kUsersRef.doc(_uid).set({
    'email': _email,
    'name': _username,
    'password': _password,
    'userId': _uid,
    'aboutUser': _aboutUser,
    'profileImage': _profileImgUrl,
    'interestOne': _interestOne,
    'interestTwo': _interestTwo,
    'interests': _selectedMenuItems,
    'joinDate': DateTime.now(),
    'onlineStatus': 'Online',
  });
}

Future setNewAuthDisplaynamePhotoUrl(username, imageUrl) async {
  kFirebaseAuthInstance.authStateChanges().listen((User user) {
    if (user == null) {
      print('no user authed');
      return;
    } else {
      user.updateProfile(displayName: username);
      user.updateProfile(photoURL: imageUrl);
    }
  });
}

getRoomId(personId) {
  String _myId = kGetStorage.read('myId').toString();
  String _personId = personId.toString();

  if (_myId.compareTo(_personId) == 1) {
    return _myId + _personId;
  }

  return _personId + _myId;
}

Future createRoom(roomId, personId) async {
  List _roomUsers = [
    personId,
    kMyId,
  ];

  await kChatRoomsRef.doc(roomId).set(
    {
      'roomID': roomId,
      'roomUsers': _roomUsers,
    },
  );
}

Future sendMessage(_roomId, _textControllerText) async {
  await kChatRoomsRef.doc(_roomId).collection('RoomMessages').add({
    'messageText': _textControllerText,
    'messageImage': null,
    'messageType': 'textMessage',
    'sendTime': DateTime.now(),
    'sender': kMyName,
    'senderId': kMyId,
    'senderProfileImage': kMyProfileImage,
  });
}

Future sendPhoto(_photoDescriptionController, _imageUrl, _roomId) async {
  await kChatRoomsRef.doc(_roomId).collection('RoomMessages').add({
    'messageText': _photoDescriptionController,
    'messageImage': _imageUrl,
    'messageType': 'photoMessage',
    'sendTime': DateTime.now(),
    'sender': kMyName,
    'senderId': kMyId,
    'senderProfileImage': kMyProfileImage,
    'isImagePost': true,
  });
}

createClub(
  _clubProfileImage,
  _clubName,
  _isClubPrivate,
  _clubCategory,
  _clubDescription,
) async {
  final clubDoc = kClubsRef.doc();
  List _clubMembers = [
    kMyId,
  ];

  await clubDoc.set({
    'clubId': clubDoc.id,
    'clubProfileImage': _clubProfileImage,
    'clubName': _clubName,
    'isClubPrivate': _isClubPrivate,
    'clubCategory': _clubCategory,
    'clubAdminName': kMyName,
    'clubAdminId': kMyId,
    'clubCreated': DateTime.now(),
    'clubMembers': _clubMembers,
    'clubDescription': _clubDescription,
  }).then(
    (value) {
      initClubMembers(clubDoc.id);
      // Get.off(() => ClubInfoScreen(clubDoc.id));
    },
  );
}

initClubMembers(String _clubId) {
  kClubsRef.doc(_clubId).collection('Members').doc(kMyId).set({
    'joinState': 'Joined',
    'rank': 'Admin',
  });
}

Future addMeToClub(_clubAdminId, _clubId, _clubName) async {
  await kClubsRef.doc(_clubId).collection('Members').doc(kMyId).set({
    'joinState': 'Joined',
    'joinDate': DateTime.now(),
  }).then((value) => updateClubMembers(_clubAdminId, _clubId, _clubName));
}

Future updateClubMembers(
  _clubAdminId,
  _clubId,
  _clubName,
) async {
  final clubDoc = kClubsRef.doc(_clubId);
  List _clubMembers = [
    kMyId,
  ];

  clubDoc.update({'clubMembers': FieldValue.arrayUnion(_clubMembers)}).then(
    (value) {
      // sendAdminJoinAlert(_clubAdminId, _clubId, _clubName);
    },
  );
}
