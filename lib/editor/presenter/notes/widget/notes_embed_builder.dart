import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:psws_storage/app/theme/app_theme.dart';

class NotesEmbedBuilder implements EmbedBuilder {
  NotesEmbedBuilder({required this.addEditNote});

  Future<void> Function(BuildContext context, {CustomDirectory? directory})
      addEditNote;

  @override
  String get key => 'notes';

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
  ) {
    final notes = NotesBlockEmbed(node.value.data).directory;
    final theme = AppTheme(context);
    final colorsTheme = theme.appColors;
    final textTheme = theme.appTextStyles;

    return GestureDetector(
      onTap: () => addEditNote(context, directory: notes),
      child: Text(
        '--"${notes.name}"--',
        style: textTheme?.titleMedium?.copyWith(
          color: colorsTheme?.positiveActionColor,
        ),
      ),
    );
  }

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(
      child: widget,
    );
  }

  @override
  bool get expanded => false;
}

class NotesBlockEmbed extends CustomBlockEmbed {
  const NotesBlockEmbed(String value) : super(noteType, value);

  static const String noteType = 'notes';

  static NotesBlockEmbed fromDocument(CustomDirectory directory) =>
      NotesBlockEmbed(jsonEncode(directory.toMap()));

  CustomDirectory get directory => CustomDirectory.fromMap(jsonDecode(data));
}

class CustomDirectory {
  final String name;
  final String id;
  final int hiveId;

  const CustomDirectory(
      {required this.name, required this.id, required this.hiveId});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'hiveId': hiveId,
    };
  }

  factory CustomDirectory.fromMap(Map<String, dynamic> map) {
    return CustomDirectory(
      name: map['name'] as String,
      id: map['id'] as String,
      hiveId: map['hiveId'] as int,
    );
  }
}
