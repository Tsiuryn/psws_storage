import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';

class ItemWidget extends StatelessWidget {
  final DirectoryModel model;
  final int id;
  final Function()? onDelete;
  final Function()? onEdit;
  final Function() onTap;

  const ItemWidget(
      {Key? key,
      required this.model,
      required this.onTap,
      required this.id,
      this.onDelete,
      this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const folderIcon = Icons.folder;
    const fileIcon = Icons.file_present_outlined;

    return Column(
      children: [
        SwipeActionCell(
          key: ValueKey(id),
          leadingActions: [
            SwipeAction(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                title: "Rename",
                style: const TextStyle(fontSize: 14),
                onTap: (CompletionHandler handler) async {
                  await handler(false);
                  onEdit?.call();
                },
                color: Colors.green),
          ],
          trailingActions: <SwipeAction>[
            SwipeAction(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                title: "Delete",
                style: const TextStyle(fontSize: 14),
                onTap: (CompletionHandler handler) async {
                  await handler(false);
                  onDelete?.call();
                },
                color: Colors.red),
          ],
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDim.eight,
                vertical: AppDim.four,
              ),
              child: Row(
                children: [
                  Icon(
                    model.isFolder ? folderIcon : fileIcon,
                    size: AppDim.fourty,
                  ),
                  const SizedBox(
                    width: AppDim.sixteen,
                  ),
                  Expanded(
                      child: Text(
                    model.name,
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }
}
