import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/presenter/main/bloc/main_bloc.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget, PswsSnackBar, PswsDialogs {

  const MainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainBloc>();
    return AppBar(
      title: Row(
        children: [
          IconButton(onPressed: (){
            createFileDialog(context, title: 'title', isFolder: false, value: (value){
              bloc.addFile(value);
            });

          }, icon: const Icon(Icons.add, )),

          const SizedBox(width: 20,),

          IconButton(onPressed: (){
            createFileDialog(context, title: 'title', value: (value){
              bloc.addFolder(value);
            });

          }, icon: const Icon(Icons.folder, )),

          Expanded(
            child: IconButton(onPressed: (){
              _showBottomSheet(context);
            }, icon: const Icon(Icons.search,), alignment: AlignmentDirectional.centerEnd,),),

          IconButton(onPressed: (){

          }, icon: const Icon(Icons.menu,), alignment: AlignmentDirectional.centerEnd,)
        ]
      ),
    );
  }

  void _showBottomSheet(BuildContext context){

  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
