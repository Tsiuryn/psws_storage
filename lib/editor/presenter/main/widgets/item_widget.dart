import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';
import 'package:psws_storage/app/theme/app_text_style_ext.dart';
import 'package:psws_storage/app/utils/constants.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/res/resources.dart';

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
    final AppColorsExt? appColors = Theme.of(context).extension<AppColorsExt>();
    final AppTextStyleExt? appTextStyles =
        Theme.of(context).extension<AppTextStyleExt>();
    final folderIcon = SvgPicture.asset(
      AppIcons.icFolder,
      color: appColors?.textColor,
    );
    final fileIcon = SvgPicture.asset(
      AppIcons.icFile,
      color: appColors?.textColor,
    );
    final l10n = AppLocalizations.of(context)!;

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
              title: l10n.item_widget__rename,
              style:
                  const TextStyle(fontSize: AppDim.eight, color: Colors.white),
              onTap: (CompletionHandler handler) async {
                await handler(false);
                onEdit?.call();
              },
              color: appColors?.positiveActionColor ?? Colors.green,
            ),
          ],
          trailingActions: <SwipeAction>[
            SwipeAction(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              title: l10n.item_widget__delete,
              style:
                  const TextStyle(fontSize: AppDim.eight, color: Colors.white),
              onTap: (CompletionHandler handler) async {
                await handler(false);
                onDelete?.call();
              },
              color: appColors?.negativeActionColor ?? Colors.red,
            ),
          ],
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: AppDim.thirtyTwo * 2,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: AppDim.sixteen,
                            ),
                            model.isFolder ? folderIcon : fileIcon,
                            const SizedBox(
                              width: AppDim.thirtyTwo,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model.name,
                                    style: appTextStyles?.titleMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    l10n.item_widget__created(dateFormatter
                                        .format(model.createdDate)),
                                    style: appTextStyles?.subtitle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        ),
        // Divider(
        //   color: Theme.of(context).dividerColor,
        // ),
      ],
    );
  }
}
