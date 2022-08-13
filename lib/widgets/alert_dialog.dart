import 'package:flutter/cupertino.dart';

class MyAlertDialog {
  static void showMyDialog(
      {required BuildContext context,
      required String title,
      required String contentText,
      required Function() tabNo,
      required Function() tabYes}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(contentText),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: tabNo,
          ),
          CupertinoDialogAction(
            child: const Text('Yes'),
            isDestructiveAction: true,
            onPressed: tabYes,
          ),
        ],
      ),
    );
  }
}
