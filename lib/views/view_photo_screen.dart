import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewPhotoScreen extends StatefulWidget {
  final String _src;
  ViewPhotoScreen(this._src);

  @override
  _ViewPhotoScreenState createState() => _ViewPhotoScreenState();
}

class _ViewPhotoScreenState extends State<ViewPhotoScreen> {
  // _requestPermission() async {
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.storage,
  //   ].request();

  //   final info = statuses[Permission.storage].toString();
  //   print(info);
  //   singleButtonDialogue(info);
  // }

  downloadImage() async {
    // try {
    //   var response = await Dio().get(
    //       "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg",
    //       options: Options(responseType: ResponseType.bytes));
    //   final result = await ImageGallerySaver.saveImage(
    //       Uint8List.fromList(response.data),
    //       quality: 60,
    //       name: "hello");
    //   print(result);
    //   singleButtonDialogue("$result");
    // } catch (e) {
    //   singleButtonDialogue(e.toString());
    // }

    // try {
    //   // Saved with this method.
    //   var imageId = await ImageDownloader.downloadImage(_src);
    //   if (imageId == null) {
    //     return;
    //   }

    //   // Below is a method of obtaining saved image information.
    //   var fileName = await ImageDownloader.findName(imageId);
    //   var path = await ImageDownloader.findPath(imageId);
    //   // var size = await ImageDownloader.findByteSize(imageId);
    //   // var mimeType = await ImageDownloader.findMimeType(imageId);

    //   print(fileName);
    //   print(path);
    //   // print(size);
    //   // print(mimeType);
    // } on PlatformException catch (error) {
    //   print(error);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.download_sharp, color: Colors.white),
            onPressed: () {
              downloadImage();
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        child: Center(
          child: Image.network(widget._src),
        ),
      ),
    );
  }
}
