import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:reflex/models/constants.dart';
import 'package:http/http.dart' as http;
import 'package:reflex/views/club_info.dart';

Future insertSignupData(
  String _email,
  String _username,
  String _password,
  String _uid,
  String _aboutUser,
  String _profileImgUrl,
  String _interestOne,
  String _interestTwo,
  String _interestThree,
  final _selectedMenuItems,
) async {
  List _chatHistoryMembers = [
    _uid,
  ];

  await kUsersRef.doc(_uid).set({
    'email': _email,
    'name': _username,
    'password': _password,
    'userId': _uid,
    'aboutUser': _aboutUser,
    'profileImage': _profileImgUrl,
    'interestOne': _interestOne,
    'interestTwo': _interestTwo,
    'interestThree': _interestThree,
    'interests': _selectedMenuItems,
    'joinDate': DateTime.now().toUtc(),
    'onlineStatus': 'Online',
    'chatHistoryMembers': _chatHistoryMembers,
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

  //initialize room members /users
  await kChatRoomsRef
      .doc(roomId)
      .set({'roomID': roomId, 'roomUsers': _roomUsers});

  //set notification token and lastRoomVisitTime in RoomLogs collection
  await kChatRoomsRef.doc(roomId).collection('RoomLogs').doc(kMyId).set({
    'token': kMyNotificationToken,
    'roomVisitTime': DateTime.now().toUtc(),
  });

  await kChatRoomsRef.doc(roomId).collection('RoomLogs').doc(personId).set({
    'token': '',
    'roomVisitTime': DateTime.now().toUtc(),
  });

  //update room information
  await kChatRoomsRef.doc(roomId).update({
    'lastMessageTime': DateTime.now().toUtc(),
    'lastRoomMessage': 'You are now connected',
    'lastRoomMessageSenderId': '',
  });

  //update chatHistoryMembers field for both users

  final userDoc = kUsersRef.doc(personId);
  final myDoc = kUsersRef.doc(kMyId);

  await userDoc.update({
    'chatHistoryMembers': FieldValue.arrayUnion(_roomUsers),
  });

  await myDoc.update({
    'chatHistoryMembers': FieldValue.arrayUnion(_roomUsers),
  });
}

Future updateLastRoomVisitTime(String _roomId) async {
  try {
    await kChatRoomsRef.doc(_roomId).collection('RoomLogs').doc(kMyId).update({
      'token': kMyNotificationToken,
      'roomVisitTime': DateTime.now().toUtc(),
    });
  } catch (e) {
    print(e);
  }
}

Future updateClubLastRoomVisitTime(String _roomId) async {
  try {
    await kClubChatRoomsRef
        .doc(_roomId)
        .collection('RoomLogs')
        .doc(kMyId)
        .update({
      'roomVisitTime': DateTime.now().toUtc(),
    });
  } catch (e) {
    print(e);
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}

removeAllStorageVariables() async {
  await kGetStorage.erase();
}

Future updateAbout(String _aboutText) async {
  try {
    await kUsersRef.doc(kMyId).update({
      'aboutUser': _aboutText,
    });
  } catch (e) {
    print(e);
  }
}

Future setNewPhotoUrlOnly(imageUrl) async {
  try {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        return;
      } else {
        user.updateProfile(photoURL: imageUrl);
      }
    });

    await kUsersRef.doc(kMyId).update({
      'profileImage': imageUrl,
    });
  } catch (e) {
    print(e);
  }
}

Future updateRoomToken(String _roomId) async {
  await kChatRoomsRef
      .doc(_roomId)
      .collection('RoomLogs')
      .doc(kMyId)
      .update({'token': kMyNotificationToken});
}

Future setRoomToken(String _roomId) async {
  await kChatRoomsRef
      .doc(_roomId)
      .collection('RoomLogs')
      .doc(kMyId)
      .set({'token': kMyNotificationToken});
}

//send private message
Future sendMessage(_roomId, _personId, _textControllerText) async {
  await kChatRoomsRef.doc(_roomId).collection('RoomMessages').add({
    'messageText': _textControllerText,
    'messageImage': null,
    'messageType': 'textMessage',
    'sendTime': DateTime.now().toUtc(),
    'sender': kMyName,
    'senderId': kMyId,
    'senderProfileImage': kMyProfileImage,
  });

  String _url = "https://fcm.googleapis.com/fcm/send";

  final key = Key.fromLength(32);
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));

  var plainMessageText = _textControllerText;
  final decrypted = encrypter.decrypt64(plainMessageText, iv: iv);

  await kUsersRef.doc(_personId).get().then((doc) {
    http.post(
      Uri.parse(_url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAK-eLj9E:APA91bGsm3XNlxscMQ7Ncm1FW-ARHjIEPXD3t-UnGPn2rtVzD7WPeNiENjLzvKSFJij8bRKkd1nmUD2nLZdYO_Gi6kSK5QqmJoTF__mI-4iEsyZtuWsPYnE5pxvuz9jwUmy2U3T_QQxO',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': decrypted,
            'title': 'New message from $kMyName',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'body': decrypted,
            'title': 'New message from $kMyName',
          },
          'to': doc.data()['token'].toString(),
        },
      ),
    );
  });

  await kChatRoomsRef.doc(_roomId).update({
    'lastMessageTime': DateTime.now().toUtc(),
    'lastRoomMessage': decrypted,
    'lastRoomMessageSenderId': kMyId,
  });
}

Future sendClubMessage(_roomId, _textControllerText) async {
  await kClubChatRoomsRef.doc(_roomId).collection('RoomMessages').add({
    'messageText': _textControllerText,
    'messageImage': null,
    'messageType': 'textMessage',
    'sendTime': DateTime.now().toUtc(),
    'sender': kMyName,
    'senderId': kMyId,
    'senderProfileImage': kMyProfileImage,
  });

  await kClubChatRoomsRef.doc(_roomId).update({
    'lastRoomMessageTime': DateTime.now().toUtc(),
    'lastRoomMessage': _textControllerText,
    'lastRoomMessageSenderId': kMyId,
  });
}

Future sendPhoto(
    _photoDescriptionController, _imageUrl, _roomId, _isClub) async {
  final plainText = _photoDescriptionController;

  final key = Key.fromLength(32);
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(plainText, iv: iv);

  _isClub
      ? await kClubChatRoomsRef.doc(_roomId).collection('RoomMessages').add({
          'messageText': _photoDescriptionController,
          'messageImage': _imageUrl,
          'messageType': 'photoMessage',
          'sendTime': DateTime.now().toUtc(),
          'sender': kMyName,
          'senderId': kMyId,
          'senderProfileImage': kMyProfileImage,
          'isImagePost': true,
        })
      : await kChatRoomsRef.doc(_roomId).collection('RoomMessages').add({
          'messageText': _photoDescriptionController,
          'messageImage': _imageUrl,
          'messageType': 'photoMessage',
          'sendTime': DateTime.now().toUtc(),
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
    'clubCreated': DateTime.now().toUtc(),
    'clubMembers': _clubMembers,
    'clubDescription': _clubDescription,
  });

  initClubMembers(clubDoc.id);

  List _clubChatRoomMembers = [
    kMyId,
  ];

  await kClubChatRoomsRef.doc(clubDoc.id).set({
    'lastRoomMessageTime': DateTime.now().toUtc(),
    'lastRoomMessage': 'Group created',
    'lastRoomMessageSenderId': kMyId,
    'clubRoomMembers': _clubChatRoomMembers,
    'clubName': _clubName,
    'clubRoomProfileImage': _clubProfileImage,
    'roomId': clubDoc.id,
  });

  await kClubChatRoomsRef
      .doc(clubDoc.id)
      .collection('RoomLogs')
      .doc(kMyId)
      .set({
    'token': kMyNotificationToken,
    'roomVisitTime': DateTime.now().toUtc()
  }).then(
    (value) => Get.off(
      () => ClubInfoScreen(
        clubDoc.id,
        _clubProfileImage,
        _clubName,
        _clubDescription,
        _clubCategory,
      ),
    ),
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
    'joinDate': DateTime.now().toUtc(),
  }).then((value) => updateClubMembers(_clubAdminId, _clubId, _clubName));
}

Future leaveClub(_clubId) async {
  await kClubsRef.doc(_clubId).collection('Members').doc(kMyId).delete();

  final clubDoc = kClubsRef.doc(_clubId);
  List _clubMembers = [
    kMyId,
  ];

  clubDoc.update({'clubMembers': FieldValue.arrayRemove(_clubMembers)});
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

  clubDoc.update({'clubMembers': FieldValue.arrayUnion(_clubMembers)});
}

void registerNotification() async {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  await _messaging.getToken().then((token) {
    print('Token: $token');
    kGetStorage.write('myNotificationToken', token);
  }).catchError((e) {
    print(e);
  });

  _messaging.onTokenRefresh.listen((newToken) {
    print('New Token: $newToken');
    kGetStorage.write('myNotificationToken', newToken);
  });

  String fcmToken = await _messaging.getToken();

  if (fcmToken != null) {
    kUsersRef.doc(kMyId).update({
      'token': fcmToken,
      'platform': Platform.operatingSystem,
    });
  }
}
