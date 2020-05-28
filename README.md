# flutter_face_mask_detecting

Flutter app for detecting face with mask or without mask.

# Intro

https://docs.google.com/document/d/1v5t3yj0o4g1Mn1RA7q4KgMOAicfBiCBE8zRJeRDVBEQ/edit?usp=sharing


![](./media/intro.gif) 

- Training codes: http://tinyurl.com/ybmjk9hu
> Avoid writing boilerplate codes to us Keras to train on pretrained MobileNetV2, 
> referencing Google codelabs.

- Training dataset: http://tinyurl.com/ya6vvfap

# Plugin for mobile

- camera: ^0.5.8+2
- Tensorflow Lite plugin: tflite: ^1.0.5
- oktoast: ^2.3.2

# About tflite

Shooting video with camera plugin.
Use `tflite` plugin to read frames and inference with tflite  (Tensorflow Lite):

```dart

    ....
    CameraController _controller;
    bool _isDetecting = false;
    ....

    ....    ....    ....
    List<dynamic> _recognitions;
    void _updateRecognitions({
      List<dynamic> recognitions,
    }) {
      setState(() {
        _recognitions = recognitions;
      });
    }
    .... ....    ....
        
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
```

# License

```
Copyright 2020 Chris Xinyue Zhao

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
