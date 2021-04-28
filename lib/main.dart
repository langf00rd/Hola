import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reflex/models/constants.dart';
import 'package:reflex/views/home_init.dart';
import 'package:reflex/views/sign_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  kGetStorage.write('isDarkTheme', false);

  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(
  //     statusBarColor: kPrimaryColor,
  //   ),
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hola free messenger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),

      // theme: ThemeData(
      //   // themeData: ThemeData.dark(),
      //   brightness: Brightness.dark,
      //   fontFamily: 'primaryFont',
      // ),
      defaultTransition: Transition.rightToLeft,
      home: kGetStorage.read('myId') != null ? HomeInit() : SignScreen(),
    );
  }
}
