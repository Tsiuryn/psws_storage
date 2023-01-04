import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:intl/intl.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/ui_kit/psws_back_button_listener.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/notes/bloc/edit_notes_bloc.dart';

const Map<String, String> fontSize = {
  '5': '5',
  '10': '10',
  '15': '15',
  '20': '20',
  '25': '25',
  '30': '30',
  '35': '35',
  '40': '40',
};

class EditNotesForm extends StatefulWidget {
  final DirectoryModel note;
  final EditNotesModel state;
  final String path;

  const EditNotesForm({
    Key? key,
    required this.note,
    required this.state,
    required this.path,
  }) : super(key: key);

  @override
  State<EditNotesForm> createState() => _EditNotesFormState();
}

class _EditNotesFormState extends State<EditNotesForm> with PswsDialogs {
  late QuillController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    try {
      _focusNode.addListener(() {
        if (_focusNode.hasFocus) {
          context.read<EditNotesBloc>().updateEditMode(false);
        }
      });
      final myJSON = jsonDecode(widget.note.content);
      final document = Document.fromJson(myJSON);
      _controller = QuillController(document: document, selection: const TextSelection.collapsed(offset: 0));
      _controller.moveCursorToEnd();
    } catch (e) {
      final doc = Document();
      doc.insert(0, widget.note.content);
      _controller = QuillController(document: doc, selection: const TextSelection.collapsed(offset: 0));
      _controller.moveCursorToEnd();
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
    final bool readOnly = widget.state.readOnly;
    final l10n = AppLocalizations.of(context);
    final pathPrefix = l10n?.import_export_page__path ?? '';
    final theme = AppTheme(context);

    return PswsBackButtonListener(context, backPressed: () {
      if (readOnly) {
        context.router.pop();
      } else {
        showDialog(context);
      }
      return true;
    },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 0,
              title: const SizedBox(),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Material(
                  elevation: 4,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      backgroundColor: theme.appColors?.appBarColor ?? Theme.of(context).primaryColor,
                      collapsedBackgroundColor: theme.appColors?.appBarColor ?? Theme.of(context).primaryColor,
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: const EdgeInsets.all(AppDim.four),
                      leading: IconButton(
                          onPressed: () {
                            if (readOnly) {
                              context.router.pop();
                            } else {
                              showDialog(context);
                            }
                          },
                          icon: const Icon(Icons.arrow_back)),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.note.name,
                              style: theme.appTextStyles?.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      iconColor: Theme.of(context).primaryColorDark,
                      collapsedIconColor: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorDark,
                      collapsedTextColor: Theme.of(context).primaryColorDark,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$pathPrefix ${widget.path}',
                          ),
                          Text('$subtitle ${DateFormat('dd.MM.yyyy - HH:mm').format(widget.note.createdDate)}'),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(AppDim.eight),
                          child: QuillToolbar.basic(
                            controller: _controller,
                            showItalicButton: false,
                            showLink: false,
                            toolbarIconAlignment: WrapAlignment.start,
                            showInlineCode: false,
                            customButtons: [
                              QuillCustomButton(
                                icon: widget.state.readOnly ? Icons.edit : Icons.save,
                                onTap: () {
                                  context.read<EditNotesBloc>().updateEditMode(!readOnly);
                                  if (!readOnly) {
                                    context.read<EditNotesBloc>().saveNote(content);
                                    _focusNode.unfocus();
                                  }
                                },
                              ),
                              // TODO: Method to add text
                              // QuillCustomButton(
                              //   icon: Icons.add,
                              //   onTap: (){
                              //     const myText = 'hello';
                              //     final index = _controller.selection.baseOffset;
                              //     final len = _controller.selection.extentOffset - index;
                              //     _controller.moveCursorToPosition(index + myText.length);
                              //     _controller.replaceText(index, len, myText, null);
                              //   }
                              // )
                            ],
                            fontSizeValues: fontSize,
                            iconTheme: QuillIconTheme(
                              iconSelectedFillColor: Theme.of(context).colorScheme.secondary,
                              borderRadius: AppDim.four,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  child: QuillEditor(
                    controller: _controller,
                    scrollController: ScrollController(),
                    scrollable: true,
                    focusNode: _focusNode,
                    autoFocus: !readOnly,
                    readOnly: readOnly,
                    expands: false,
                    padding: EdgeInsets.zero,
                    keyboardAppearance: Brightness.light,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDim.sixteen,
                    vertical: AppDim.four,
                  ),
                )),
              ],
            ),
          ),
        ));
  }

  String get content => jsonEncode(_controller.document.toDelta().toJson());

  void showDialog(BuildContext context) {
    final title = AppLocalizations.of(context)?.edit_notes_page__dialog_title ?? '';
    final subTitle = AppLocalizations.of(context)?.edit_notes_page__dialog_subTitle ?? '';

    createOkDialog(context, title: title, message: subTitle, tapNo: () {
      context.router.pop();
    }, tapOk: () {
      context.read<EditNotesBloc>().saveNote(content);
      context.router.pop();
    });
  }
}
