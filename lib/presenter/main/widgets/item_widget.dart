import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/domain/model/directory_model.dart';

class ItemWidget extends StatelessWidget {
  final DirectoryModel model;
  final int id;
  final Function()? onDelete;
  const ItemWidget({Key? key, required this.model, required this.id, this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const folderIcon = Icons.folder;
    const fileIcon = Icons.file_present_outlined;

    return SwipeActionCell(
      key: ValueKey(id),
      trailingActions: <SwipeAction>[
        SwipeAction(
          ///this is the same as iOS native
            performsFirstActionWithFullSwipe: true,
            icon: const Icon(Icons.delete, color: Colors.white,),
            title: "Delete",
            style: const TextStyle(fontSize: 14),
            onTap: (CompletionHandler handler) async {
              await handler(true);
              onDelete?.call();
            },
            color: Colors.red),
      ],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDim.eight, vertical: AppDim.two,),
            child: Row(children: [
              Icon(model.isFolder ? folderIcon : fileIcon, size: AppDim.fourty,),
              const SizedBox(width: AppDim.sixteen,),
              Expanded(child: Text(model.name, overflow: TextOverflow.ellipsis,)),
            ],),
          ),
          Divider(color: Theme.of(context).dividerColor,),
        ],
      ),
    );
  }
}
