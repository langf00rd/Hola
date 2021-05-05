import 'package:extended_image/extended_image.dart';
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
        extendBodyBehindAppBar: true,
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
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: ExtendedImage.network(
              widget._src,
              fit: BoxFit.contain,
              enableLoadState: false,
              mode: ExtendedImageMode.gesture,
              initGestureConfigHandler: (state) {
                return GestureConfig(
                  minScale: 0.9,
                  animationMinScale: 0.7,
                  maxScale: 3.0,
                  animationMaxScale: 3.5,
                  speed: 1.0,
                  inertialSpeed: 100.0,
                  initialScale: 1.0,
                  inPageView: true,
                  initialAlignment: InitialAlignment.center,
                );
              },
            ),
          ),
        )
        // body: ExtendedImage.network(
        //   widget._src,
        //   fit: BoxFit.contain,
        //   mode: ExtendedImageMode.editor,
        //   // extendedImageEditorKey: editorKey,
        //   initEditorConfigHandler: (state) {
        //     return EditorConfig(
        //       maxScale: 8.0,
        //       cropRectPadding: EdgeInsets.all(20.0),
        //       hitTestSize: 20.0,
        //       cropAspectRatio: CropAspectRatios.original,
        //     );
        //   },
        // ),
        );
  }
}
