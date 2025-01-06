import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/constants.dart';

class MyAlertBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const MyAlertBox({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: CupertinoTextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        maxLines: null,
        placeholder: hintText,
      ),
      actions: [
        TextButton(
          onPressed: onSave,
          child: const Text(
            dialogBtnSave,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: onCancel,
          child: const Text(
            dialogBtnCancel,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
