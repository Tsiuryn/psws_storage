import 'package:flutter/material.dart';
import 'package:psws_storage/app/common/base_page.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/notes/bloc/edit_notes_bloc.dart';
import 'package:psws_storage/editor/presenter/notes/edit_notes_form.dart';

class EditNotesPage extends StatelessBasePage<EditNotesBloc, EditNotesModel> {
  final int idHive;

  const EditNotesPage({Key? key, required this.idHive}) : super(key: key);

  @override
  EditNotesBloc createBloc(BuildContext context) {
    return getIt.get<EditNotesBloc>()..getNoteData(idHive);
  }

  @override
  Widget buildBody(BuildContext context, EditNotesModel state) {
    final DirectoryModel? note = state.note;
    return note == null
        ? const Center(
            child: Text('nothing to show'),
          )
        : EditNotesForm(note: note);
  }
}
