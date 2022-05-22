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
              child: const Text('Cancel'),
            ),
            TextButton(
                onPressed: () {
                  value(fileName);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        );
      },
    );
  }
}
