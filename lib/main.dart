import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_mask_detecting/camera_page.dart';
import 'package:tflite/tflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print(await Tflite.loadModel(
      model: "assets/model.tflite", labels: "assets/labels.txt"));
  runApp(MaskDetectingApp(
    cameras: await availableCameras(),
  ));
}

class MaskDetectingApp extends StatelessWidget {
  const MaskDetectingApp({
    @required List<CameraDescription> cameras,
  })  : assert(cameras != null),
        _cameras = cameras;

  final List<CameraDescription> _cameras;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face mask detecting',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: CameraPage(
        cameras: _cameras,
      ),
    );
  }
}
