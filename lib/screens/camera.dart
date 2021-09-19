import 'dart:async';

import 'package:camera/camera.dart';
import 'package:driver/services/socket_io_wrapper.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[1], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});

      const oneSec = Duration(milliseconds: 50);
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
    if (!controller.value.isInitialized || controller.value.isTakingPicture) {
      return "";
    }

    try {
      XFile file = await controller.takePicture();
      file.readAsBytes().then((bytes) => {this.sw.sendData(bytes)});
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
