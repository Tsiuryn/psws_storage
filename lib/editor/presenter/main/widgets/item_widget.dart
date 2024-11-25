import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:psws_storage/app/common/path_bottom_sheet.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';
import 'package:psws_storage/app/theme/app_text_style_ext.dart';
import 'package:psws_storage/app/utils/constants.dart';
import 'package:psws_storage/app/utils/text_extensions.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/res/resources.dart';

typedef PathBuilder = String Function();

class ItemWidget extends StatelessWidget {
  final DirectoryModel model;
  final String searchValue;
  final int id;
  final bool canSwipe;
  final bool showPopUpMenuButton;
  final Function()? onDelete;
  final Function()? onEdit;
  final Function()? onMove;
  final Function() onTap;
  final PathBuilder? pathBuilder;

  const ItemWidget({
    Key? key,
    required this.model,
    required this.onTap,
    required this.id,
    this.pathBuilder,
    this.canSwipe = true,
    this.showPopUpMenuButton = false,
    this.searchValue = '',
    this.onDelete,
    this.onEdit,
    this.onMove,
  }) : super(key: key);

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
    final linkIcon = Icon(
      Icons.link_rounded,
      size: AppDim.thirtyTwo,
      color: appColors?.textColor,
    );
    final l10n = AppLocalizations.of(context);
    final leadingActions = [
      SwipeAction(
        icon: _buildIcon(
          Icons.open_with_rounded,
        ),
        title: l10n.item_widget__move,
        style: const TextStyle(fontSize: AppDim.eight, color: Colors.white),
        onTap: (CompletionHandler handler) async {
          await handler(false);
          onMove?.call();
        },
        color: appColors?.positiveActionColor ?? Colors.green,
      ),
      SwipeAction(
        icon: _buildIcon(
          Icons.edit,
        ),
        title: l10n.item_widget__rename,
        style: const TextStyle(fontSize: AppDim.eight, color: Colors.white),
        onTap: (CompletionHandler handler) async {
          await handler(false);
          onEdit?.call();
        },
        color: appColors?.positiveActionColor ?? Colors.green,
      ),
    ];

    final trailingActions = [
      SwipeAction(
        icon: _buildIcon(
          Icons.delete,
        ),
        title: l10n.item_widget__delete,
        style: const TextStyle(fontSize: AppDim.eight, color: Colors.white),
        onTap: (CompletionHandler handler) async {
          await handler(false);
          onDelete?.call();
        },
        color: appColors?.negativeActionColor ?? Colors.red,
      ),
    ];

    final textStyle = appTextStyles?.titleMedium ?? const TextStyle();
    final textHighLightStyle = appTextStyles?.titleMedium
            ?.copyWith(backgroundColor: Colors.grey[600]) ??
        const TextStyle();

    return Column(
      children: [
        SwipeActionCell(
          key: ValueKey(id),
          leadingActions: canSwipe ? leadingActions : [],
          trailingActions: canSwipe ? trailingActions : [],
          child: ListTile(
            onTap: onTap,
            visualDensity: const VisualDensity(
              vertical: VisualDensity.minimumDensity,
            ),
            title: RichText(
              text: highlightText(
                  context: context,
                  value: model.name,
                  searchQuery: searchValue,
                  textStyle: textStyle,
                  textHighLightStyle: textHighLightStyle),
            ),
            subtitle: Text(
              l10n.item_widget__created(
                  dateFormatter.format(model.createdDate)),
              style: appTextStyles?.subtitle,
              overflow: TextOverflow.ellipsis,
            ),
            leading: model.destinationId == null
                ? model.isFolder
                    ? folderIcon
                    : fileIcon
                : linkIcon,
            trailing: showPopUpMenuButton
                ? _ItemPopUpWidget(
                    onTap: _onTapMenuButton,
                  )
                : canSwipe
                    ? null
                    : IconButton(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: appColors?.textColor,
                        ),
                        onPressed: () {
                          final path = pathBuilder?.call();
                          if (path != null) {
                            showPathBottomSheet(context, path: path);
                          }
                        },
                      ),
          ),
        ),
      ],
    );
  }

  void _onTapMenuButton(Menu menu) => switch (menu) {
        Menu.move => onMove?.call(),
        Menu.rename => onEdit?.call(),
        Menu.delete => onDelete?.call(),
      };

  Widget _buildIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDim.four),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}

/// RU: [highlightText] функция выделения текста:
/// [value] - основной текст, который нужно выделить;
/// [searchQuery] - искомый текст в основном тексте;
/// [textStyle] - стиль основного текста (аргумент не обязательный, по умолчанию используется [UnibankStyles.listItemSubtitleTextStyle]);
/// [textHighLightStyle] - стиль выделенного текста (аргумент не обязательный, по умолчанию используется [UnibankStyles.listItemTitleTextStyle]);
///
/// ENG: [highlightText] is a text highlighting function:
/// [value] - the main text to be highlighting;
/// [searchQuery] - the search text in the main text;
/// [textStyle] - style of the main text (the argument is optional, by default [UnibankStyles.listItemSubtitleTextStyle]);
/// [textHighLightStyle] - style of the selected text (the argument is optional, the default is [UnibankStyles.listItemTitleTextStyle]);
///
TextSpan highlightText({
  required BuildContext context,
  required String value,
  required String searchQuery,
  Function? onHighlightedTextTap,
  required TextStyle textStyle,
  required TextStyle textHighLightStyle,
}) {
  TextStyle defStyle = textStyle;
  TextStyle customStyle = textHighLightStyle;

  List<InlineSpan> children = [];
  final lowerValue = value.toLowerCase();
  final lowerSearchQuery = searchQuery.toLowerCase();

  if (searchQuery.isNotEmpty && lowerValue.contains(lowerSearchQuery)) {
    var firstIndex = lowerValue.indexOf(lowerSearchQuery);
    var lastIndex = lowerValue.indexOf(lowerSearchQuery) + searchQuery.length;

    children
      ..add(TextSpan(text: value.substring(0, firstIndex)))
      ..add(TextSpan(
        style: customStyle,
        text: value.substring(firstIndex, lastIndex),
        recognizer: TapGestureRecognizer()
          ..onTap = onHighlightedTextTap as GestureTapCallback?,
      ))
      ..add(TextSpan(text: value.substring(lastIndex, value.length)));
  } else {
    children.add(TextSpan(text: value));
  }

  return TextSpan(style: defStyle, children: children);
}

enum Menu { move, rename, delete }

class _ItemPopUpWidget extends StatelessWidget {
  const _ItemPopUpWidget({
    super.key,
    required this.onTap,
  });

  final ValueChanged<Menu> onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorsExt? appColors = Theme.of(context).extension<AppColorsExt>();
    final AppTextStyleExt? appTextStyles =
        Theme.of(context).extension<AppTextStyleExt>();
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: PopupMenuButton<Menu>(
        color: appColors?.bodyColor,
        padding: EdgeInsets.zero,
        shape: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(AppDim.eight))),
        icon: const Icon(Icons.more_vert),
        onSelected: (Menu item) {},
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          PopupMenuItem<Menu>(
            value: Menu.move,
            onTap: () => onTap(Menu.move),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(
                vertical: VisualDensity.minimumDensity,
                horizontal: VisualDensity.minimumDensity,
              ),
              leading: Icon(
                Icons.open_with_rounded,
                color: appColors?.textColor,
                size: AppDim.twentyFour,
              ),
              title: Text(
                l10n.item_widget__move.capitalized,
                style: appTextStyles?.subtitle?.copyWith(
                  color: appColors?.textColor,
                ),
              ),
            ),
          ),
          PopupMenuItem<Menu>(
            value: Menu.rename,
            onTap: () => onTap(Menu.rename),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(
                vertical: VisualDensity.minimumDensity,
                horizontal: VisualDensity.minimumDensity,
              ),
              leading: Icon(
                Icons.edit,
                color: appColors?.textColor,
                size: AppDim.twentyFour,
              ),
              title: Text(
                l10n.item_widget__rename.capitalized,
                style: appTextStyles?.subtitle?.copyWith(
                  color: appColors?.textColor,
                ),
              ),
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<Menu>(
            value: Menu.delete,
            onTap: () => onTap(Menu.delete),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(
                vertical: VisualDensity.minimumDensity,
                horizontal: VisualDensity.minimumDensity,
              ),
              leading: Icon(
                Icons.delete,
                color: appColors?.negativeActionColor,
                size: AppDim.twentyFour,
              ),
              title: Text(
                l10n.item_widget__delete.capitalized,
                style: appTextStyles?.subtitle?.copyWith(
                  color: appColors?.negativeActionColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
