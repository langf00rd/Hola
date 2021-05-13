import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/models/models.dart';
import 'package:reflex/views/home_screen.dart';
import 'package:reflex/views/sign_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _changeTheme() {
    print(kGetStorage.read('myId'));
    print('checking uid');

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
    return AppBuilder(builder: (context) {
      return GetMaterialApp(
        title: 'Space messenger',
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.rightToLeft,
        home: kGetStorage.read('myId') != null ? HomeScreen() : SignScreen(),
      );
    });
  }
}
