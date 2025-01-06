import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';
import 'package:psws_storage/app/theme/app_text_style_ext.dart';
import 'package:psws_storage/app/utils/constants.dart';
import 'package:psws_storage/app/utils/text_extensions.dart';
import 'package:psws_storage/habit/domain/entity/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final Function()? onDelete;
  final Function()? onEdit;
  final Function() onTap;

  const HabitTile({
    super.key,
    required this.habit,
    required this.onTap,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final AppTextStyleExt? appTextStyles =
        Theme.of(context).extension<AppTextStyleExt>();

    final l10n = AppLocalizations.of(context);

    final textStyle = appTextStyles?.titleMedium ?? const TextStyle();
    const TextStyle();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16,
          ),
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Checkbox(value: habit.completed, onChanged: (_) => onTap()),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        style: textStyle,
                      ),
                      Text(
                        l10n.item_widget__created(
                            dateFormatter.format(habit.startDate)),
                        style: appTextStyles?.subtitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _ItemPopUpWidget(
                  onTap: _onTapMenuButton,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onTapMenuButton(Menu menu) => switch (menu) {
        Menu.rename => onEdit?.call(),
        Menu.delete => onDelete?.call(),
      };
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

enum Menu { rename, delete }

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
