import 'package:flutter/material.dart';
import 'package:flutter_face_mask_detecting/toast/toast.dart';

class Overlay extends StatelessWidget {
  const Overlay({
    @required List<dynamic> results,
    this.threshold = 0.8,
  }) : _results = results;
  final List<dynamic> _results;
  final double threshold;

  Color _updateBorderColor(
    BuildContext context,
    List<dynamic> bits,
  ) {
    if (bits == null) {
      return Colors.transparent;
    }

    String label;
    double confidence = 0;

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

    if (confidence < threshold) {
      Toast.show(
        context,
        ToastType.error,
        "Please keep the camera steady and keep a certain distance to prevent shaking.",
      );
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
    return Container(
      decoration: BoxDecoration(
        border: Border.fromBorderSide(BorderSide(
          color: _updateBorderColor(
            context,
            _results,
          ),
          width: 15,
        )),
      ),
    );
  }
}
