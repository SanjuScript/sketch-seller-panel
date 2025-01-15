import 'package:flutter/material.dart';

class SnackbarHandler {
  SnackbarHandler._();
  static final SnackbarHandler instance = SnackbarHandler._();

  void showSnackbar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color backgroundColor = Colors.black,
    TextStyle? textStyle,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackbar = SnackBar(
      content: Text(
        message,
        style: textStyle ??
            const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
      ),
      duration: duration,
      backgroundColor: backgroundColor,
      action: action,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
