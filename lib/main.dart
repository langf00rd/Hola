import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/views/home_screen.dart';
import 'package:reflex/views/sign_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(
  //     statusBarColor: Colors.black,
  //   ),
  // );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _changeTheme() {
    if (kGetStorage.read('isDarkTheme') == null) {
      kGetStorage.write('isDarkTheme', false);
      Get.changeTheme(ThemeData.light());
    }

    if (kGetStorage.read('isDarkTheme') != null) {
      if (kGetStorage.read('isDarkTheme')) {
        Get.changeTheme(ThemeData.dark());
      }
      if (!kGetStorage.read('isDarkTheme')) {
        Get.changeTheme(ThemeData.light());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _changeTheme();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hola free messenger',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.rightToLeft,
      home: kGetStorage.read('myId') != null ? HomeScreen() : SignScreen(),
    );
  }
}

// class PushMessagingExample extends StatefulWidget {
//   @override
//   _PushMessagingExampleState createState() => _PushMessagingExampleState();
// }

// class _PushMessagingExampleState extends State<PushMessagingExample> {
//   String _homeScreenText = "Waiting for token...";
//   String _messageText = "Waiting for message...";
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   @override
//   void initState() {
//     super.initState();

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       setState(() {
//         _messageText = "Push Messaging message: $message";
//       });
//       print("onMessage: $message");

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           content: ListTile(
//             title: Text(message.toString()),
//             subtitle: Text(message.toString()),
//           ),
//           actions: <Widget>[
//             MaterialButton(
//               child: Text('Ok'),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ],
//         ),
//       );
//     });

//     // _firebaseMessaging.configure(
//     //   onMessage: (Map<String, dynamic> message) async {
//     //     setState(() {
//     //       _messageText = "Push Messaging message: $message";
//     //     });
//     //     print("onMessage: $message");
//     //   },
//     //   onLaunch: (Map<String, dynamic> message) async {
//     //     setState(() {
//     //       _messageText = "Push Messaging message: $message";
//     //     });
//     //     print("onLaunch: $message");
//     //   },
//     //   onResume: (Map<String, dynamic> message) async {
//     //     setState(() {
//     //       _messageText = "Push Messaging message: $message";
//     //     });
//     //     print("onResume: $message");
//     //   },
//     // );
//     // _firebaseMessaging.requestNotificationPermissions(
//     //     const IosNotificationSettings(sound: true, badge: true, alert: true));
//     // _firebaseMessaging.onIosSettingsRegistered
//     //     .listen((IosNotificationSettings settings) {
//     //   print("Settings registered: $settings");
//     // });

//     _firebaseMessaging.getToken().then((String token) {
//       assert(token != null);
//       setState(() {
//         _homeScreenText = "Push Messaging token: $token";
//       });
//       print(_homeScreenText);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Push Messaging Demo'),
//         ),
//         body: Column(
//           children: <Widget>[
//             Center(
//               child: Text(_homeScreenText),
//             ),
//             Row(children: <Widget>[
//               Expanded(
//                 child: Text(_messageText),
//               ),
//             ])
//           ],
//         ),
//       ),
//     );
//   }
// }
