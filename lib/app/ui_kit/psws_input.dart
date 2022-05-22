import 'package:flutter/material.dart';

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
    final labelText = isFolder ? 'Folder' : 'File';

    return TextFormField(
      onChanged: onChanged,
      decoration: InputDecoration(border: const OutlineInputBorder(), labelText: '$labelText name'),
    );
  }
}
