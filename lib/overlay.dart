import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_face_mask_detecting/toast/toast.dart';
import 'package:oktoast/oktoast.dart';

class Overlay extends StatefulWidget {
  const Overlay({
    @required List<dynamic> results,
    this.threshold = 0.5,
  }) : _results = results;
  final List<dynamic> _results;
  final double threshold;

  @override
  _OverlayState createState() => _OverlayState();
}

class _OverlayState extends State<Overlay> {
  ToastFuture _toastFuture;
  String _label;
  double _confidence = 0;

  set label(String value) => setState(() {
        _label = value;
      });

  set confidence(double value) => setState(() {
        _confidence = value;
      });

  String get label => _label;

  double get confidence => _confidence;

  Color _updateBorderColor(
    BuildContext context,
    List<dynamic> bits,
  ) {
    if (bits == null) {
      return Colors.transparent;
    }

    if (bits.length > 1) {
      final String firstLabel = bits.first["label"] as String;
      final double firstConfidence = bits.first["confidence"] as double;

      final String secondLabel = bits.last["label"] as String;
      final double secondConfidence = bits.last["confidence"] as double;

      if (firstConfidence > secondConfidence) {
        label = firstLabel;
        confidence = firstConfidence;
      } else {
        label = secondLabel;
        confidence = secondConfidence;
      }
    }
    if (bits.length == 1) {
      label = bits.first["label"] as String;
      confidence = bits.first["confidence"] as double;
    }

    if (confidence < widget.threshold) {
      scheduleMicrotask(() => _toastFuture ??= Toast.show(
              context,
              ToastType.error,
              "Please keep the camera steady and keep a certain distance to prevent shaking.",
              onDismiss: () {
            _toastFuture = null;
          }));

      return Colors.transparent;
    }

    if (label == "without_mask") {
      return Colors.red;
    }

    if (label == "with_mask") {
      return Colors.greenAccent;
    }

    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.fromBorderSide(BorderSide(
              color: _updateBorderColor(
                context,
                widget._results,
              ),
              width: 10,
            )),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 85,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  label == "with_mask"
                      ? "Wearing mask ${(confidence * 100).toStringAsFixed(0)}%"
                      : "No mask ${(confidence * 100).toStringAsFixed(0)}%",
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: label == "with_mask"
                            ? Colors.greenAccent
                            : Colors.red,
                      ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: LinearProgressIndicator(
                  value: confidence,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      label == "with_mask" ? Colors.greenAccent : Colors.red),
                  minHeight: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
