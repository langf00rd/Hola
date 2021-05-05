import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:reflex/models/constants.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CustomizeScreen extends StatefulWidget {
  @override
  _CustomizeScreenState createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  Color pickerColor = Color(0xff443a49);
  Color currentColor = kPrimaryColor;

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void colorPickerDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
          // Use Material color picker:
          //
          // child: MaterialPicker(
          //   pickerColor: pickerColor,
          //   onColorChanged: changeColor,
          //   showLabel: true, // only on portrait mode
          // ),
          //
          // Use Block color picker:
          //
          // child: BlockPicker(
          //   pickerColor: currentColor,
          //   onColorChanged: changeColor,
          // ),
          //
          // child: MultipleChoiceBlockPicker(
          //   pickerColors: currentColors,
          //   onColorsChanged: changeColors,
          // ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();

              kGetStorage.remove('myThemeColor');
              kGetStorage.write('myThemeColor', pickerColor);
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print(kGetStorage.read('myThemeColor'));

    if (kGetStorage.read('myThemeColor') == null) {
      kGetStorage.write('myThemeColor', kPrimaryColor);
    }
  }

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
      body: Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: GestureDetector(
                onTap: () => colorPickerDialog(),
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: currentColor,
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: GestureDetector(
                onTap: () => colorPickerDialog(),
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.grey,
                  child: Text('Choose app theme color'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
