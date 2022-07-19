import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PswsInput extends StatelessWidget {
  final bool isFolder;
  final void Function(String)? onChanged;

  const PswsInput({
    Key? key,
    this.onChanged,
    required this.isFolder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final placeholder = isFolder
        ? l10n.common_dialog_placeholder_folder
        : l10n.common_dialog_placeholder_file;

    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: TextFormField(
        autofocus: true,
        onChanged: onChanged,
        validator: (value) {
          if ((value ?? '').isEmpty) {
            return AppLocalizations.of(context)!.common_dialog_error;
          }
        },
        decoration: InputDecoration(
            border: const OutlineInputBorder(), labelText: placeholder),
      ),
    );
  }
}
