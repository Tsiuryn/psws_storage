import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:psws_storage/res/app_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:psws_storage/app/common/path_bottom_sheet.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/ui_kit/calculator_dialog/calculator_dialog.dart';
import 'package:psws_storage/app/ui_kit/psws_back_button_listener.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/app/utils/constants.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/pages/search_directory_page.dart';
import 'package:psws_storage/editor/presenter/notes/bloc/edit_notes_bloc.dart';
import 'package:psws_storage/editor/presenter/notes/widget/choose_date_widget.dart';
import 'package:psws_storage/editor/presenter/notes/widget/custom_icon_button.dart';

import '../../../app/router/app_router.dart';
import 'widget/notes_embed_builder.dart';

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
      _controller = QuillController(
          document: document,
          // readOnly: widget.state.readOnly,
          selection: const TextSelection.collapsed(offset: 0));
      _controller.moveCursorToEnd();
    } catch (e) {
      final doc = Document();
      doc.insert(0, widget.note.content);
      _controller = QuillController(
          document: doc,
          // readOnly: widget.state.readOnly,
          selection: const TextSelection.collapsed(offset: 0));
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
    final subtitle = AppLocalizations.of(context).edit_notes_page__subtitle;
    final bool readOnly = widget.state.readOnly;

    final theme = AppTheme(context);
    const selectedButtonData = IconButtonData(
        color: Colors.yellow,
        visualDensity: VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ));
    const unSelectedButtonData = IconButtonData(
        visualDensity: VisualDensity(
      horizontal: VisualDensity.minimumDensity,
      vertical: VisualDensity.minimumDensity,
    ));

    return PswsBackButtonListener(
      context,
      backPressed: () {
        if (readOnly) {
          context.router.maybePop();
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
            // title: const SizedBox(),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Material(
                elevation: 4,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    backgroundColor: theme.appColors?.appBarColor ??
                        Theme.of(context).primaryColor,
                    collapsedBackgroundColor: theme.appColors?.appBarColor ??
                        Theme.of(context).primaryColor,
                    childrenPadding: EdgeInsets.zero,
                    tilePadding: const EdgeInsets.fromLTRB(
                      AppDim.four,
                      AppDim.four,
                      AppDim.sixteen,
                      AppDim.four,
                    ),
                    dense: false,
                    leading: IconButton(
                        onPressed: () {
                          if (readOnly) {
                            context.router.maybePop();
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
                            '$subtitle ${dateFormatter.format(widget.note.createdDate)}'),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppDim.eight),
                        child: QuillToolbar.simple(
                          controller: _controller,
                          configurations: QuillSimpleToolbarConfigurations(
                            toolbarSectionSpacing: 0.0,
                            showClipboardCut: false,
                            showClipboardCopy: false,
                            showClipboardPaste: false,
                            showLink: true,
                            showSearchButton: false,
                            showFontSize: true,
                            fontSizesValues: fontSize,
                            showHeaderStyle: false,
                            showSubscript: false,
                            showSuperscript: false,
                            showBackgroundColorButton: true,
                            showFontFamily: false,
                            showAlignmentButtons: true,
                            toolbarIconAlignment: WrapAlignment.start,
                            showInlineCode: false,
                            showDividers: false,

                            buttonOptions: QuillSimpleToolbarButtonOptions(
                              fontSize: QuillToolbarFontSizeButtonOptions(
                                style: theme.appTextStyles?.subtitle?.copyWith(
                                  color: theme.appColors?.textColor,
                                ),
                                defaultItemColor: theme.appColors?.textColor,
                              ),
                              base: QuillToolbarBaseButtonOptions(
                                iconTheme: QuillIconTheme(
                                  iconButtonSelectedData: selectedButtonData,
                                  iconButtonUnselectedData:
                                      unSelectedButtonData,

                                  // iconButtonSelectedStyle: selectedButton,
                                  // iconButtonUnselectedStyle: selectedButton,
                                ),
                              ),
                            ),
                            embedButtons: [
                              (controller, toolbarIconSize, iconTheme,
                                  dialogTheme) {
                                return CustomIconButton(
                                  iconTheme: iconTheme,
                                  onPressed: () {
                                    final index =
                                        controller.selection.baseOffset;
                                    final length =
                                        controller.selection.extentOffset -
                                            index;
                                    context.router
                                        .push(SearchDirectoryRoute(
                                      directories:
                                          widget.state.allNotesWithoutCurrent,
                                      searchDestination:
                                          SearchDestination.getPath,
                                    ))
                                        .then(
                                      (value) {
                                        if (value is DirectoryModel) {
                                          final block = BlockEmbed.custom(
                                            NotesBlockEmbed.fromDocument(
                                                CustomDirectory(
                                              name: value.name,
                                              id: value.id,
                                              hiveId: value.idHiveObject,
                                            )),
                                          );
                                          controller.replaceText(
                                              index, length, block, null);
                                        }
                                      },
                                    );
                                  },
                                  icon: Icons.add_link_rounded,
                                );
                              },
                              (controller, toolbarIconSize, iconTheme,
                                  dialogTheme) {
                                return CustomIconButton(
                                  icon: Icons.access_time_rounded,
                                  iconTheme: iconTheme,
                                  onPressed: () {
                                    _showBottomSheet(context);
                                  },
                                );
                              },
                              (controller, toolbarIconSize, iconTheme,
                                  dialogTheme) {
                                return CustomIconButton(
                                  icon: Icons.calculate_outlined,
                                  iconTheme: iconTheme,
                                  onPressed: () async {
                                    final result = await material.showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const CalculatorDialog();
                                        });
                                    if (result != null &&
                                        result is CalculatorResult) {
                                      _setTextToCurrentPosition(
                                          '${result.userInput} = ${result.answer}');
                                    }
                                  },
                                );
                              },
                              (controller, toolbarIconSize, iconTheme,
                                  dialogTheme) {
                                return CustomIconButton(
                                  icon: Icons.info_outline_rounded,
                                  iconTheme: iconTheme,
                                  onPressed: () async {
                                    showPathBottomSheet(context,
                                        path: widget.path);
                                  },
                                );
                              },
                            ],
                            customButtons: [
                              QuillToolbarCustomButtonOptions(
                                icon: Icon(Icons.calendar_month_rounded),
                                onPressed: () {
                                  _setTextToCurrentPosition(DateFormat.yMd('ru')
                                      .format(DateTime.now()));
                                },
                              ),
                              QuillToolbarCustomButtonOptions(
                                icon: Icon(Icons.access_time_filled_rounded),
                                onPressed: () {
                                  _setTextToCurrentPosition(DateFormat.Hms('ru')
                                      .format(DateTime.now()));
                                },
                              ),
                              QuillToolbarCustomButtonOptions(
                                icon: widget.state.readOnly
                                    ? const Icon(Icons.edit)
                                    : const Icon(Icons.save),
                                onPressed: () {
                                  context
                                      .read<EditNotesBloc>()
                                      .updateEditMode(!readOnly);
                                  if (!readOnly) {
                                    context
                                        .read<EditNotesBloc>()
                                        .saveNote(content);
                                    _focusNode.unfocus();
                                  }
                                },
                              ),
                            ],
                            // fontSizeValues: fontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (readOnly) {
                      FocusScope.of(context).requestFocus(_focusNode);
                    }
                  },
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDim.sixteen,
                        vertical: AppDim.four,
                      ),
                      child: QuillEditor(
                        scrollController: ScrollController(),
                        focusNode: _focusNode,
                        controller: _controller,
                        configurations: QuillEditorConfigurations(
                          scrollable: false,
                          autoFocus: !readOnly,
                          expands: false,
                          padding: EdgeInsets.zero,
                          customStyles: DefaultStyles(
                            lists: DefaultListBlockStyle(
                              AppTheme(context).appTextStyles!.titleMedium!,
                              const HorizontalSpacing(0, 0),
                              const VerticalSpacing(0, 0),
                              const VerticalSpacing(0, 0),
                              const BoxDecoration(),
                              _CheckBox(),
                            ),
                          ),
                          embedBuilders: [
                            NotesEmbedBuilder(addEditNote: _addEditNote),
                          ],
                          keyboardAppearance: Brightness.light,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addEditNote(BuildContext context,
      {CustomDirectory? directory}) async {
    final note = widget.state.getDirectoryById(directory?.id);
    final path = widget.state.getPath(note);
    if (directory != null && path != null) {
      final readOnly = widget.state.readOnly;
      context.router
          .push(EditNotesRoute(
        idHive: note?.idHiveObject ?? directory.hiveId,
        path: path,
        directories: widget.state.directories,
      ))
          .then((value) {
        if (readOnly && context.mounted) {
          _focusNode.unfocus();
          context.read<EditNotesBloc>().updateEditMode(true);
        }
      });
    }
  }

  void _showBottomSheet(BuildContext context) {
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
          onSelectedDate: _setTextToCurrentPosition,
        );
      },
      showDragHandle: false,
    );
  }

  void _setTextToCurrentPosition(String text) {
    final index = _controller.selection.baseOffset;
    final len = _controller.selection.extentOffset - index;
    _controller.replaceText(index, len, text, null);
    _controller.moveCursorToPosition(index + text.length);
  }

  String get content => jsonEncode(_controller.document.toDelta().toJson());

  void showDialog(BuildContext context) {
    final title = AppLocalizations.of(context).edit_notes_page__dialog_title;
    final subTitle =
        AppLocalizations.of(context).edit_notes_page__dialog_subTitle;

    createOkDialog(context, title: title, message: subTitle, tapNo: () {
      context.router.maybePop();
    }, tapOk: () {
      context.read<EditNotesBloc>().saveNote(content);
      context.router.maybePop();
    });
  }
}

class _CheckBox implements QuillCheckboxBuilder {
  @override
  Widget build(
      {required BuildContext context,
      required bool isChecked,
      required ValueChanged<bool> onChanged}) {
    return GestureDetector(
      onTap: () {
        onChanged(!isChecked);
      },
      child: Icon(
        isChecked ? Icons.check_box : Icons.check_box_outline_blank,
        size: AppDim.twenty,
      ),
    );
  }
}
