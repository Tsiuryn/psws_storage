import 'package:flutter/material.dart';
import 'package:psws_storage/app/ui_kit/widgets/bottom_sheet_header.dart';

/// RU: Класс [UniDraggableScrollableSheet] - виджет, который можно перетаскивать и прокручивать одним жестом.
///
/// EN: Class [UniDraggableScrollableSheet] - a widget that can be dragged and scrolled in a single gesture.
///
class UniDraggableScrollableSheet extends StatelessWidget {
  const UniDraggableScrollableSheet({
    Key? key,
    required this.title,
    required this.actionButtonText,
    required this.content,
    required this.closeIcon,
    required this.initialChildSize,
    required this.minChildSize,
    required this.maxChildSize,
    required this.onClose,
    required this.onActionButtonPressed,
  }) : super(key: key);

  /// RU: аргумент [title] - текст заголовка.
  ///
  /// EN: argument [title] - title text.
  ///
  final String title;

  /// RU: аргумент [actionButtonText] - текст кнопки с действием.
  ///
  /// EN: argument [actionButtonText] - the text of the action button.
  ///
  final String actionButtonText;

  /// RU: аргумент [content] - виджет с контентом внутри bottom sheet.
  ///
  /// EN: the [content] argument is a widget with content inside the bottom sheet.
  ///
  final Widget content;

  /// RU: аргумент [closeIcon] - иконка закрытия.
  ///
  /// EN: the [closeIcon] argument is the close icon.
  ///
  final Widget closeIcon;

  /// RU: аргумент [initialChildSize] — это начальное дробное значение высоты родительского контейнера,
  /// используемое при отображении виджета.
  ///
  /// EN: the [initialChildSize] argument is the initial fractional value of the parent container's height
  /// to use when displaying the widget.
  ///
  final double initialChildSize;

  /// RU: аргумент [minChildSize] — это минимальное дробное значение высоты родительского контейнера, используемое при
  /// отображение виджета.
  ///
  /// EN: the [minChildSize] argument is the minimum fractional value of the parent container's height to use when
  /// displaying the widget.
  ///
  final double minChildSize;

  /// RU: аргумент [maxChildSize] — это максимальное дробное значение высоты родительского контейнера, используемое при
  /// отображение виджета.
  ///
  /// EN: the [maxChildSize] argument is the maximum fractional value of the parent container's height to use when
  /// displaying the widget.
  ///
  final double maxChildSize;

  /// RU: аргумент [onClose] - callback, вызываемый при нажатии на иконку закрытия.
  ///
  /// EN: the [onClose] argument is a callback called when the close icon is clicked.
  ///
  final void Function() onClose;

  /// RU: аргумент [onActionButtonPressed] - callback, вызываемый при нажатии на кнопку с действием.
  ///
  /// EN: the [onActionButtonPressed] argument is a callback called when the action button is clicked.
  ///
  final void Function() onActionButtonPressed;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (BuildContext context, ScrollController scrollController) {
        return Stack(
          children: <Widget>[
            Column(
              children: [
                NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowIndicator();

                    return true;
                  },
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: BottomSheetHeader(
                      title: title,
                      onPressed: onClose,
                      topBorderRadius: const Radius.circular(20.0),
                      maxLines: 2,
                      closeIcon: closeIcon,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    controller: scrollController,
                    child: content,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextButton(
                          onPressed: onActionButtonPressed,
                          child: Text(actionButtonText),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
