import 'package:flutter/gestures.dart';
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
  final String searchValue;
  final int id;
  final bool canSwipe;
  final Function()? onDelete;
  final Function()? onEdit;
  final Function() onTap;

  const ItemWidget(
      {Key? key,
      required this.model,
      required this.onTap,
      required this.id,
      this.canSwipe = true,
      this.searchValue = '',
      this.onDelete,
      this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColorsExt? appColors = Theme.of(context).extension<AppColorsExt>();
    final AppTextStyleExt? appTextStyles = Theme.of(context).extension<AppTextStyleExt>();
    final folderIcon = SvgPicture.asset(
      AppIcons.icFolder,
      color: appColors?.textColor,
    );
    final fileIcon = SvgPicture.asset(
      AppIcons.icFile,
      color: appColors?.textColor,
    );
    final l10n = AppLocalizations.of(context)!;
    final leadingActions = [
      SwipeAction(
        icon: const Icon(
          Icons.edit,
          color: Colors.white,
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
        icon: const Icon(
          Icons.delete,
          color: Colors.white,
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
    final textHighLightStyle =
        appTextStyles?.titleMedium?.copyWith(backgroundColor: Colors.grey[600]) ?? const TextStyle();

    return Column(
      children: [
        SwipeActionCell(
          key: ValueKey(id),
          leadingActions: canSwipe ? leadingActions : [],
          trailingActions: canSwipe ? trailingActions : [],
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
                                  RichText(
                                    text: highlightText(
                                        context: context,
                                        value: model.name,
                                        searchQuery: searchValue,
                                        textStyle: textStyle,
                                        textHighLightStyle: textHighLightStyle),
                                  ),
                                  Text(
                                    l10n.item_widget__created(dateFormatter.format(model.createdDate)),
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
        recognizer: TapGestureRecognizer()..onTap = onHighlightedTextTap as GestureTapCallback?,
      ))
      ..add(TextSpan(text: value.substring(lastIndex, value.length)));
  } else {
    children.add(TextSpan(text: value));
  }

  return TextSpan(style: defStyle, children: children);
}
