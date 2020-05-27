import 'package:flutter/material.dart';
import 'package:flutter_face_mask_detecting/toast/slide_fade_in_toast_animation.dart';
import 'package:oktoast/oktoast.dart';

class Toast {
  static const Duration kToastDuration = Duration(seconds: 3);

  static ToastFuture show(
    BuildContext context,
    ToastType type,
    String text, {
    VoidCallback onDismiss,
    Duration duration = kToastDuration,
    bool dismissEnable = true,
  }) {
    return showToastWidget(
      _buildToast(context, type, text, dismissEnable),
      context: context,
      position: const ToastPosition(align: Alignment.topCenter),
      duration: dismissEnable ? duration : const Duration(days: 1),
      handleTouch: true,
      onDismiss: onDismiss,
      animationBuilder: SlideFadeInToastAnimation(),
    );
  }

  static void dismissAll({bool animated}) {
    dismissAllToast(showAnim: animated);
  }

  static Widget _buildOkButton(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: 10.0,
        ),
        GestureDetector(
          onTap: () => dismissAllToast(showAnim: true),
          child: Text(
            "OK",
            style: Theme.of(context).textTheme.overline.copyWith(
                  color: Colors.white,
                ),
          ),
        )
      ],
    );
  }

  static Widget _buildToast(
    BuildContext context,
    ToastType type,
    String text,
    bool dismissEnable,
  ) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Material(
          color: Colors.black,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Row(
              children: <Widget>[
                if (type == ToastType.success)
                  const Image(
                    image: AssetImage('assets/toast_check_mark.png'),
                    width: 18.0,
                    height: 18.0,
                  )
                else if (type == ToastType.error)
                  const Image(
                    image: AssetImage('assets/toast_error.png'),
                    width: 18.0,
                    height: 18.0,
                  )
                else
                  throw Exception("Wrong toast type!"),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Text(
                    text,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white),
                  ),
                ),
                if (dismissEnable) _buildOkButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum ToastType {
  success,
  error,
}
