import 'dart:async';

import 'package:camera/camera.dart';
import 'package:driver/services/socket_io_wrapper.dart';
import 'package:flutter/material.dart';
// import 'package:image/image.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  late CameraController controller;
  late Timer timer;
  SocketIOWrapper sw = new SocketIOWrapper();

  // Future<Image> convertYUV420toImageColor(CameraImage image) async {
  //   try {
  //     final int width = image.width;
  //     final int height = image.height;
  //     final int uvRowStride = image.planes[1].bytesPerRow;
  //     final int? uvPixelStride = image.planes[1].bytesPerPixel;
  //
  //     print("uvRowStride: " + uvRowStride.toString());
  //     print("uvPixelStride: " + uvPixelStride.toString());
  //
  //     // imgLib -> Image package from https://pub.dartlang.org/packages/image
  //     var img = imglib.Image(width, height); // Create Image buffer
  //
  //     // Fill image buffer with plane[0] from YUV420_888
  //     for(int x=0; x < width; x++) {
  //       for(int y=0; y < height; y++) {
  //         final int uvIndex = uvPixelStride! * (x/2).floor() + uvRowStride*(y/2).floor();
  //         final int index = y * width + x;
  //
  //         final yp = image.planes[0].bytes[index];
  //         final up = image.planes[1].bytes[uvIndex];
  //         final vp = image.planes[2].bytes[uvIndex];
  //         // Calculate pixel color
  //         int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
  //         int g = (yp - up * 46549 / 131072 + 44 -vp * 93604 / 131072 + 91).round().clamp(0, 255);
  //         int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
  //         // color: 0x FF  FF  FF  FF
  //         //           A   B   G   R
  //         img.data[index] = (0xFF << 24) | (b << 16) | (g << 8) | r;
  //       }
  //     }
  //
  //     imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
  //     List<int> png = pngEncoder.encodeImage(img);
  //     muteYUVProcessing = false;
  //     return Image.memory(png);
  //   } catch (e) {
  //     print(">>>>>>>>>>>> ERROR:" + e.toString());
  //   }
  //   return null;
  // }
  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      print('ddddddddd');
      if (!mounted) {
        print("retuning");
        return;


      }
      // print('sdedfeas');
      // controller.startImageStream((image) => (CameraImage image){
      //   print('d');
      //   this.sw.sendData(image.planes);
      // });
      setState(() {});

      const oneSec = Duration(milliseconds: 100);
      timer = Timer.periodic(oneSec, (Timer t) => takePicture());
    });
  }

  @override
  void dispose() {
    controller.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: Stack(
        children: [
          CameraPreview(controller),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0, right: 30.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20)),
                  onPressed: () => takePicture(),
                  child: const Text('Take Picture'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> takePicture() async {
    // print("ddddddddd");
    if (!controller.value.isInitialized || controller.value.isTakingPicture) {
      return "";
    }

    try {
      XFile file = await controller.takePicture();
      file.readAsBytes().then((bytes) => {


          this.sw.sendData(bytes)
      });
      return file.path;
    } on CameraException catch (e) {
      print('Error: ${e.code}\nError Message: ${e.description}');
      return "";
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (!controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(controller.description);
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    await controller.dispose();
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print('Error: ${e.code}\nError Message: ${e.description}');
    }

    if (mounted) {
      setState(() {});
    }
  }
}
