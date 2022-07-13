import 'package:flutter/material.dart';
import 'package:psws_storage/app/ui_kit/psws_input.dart';

mixin PswsDialogs {
  void createFileDialog(
    BuildContext context, {
    required String title,
    bool isFolder = true,
    required Function(String) value,
  }) {
    String fileName = '';

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: PswsInput(
            onChanged: (text) {
              fileName = text;
            },
            isFolder: isFolder,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
            ),
            TextButton(
                onPressed: () {
                  value(fileName);
                  Navigator.pop(context);
                },
                child: Text(
                  'Ok',
                  style: TextStyle(color: Theme.of(context).primaryColorDark),
                ))
          ],
        );
      },
    );
  }

  void createOkDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback tapOk,
    required VoidCallback tapNo,
  }) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                tapNo();
                Navigator.pop(context);
              },
              child: Text(
                'NO',
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
            ),
            TextButton(
                onPressed: () {
                  tapOk();
                  Navigator.pop(context);
                },
                child: const Text(
                  'YES',
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        );
      },
    );
  }
}
