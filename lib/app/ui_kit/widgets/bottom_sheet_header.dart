import 'package:flutter/material.dart';

/// RU: Класс [UniBottomSheet] - конфигурация заголовка bottom sheet;
///
/// EN: Class [UniBottomSheet] - bottom sheet header configuration;
///
class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.closeIcon,
    this.topBorderRadius = Radius.zero,
    this.maxLines,
  }) : super(key: key);

  /// RU: аргумент [title] - текст заголовка.
  ///
  /// EN: argument [title] - title text.
  ///
  final String title;

  /// RU: аргумент [closeIcon] - иконка закрытия.
  ///
  /// EN: the [closeIcon] argument is the close icon.
  ///
  final Widget closeIcon;

  /// RU: аргумент [onPressed] - callback, вызываемый при нажатии на иконку закрытия.
  ///
  /// EN: the [onPressed] argument is a callback called when the close icon is clicked.
  ///
  final void Function() onPressed;

  /// RU: аргумент [topBorderRadius] - радиус закругления верхней границы bottom sheet.
  ///
  /// EN: argument [topBorderRadius] - the radius of the top border of the bottom sheet.
  ///
  final Radius topBorderRadius;

  /// RU: аргумент [maxLines] - максимальное количество строк для охвата текста.
  ///
  /// EN: the [maxLines] argument is the maximum number of lines to span the text.
  ///
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: topBorderRadius,
          topRight: topBorderRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            Container(
              height: 4,
              width: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFE9ECF2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline6,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    maxLines: maxLines,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: onPressed,
                  child: closeIcon,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
