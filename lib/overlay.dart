import 'package:flutter/material.dart';

class Overlay extends StatelessWidget {
  const Overlay({
    @required List<dynamic> results,
    @required int previewH,
    @required int previewW,
    @required double screenH,
    @required double screenW,
  })  : _results = results,
        _previewH = previewH,
        _previewW = previewW,
        _screenH = screenH,
        _screenW = screenW;
  final List<dynamic> _results;
  final int _previewH;
  final int _previewW;
  final double _screenH;
  final double _screenW;

  @override
  Widget build(BuildContext context) {
    double offset = -10;
    return Stack(children: <Widget>[
      ..._results.map((dynamic bit) {
        offset = offset + 14;
        return Positioned(
          left: 10,
          top: offset,
          width: _screenW,
          height: _screenH,
          child: Text(
            "${bit["label"]} ${(bit["confidence"] * 100).toStringAsFixed(0)}%",
            style: const TextStyle(
              color: Color.fromRGBO(37, 213, 253, 1.0),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    ]);
  }
}
