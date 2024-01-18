import 'package:flutter/material.dart';


//SHOW SNACKBAR
void showSnackBarBottom(BuildContext context, final textMessage) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(textMessage ?? "Authentication Failed!"),
      ),
    );
  }
}
