import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/domain/model/directory_model.dart';
import 'package:psws_storage/presenter/notes/bloc/edit_notes_bloc.dart';

class EditNotesForm extends StatefulWidget {
  final DirectoryModel note;

  const EditNotesForm({Key? key, required this.note}) : super(key: key);

  @override
  State<EditNotesForm> createState() => _EditNotesFormState();
}

class _EditNotesFormState extends State<EditNotesForm> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.note.content;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDim.sixteen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextFormField(
              controller: _controller,
              minLines: null,
              maxLines: null,
              autofocus: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                context.read<EditNotesBloc>().saveNote(_controller.text);
              },
              icon: CircleAvatar(
                child: Icon(
                  Icons.save,
                  color: Colors.black,
                ),
                backgroundColor: Colors.white,
              ))
        ],
      ),
    );
  }
}
