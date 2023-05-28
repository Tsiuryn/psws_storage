import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psws_storage/app/ui_kit/psws_input.dart';
import 'package:psws_storage/editor/presenter/notes/widget/choose_date_widget.dart';

import '../dimens/app_dim.dart';

mixin PswsDialogs {
  void createFileDialog(
    BuildContext context, {
    required String title,
    bool isFolder = true,
    String? initialTextValue,
    required Function(String) value,
  }) {
    final l10n = AppLocalizations.of(context)!;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final controller = TextEditingController(text: initialTextValue);

        return AlertDialog(
          contentPadding: const EdgeInsets.only(
            top: AppDim.sixteen,
            left: AppDim.sixteen,
            right: AppDim.sixteen,
          ),
          title: Text(title),
          content: Form(
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PswsInput(
                  controller: controller,
                  validator: (String? value) {
                    if ((value ?? '').isEmpty) {
                      return AppLocalizations.of(context)!.common_dialog_error;
                    }
                    return null;
                  },
                  placeholder: isFolder
                      ? l10n.common_dialog_placeholder_folder
                      : l10n.common_dialog_placeholder_file,
                ),
                IconButton(
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  onPressed: () {
                    _showBottomSheet(context, selectedDate: (value) {
                      controller.text = value;
                    });
                  },
                  icon: const Icon(
                    Icons.calendar_month_rounded,
                    size: AppDim.thirtyTwo,
                  ),
                ),
              ],
            ),
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
                  final fileName = controller.text;
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

  void _showBottomSheet(
    BuildContext context, {
    required Function(String) selectedDate,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDim.sixteen),
          topRight: Radius.circular(AppDim.sixteen),
        ),
      ),
      builder: (context) {
        return ChooseDateWidget(
          onSelectedDate: selectedDate,
        );
      },
      showDragHandle: false,
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
                Navigator.of(context, rootNavigator: true).pop();
                tapNo();
              },
              child: Text(
                l10n.common_dialog_no,
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  tapOk();
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
