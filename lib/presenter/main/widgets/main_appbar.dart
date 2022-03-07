import 'package:flutter/material.dart';
import 'package:psws_storage/app/ui_kit/bottom_sheet.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget, PswsSnackBar {

  const MainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          IconButton(onPressed: (){
            showRequestSnackBar(context, message: 'add icon', isSuccess: true);
          }, icon: Icon(Icons.add, size: 40,)),

          SizedBox(width: 20,),

          IconButton(onPressed: (){
            showRequestSnackBar(context, message: 'add folder', isSuccess: true);
          }, icon: Icon(Icons.folder, size: 40,)),

          Expanded(
            child: IconButton(onPressed: (){
              _showBottomSheet(context);
            }, icon: Icon(Icons.menu, size: 40,), alignment: AlignmentDirectional.centerEnd,),
          )
        ]
      ),
    );
  }

  void _showBottomSheet(BuildContext context){
    showModalUniBottomSheet(context: context, title: 'Settings', content: SizedBox(), closeIcon: Icon(Icons.close), onClose: (){

    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
