import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_face_mask_detecting/overlay.dart' as ol;
import 'package:tflite/tflite.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    @required List<CameraDescription> cameras,
  })  : assert(cameras != null),
        _cameras = cameras;

  final List<CameraDescription> _cameras;

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController _controller;
  bool _isDetecting = false;

  bool _rear = false;

  List<dynamic> _recognitions;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        _setupCamera();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupCamera();
  }

  void _setupCamera() {
    if (widget._cameras == null || widget._cameras.isEmpty) {
      print('No camera is found');
    } else {
      _controller = CameraController(
        widget._cameras[_rear ? 0 : 1],
        ResolutionPreset.max,
      );
      _controller.initialize().then((_) {
        if (_updateCamera()) {
          _readFrames();
        }
      });
    }
  }

  Future<void> _switchCameraLens() async {
    _rear = !_rear;
    await _controller?.dispose();
    _setupCamera();
  }

  bool _updateCamera() {
    if (!mounted) {
      return false;
    }
    setState(() {});
    return true;
  }

  void _updateRecognitions({
    List<dynamic> recognitions,
  }) {
    setState(() {
      _recognitions = recognitions;
    });
  }

  void _readFrames() {
    _controller.startImageStream(
      (CameraImage img) {
        if (!_isDetecting) {
          _isDetecting = true;

          Tflite.runModelOnFrame(
            bytesList: img.planes.map((Plane plane) {
              return plane.bytes;
            }).toList(),
            imageWidth: img.width,
            imageHeight: img.height,
            numResults: 2,
          ).then((List<dynamic> recognitions) {
            _updateRecognitions(
              recognitions: recognitions,
            );
            _isDetecting = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller.value.isInitialized) {
      return Container();
    }

    final Size screen = MediaQuery.of(context).size;
    final double screenH = max(screen.height, screen.width);
    final double screenW = min(screen.height, screen.width);

    final Size previewSize = _controller.value.previewSize;
    final double previewH = max(previewSize.height, previewSize.width);
    final double previewW = min(previewSize.height, previewSize.width);
    final double screenRatio = screenH / screenW;
    final double previewRatio = previewH / previewW;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _switchCameraLens(),
        child: Icon(_rear ? Icons.camera_front : Icons.camera_rear),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: <Widget>[
          OverflowBox(
            maxHeight: screenRatio > previewRatio
                ? screenH
                : screenW / previewW * previewH,
            maxWidth: screenRatio > previewRatio
                ? screenH / previewH * previewW
                : screenW,
            child: CameraPreview(_controller),
          ),
          ol.Overlay(
            results: _recognitions ?? <dynamic>[],
          )
        ],
      ),
    );
  }
}
