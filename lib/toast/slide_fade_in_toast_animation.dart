import 'dart:math';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class SlideFadeInToastAnimation extends BaseAnimationBuilder {
  @override
  Widget buildWidget(
    BuildContext context,
    Widget child,
    AnimationController controller,
    double percent,
  ) {
    final double opacity = min(1.0, percent + 0.2);
    final double offset = (1 + percent) * 11;

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        child: child,
        offset: Offset(0, offset),
      ),
    );
  }
}
