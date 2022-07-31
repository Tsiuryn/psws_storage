import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psws_storage/app/ui_kit/psws_input.dart';

mixin PswsDialogs {
  void createFileDialog(
    BuildContext context, {
    required String title,
    bool isFolder = true,
    required Function(String) value,
  }) {
    String fileName = '';
    final l10n = AppLocalizations.of(context)!;

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
                l10n.common_dialog_cancel,
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
            ),
            TextButton(
                onPressed: () {
                  if (fileName.isEmpty) {
                    return;
                  }
                  value(fileName);
                  Navigator.pop(context);
                },
                child: Text(
                  l10n.common_dialog_ok,
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
    bool barrierDismissible = false,
  }) {
    final l10n = AppLocalizations.of(context)!;

    showDialog<String>(
      context: context,
      barrierDismissible: barrierDismissible,
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
                l10n.common_dialog_no,
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
            ),
            TextButton(
                onPressed: () {
                  tapOk();
                  Navigator.pop(context);
                },
                child: Text(
                  l10n.common_dialog_yes,
                  style: const TextStyle(color: Colors.blue),
                ))
          ],
        );
      },
    );
  }
}
