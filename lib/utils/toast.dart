import 'package:flutter/material.dart';

void showToast({required BuildContext context, required String message}) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.clearSnackBars();
  scaffold.showSnackBar(
    SnackBar(
      duration: Duration(seconds: 3),
      content: Text(message),
      action: SnackBarAction(
          label: 'Close', onPressed: scaffold.hideCurrentSnackBar,
      ),
    ),
  );
}
