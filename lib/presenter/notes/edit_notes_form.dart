import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:intl/intl.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/ui_kit/psws_back_button_listener.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/domain/model/directory_model.dart';
import 'package:psws_storage/presenter/notes/bloc/edit_notes_bloc.dart';

class EditNotesForm extends StatefulWidget {
  final DirectoryModel note;

  const EditNotesForm({Key? key, required this.note}) : super(key: key);

  @override
  State<EditNotesForm> createState() => _EditNotesFormState();
}

class _EditNotesFormState extends State<EditNotesForm> with PswsDialogs {
  late QuillController _controller;

  @override
  void initState() {
    super.initState();
    try {
      var myJSON = jsonDecode(widget.note.content);
      _controller = QuillController(
          document: Document.fromJson(myJSON),
          selection: TextSelection.collapsed(offset: 0));
    } catch (e) {
      _controller = QuillController.basic();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = AppLocalizations.of(context)?.edit_notes_page__subtitle;

    return PswsBackButtonListener(
      context,
      backPressed: () {
        showDialog(context);
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ColoredBox(
            color: Theme.of(context).primaryColor,
            child: Stack(
              children: [
                ExpansionTile(
                  title: Text(widget.note.name),
                  tilePadding: const EdgeInsets.only(
                      left: AppDim.fourtyFour, right: AppDim.eight),
                  iconColor: Theme.of(context).primaryColorDark,
                  collapsedIconColor: Theme.of(context).primaryColorDark,
                  textColor: Theme.of(context).primaryColorDark,
                  collapsedTextColor: Theme.of(context).primaryColorDark,
                  collapsedBackgroundColor: Colors.transparent,
                  subtitle: Text(
                      '$subtitle ${DateFormat('dd.MM.yyyy - HH:mm').format(widget.note.createdDate)}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: QuillToolbar.basic(
                        controller: _controller,
                        showImageButton: false,
                        showVideoButton: false,
                        showLink: false,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: AppDim.twelve),
                  child: IconButton(
                      onPressed: () {
                        showDialog(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                ),
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(AppDim.eight),
            child: QuillEditor.basic(controller: _controller, readOnly: false),
          )),
        ],
      ),
    );
  }

  void showDialog(BuildContext context) {
    final title =
        AppLocalizations.of(context)?.edit_notes_page__dialog_title ?? '';
    final subTitle =
        AppLocalizations.of(context)?.edit_notes_page__dialog_subTitle ?? '';

    createOkDialog(context, title: title, message: subTitle, tapNo: () {
      context.router.pop();
    }, tapOk: () {
      final content = jsonEncode(_controller.document.toDelta().toJson());
      context.read<EditNotesBloc>().saveNote(content);
      context.router.pop();
    });
  }
}
