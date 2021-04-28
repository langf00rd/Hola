import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:reflex/models/constants.dart';

class CustomizeScreen extends StatefulWidget {
  @override
  _CustomizeScreenState createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  // void changeColor(Color color) {
  //   setState(() => pickerColor = color);
  // }

  // void colorPickerDialog() {
  //   Get.dialog(
  //     AlertDialog(
  //       title: const Text('Pick a color!'),
  //       content: SingleChildScrollView(
  //         child: ColorPicker(
  //           pickerColor: pickerColor,
  //           onColorChanged: changeColor,
  //           showLabel: true,
  //           pickerAreaHeightPercent: 0.8,
  //         ),
  //         // Use Material color picker:
  //         //
  //         // child: MaterialPicker(
  //         //   pickerColor: pickerColor,
  //         //   onColorChanged: changeColor,
  //         //   showLabel: true, // only on portrait mode
  //         // ),
  //         //
  //         // Use Block color picker:
  //         //
  //         // child: BlockPicker(
  //         //   pickerColor: currentColor,
  //         //   onColorChanged: changeColor,
  //         // ),
  //         //
  //         // child: MultipleChoiceBlockPicker(
  //         //   pickerColors: currentColors,
  //         //   onColorsChanged: changeColors,
  //         // ),
  //       ),
  //       actions: <Widget>[
  //         FlatButton(
  //           child: const Text('Got it'),
  //           onPressed: () {
  //             setState(() => currentColor = pickerColor);
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? kDarkThemeBlack : Colors.white,
        toolbarHeight: 55,
        elevation: 0.7,
        title: Text(
          'Customize interface',
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(
            // fontSize: 16,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            LineIcons.arrowLeft,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.check_mark,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(),
    );
  }
}
