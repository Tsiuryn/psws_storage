import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:psws_storage/app/common/base_page.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/router/app_router.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/widgets/life_cycle_widget.dart';
import 'package:psws_storage/editor/presenter/notes/bloc/edit_notes_bloc.dart';
import 'package:psws_storage/editor/presenter/notes/edit_notes_form.dart';

@RoutePage()
class EditNotesPage extends StatelessBasePage<EditNotesBloc, EditNotesModel> {
  final int idHive;
  final String path;
  final List<DirectoryModel> directories;

  const EditNotesPage({
    Key? key,
    required this.idHive,
    required this.path,
    required this.directories,
  }) : super(key: key);

  @override
  EditNotesBloc createBloc(BuildContext context) {
    return getIt.get<EditNotesBloc>()
      ..getNoteData(idHive, directories: directories);
  }

  @override
  Widget buildBody(BuildContext context, EditNotesModel state) {
    final DirectoryModel? note = state.note;

    return LifeCycleWidget(
        router: context.router,
        currentRouteName: EditNotesRoute.name,
        child: note == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : EditNotesForm(
                note: note,
                state: state,
                path: path,
              ));
  }
}
